--! WHAT: Monthly logistic regression refit. Replaces hand-weighted icp_v0.sql once N≥50.
--! WHY: V0 was reps' best guesses. V1 is the data-driven correction.
--! BREAKS IF: Outcomes table is empty or features have non-overlapping schema.
--! UPDATED: 2026-05-11 (PLACEHOLDER — fires when N reaches threshold)

-- This file runs in two phases:
-- 1. Compute coefficients (this script, monthly cron)
-- 2. Apply coefficients to live accounts (icp_scores view swaps over)

-- Phase 1: refit
with training_data as (
  select
    a.id,
    -- Same feature set as v0
    case a.stage when 'series_b' then 1 else 0 end as f_series_b,
    case a.stage when 'series_c' then 1 else 0 end as f_series_c,
    case a.stage when 'series_d' then 1 else 0 end as f_series_d,
    case when a.headcount between 150 and 400 then 1 else 0 end as f_headcount_sweet,
    case when exists (
      select 1 from signal_events se
      where se.account_id = a.id and se.event_type = 'chro_hire'
        and se.event_date between a.created_at and a.closed_at
    ) then 1 else 0 end as f_chro_hire,
    case when a.industry in ('software','fintech') then 1 else 0 end as f_industry_top,
    coalesce(a.posts_with_comp_bands_pct, 0) as f_comp_maturity,
    case when a.competitive_stack && array['pave','compa'] then 1 else 0 end as f_competitive_risk,
    -- Outcome (1 = closed-won, 0 = closed-lost)
    case when a.outcome = 'closed_won' then 1 else 0 end as outcome
  from accounts a
  where a.outcome in ('closed_won', 'closed_lost')
    and a.closed_at >= now() - interval '12 months'
)
-- Pseudocode: this is where we'd run a logistic regression via dbplyr,
-- or call out to a Python step that writes coefficients back to a table.
-- For Mento's scale (200-list, ~50 outcomes/quarter), a simple GLM in R or
-- statsmodels in Python is the cheapest correct answer.
select
  count(*) as n,
  sum(outcome) as wins,
  count(*) - sum(outcome) as losses,
  case when count(*) >= 50 then 'ready_to_refit' else 'wait_for_more_data' end as status
from training_data;

--! HOW THE COEFFICIENTS GET APPLIED
--! After Phase 1 emits coefficients (β_0, β_chro, β_stage, etc.), Phase 2
--! is a manual swap in v_priority_queue.sql:
--!
--!   icp_score = sigmoid(
--!     β_0 + β_chro*f_chro_hire + β_stage*f_series_c + ...
--!   )
--!
--! Reviewing this swap is a deliberate human checkpoint, not an auto-promote.
--! Reason: a bad refit (e.g., 3 weird losses skewing coefficients) can
--! produce surprising routing changes. Reps see the diff before it ships.

--! REFIT CADENCE
--! - Monthly cron
--! - Halts if N < 50 (returns 'wait_for_more_data')
--! - Halts if any coefficient flips sign vs. previous month (manual review)
