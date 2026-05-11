--! WHAT: Joins closed deals back to the signal that originated them.
--! WHY: Without this, we can't know which triggers actually predict revenue.
--!      Powers the monthly bottleneck re-rank.
--! BREAKS IF: signal_events.actioned_at is null for closed-won accounts (means trigger never marked).
--! UPDATED: 2026-05-11

create or replace view v_outcomes_attribution as
with first_trigger as (
  -- The earliest trigger that fired before the account moved to "engaged"
  select distinct on (se.account_id)
    se.account_id,
    se.event_type as originating_trigger,
    se.event_date as trigger_date,
    se.discovered_at as trigger_discovered_at
  from signal_events se
  join accounts a on a.id = se.account_id
  where se.actioned_at is not null
    and a.outcome in ('closed_won', 'closed_lost')
  order by se.account_id, se.discovered_at asc
),
deal_stats as (
  select
    a.id, a.name, a.outcome, a.closed_at, a.contract_value,
    ft.originating_trigger, ft.trigger_date, ft.trigger_discovered_at,
    extract(epoch from (a.closed_at - ft.trigger_discovered_at)) / 86400 as days_trigger_to_close,
    extract(epoch from (ft.trigger_discovered_at - ft.trigger_date)) / 86400 as days_event_to_discovery
  from accounts a
  join first_trigger ft on ft.account_id = a.id
)
select
  originating_trigger,
  count(*) as total_deals,
  sum(case when outcome = 'closed_won' then 1 else 0 end) as wins,
  sum(case when outcome = 'closed_lost' then 1 else 0 end) as losses,
  round(
    100.0 * sum(case when outcome = 'closed_won' then 1 else 0 end) / nullif(count(*), 0),
    1
  ) as win_rate_pct,
  round(avg(days_trigger_to_close)::numeric, 1) as avg_days_trigger_to_close,
  round(avg(days_event_to_discovery)::numeric, 1) as avg_days_event_to_discovery,
  sum(case when outcome = 'closed_won' then contract_value else 0 end) as revenue_attributed
from deal_stats
group by originating_trigger
order by win_rate_pct desc, total_deals desc;

--! HOW THIS GETS USED
--! - Monthly: scan win_rate_pct. Triggers below 20% get demoted in v_priority_queue weights.
--! - Quarterly: revenue_attributed feeds the bottleneck re-rank — if a trigger
--!   sources $X but takes 90+ days to discover, the latency itself is the bottleneck.
--! - One-off: when someone asks "what predicts wins?" the answer is one SQL run.
--!
--! WHAT BREAKS THE PICTURE
--! - "First trigger" attribution is biased toward the trigger we detect first,
--!   which is often the trigger Clay covers, not necessarily the causal trigger.
--! - Multi-touch attribution would be more honest but is overkill for 2 reps + 200 accounts.
