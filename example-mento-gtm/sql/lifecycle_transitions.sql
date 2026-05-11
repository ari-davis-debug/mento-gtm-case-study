--! WHAT: Tracks every state change of an account (cold → engaged → demo → close).
--! WHY: Lets us compute time-in-stage and identify accounts stuck in one state.
--! BREAKS IF: HubSpot stage names change without updating the mapping.
--! UPDATED: 2026-05-11

create table if not exists account_lifecycle_events (
  id bigserial primary key,
  account_id text not null references accounts(id),
  from_stage text,
  to_stage text not null,
  transitioned_at timestamptz not null default now(),
  source text not null check (source in ('hubspot_sync', 'manual', 'signal_workflow')),
  notes text
);

-- The view reps actually read
create or replace view v_stuck_accounts as
select
  a.id, a.name, a.tier,
  ale.to_stage as current_stage,
  ale.transitioned_at as stage_entered_at,
  now() - ale.transitioned_at as time_in_stage,
  case
    when ale.to_stage = 'engaged' and now() - ale.transitioned_at > interval '14 days' then 'stuck_in_engaged'
    when ale.to_stage = 'demo_scheduled' and now() - ale.transitioned_at > interval '21 days' then 'stuck_in_demo'
    when ale.to_stage = 'proposal' and now() - ale.transitioned_at > interval '30 days' then 'stuck_in_proposal'
    else null
  end as stuck_flag
from accounts a
join lateral (
  select to_stage, transitioned_at
  from account_lifecycle_events
  where account_id = a.id
  order by transitioned_at desc
  limit 1
) ale on true
where ale.to_stage not in ('closed_won', 'closed_lost');

--! WHY 14/21/30 DAY THRESHOLDS
--! Pulled from historical median time-in-stage for closed-won deals.
--! Anything longer than median + 1 SD = "stuck" warning.
--! These thresholds refit monthly as more deals close.
--!
--! WHAT REPS DO WITH THIS
--! v_stuck_accounts is the source for the weekly Friday review. Each stuck
--! account either gets a documented re-engagement touch or moved to "nurture."
