--! WHAT: The rep priority queue. One row per (account, trigger) ready for outbound.
--! WHY: This is the canonical handoff from the SQL lane to the AI lane.
--!      The signal-workflow service consumes this view and drafts outbound emails.
--! BREAKS IF: An account is missing from `accounts` or trigger_event_id is null.
--! UPDATED: 2026-05-11

create or replace view v_priority_queue as
with scored_triggers as (
  select
    se.id as trigger_event_id,
    se.account_id,
    se.event_type,
    se.event_date,
    se.discovered_at,
    se.confidence,
    -- ICP score weight (from icp_v0.sql for now, swaps to icp_v1 once refit lands)
    icp.score as icp_score,
    -- Trigger weight by event type (canonical CHRO hire = 1.0, others scaled)
    case se.event_type
      when 'chro_hire' then 1.00
      when 'series_c_funding' then 0.85
      when 'series_d_funding' then 0.85
      when 'headcount_delta_15pct' then 0.70
      when 'job_board_surge' then 0.55
      when 'vp_people_hire' then 0.50
      else 0.30
    end as trigger_weight
  from signal_events se
  join icp_scores icp on icp.account_id = se.account_id
  where se.actioned_at is null
    and se.discovered_at >= now() - interval '90 days'
),
ranked as (
  select
    st.*,
    -- Final priority = ICP × trigger weight × recency decay
    st.icp_score * st.trigger_weight *
      exp(-extract(epoch from (now() - st.event_date)) / (86400 * 30)) as priority_score
  from scored_triggers st
)
select
  r.trigger_event_id,
  r.account_id,
  a.name as account_name,
  a.tier,
  r.event_type,
  r.event_date,
  r.discovered_at,
  r.icp_score,
  r.trigger_weight,
  round(r.priority_score::numeric, 3) as priority_score,
  -- The "ready for AI" gate: high-confidence triggers + score above floor
  case when r.confidence = 'high' and r.priority_score > 0.40
       then true else false end as ready_for_ai_draft
from ranked r
join accounts a on a.id = r.account_id
where a.status = 'active'
order by r.priority_score desc, r.discovered_at asc;

--! NOTES
--! - The 0.40 floor is a Step-5 placeholder. After 30 days of close-loop data,
--!   the icp_v1_refit.sql query will refit this threshold.
--! - Recency decay constant (30 days) reflects Mento's empirical buying window.
--!   Confirmed by accounts/example-acme/timeline.md (CHRO hire → reply in 55 days).
--! - The AI lane reads this view ONLY. It never writes back. To mark a trigger
--!   actioned, the signal-workflow service writes to signal_events.actioned_at.
