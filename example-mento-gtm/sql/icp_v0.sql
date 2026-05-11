--! WHAT: V0 ICP scorecard. Hand-weighted; runs until V1 (logistic regression) has enough close-loop data.
--! WHY: Reps need a fit score on day 1, not after 6 months of training data.
--! BREAKS IF: A dimension column is added without updating the weights.
--! UPDATED: 2026-05-11

create or replace view icp_scores as
with account_features as (
  select
    a.id as account_id,
    a.name,
    -- Stage signal (Series B/C/D = sweet spot)
    case a.stage
      when 'series_b' then 0.80
      when 'series_c' then 1.00
      when 'series_d' then 0.90
      when 'series_a' then 0.30
      when 'series_e_plus' then 0.40
      else 0.10
    end as stage_score,

    -- Headcount band
    case
      when a.headcount between 150 and 400 then 1.00
      when a.headcount between 100 and 149 then 0.70
      when a.headcount between 401 and 800 then 0.85
      when a.headcount > 800 then 0.50
      else 0.20
    end as headcount_score,

    -- HR-tech buyer indicator: has CHRO or VP People in last 180 days
    case when exists (
      select 1 from signal_events se
      where se.account_id = a.id
        and se.event_type in ('chro_hire', 'vp_people_hire')
        and se.event_date >= now() - interval '180 days'
    ) then 1.00 else 0.30 end as people_leader_score,

    -- Industry fit (Mento sells best into tech, biotech, fintech)
    case a.industry
      when 'software' then 1.00
      when 'fintech' then 0.95
      when 'biotech' then 0.85
      when 'healthtech' then 0.80
      when 'climate' then 0.70
      else 0.40
    end as industry_score,

    -- Compensation maturity signal (jobs posted with comp bands = mature)
    coalesce(a.posts_with_comp_bands_pct, 0) as comp_maturity_score,

    -- Competitive risk (Pave/Compa already in stack = penalty)
    case when a.competitive_stack && array['pave','compa']
         then 0.20 else 1.00 end as competitive_score
  from accounts a
)
select
  account_id,
  name,
  round((
    stage_score * 0.20 +
    headcount_score * 0.15 +
    people_leader_score * 0.30 +
    industry_score * 0.15 +
    comp_maturity_score * 0.10 +
    competitive_score * 0.10
  )::numeric, 3) as score,
  -- Component breakdown for debugging
  stage_score, headcount_score, people_leader_score,
  industry_score, comp_maturity_score, competitive_score
from account_features;

--! WEIGHTS RATIONALE
--! - people_leader_score gets the highest weight (0.30) because CHRO hire
--!   is the single most predictive signal we have (see knowledge-base/business/chro-hire-as-compelling-event.md).
--! - stage_score is heavier than headcount_score because we've seen 350-person
--!   Series A flop (no budget) and 180-person Series C close cleanly.
--! - competitive_score is binary-ish; if Pave is entrenched we usually lose.
--!
--! REFIT TRIGGER
--! When we have 50+ closed deals with full feature data, icp_v1_refit.sql
--! takes over. V0 will then become a fallback for accounts without enough features.
