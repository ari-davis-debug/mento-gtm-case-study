--! WHAT: Idempotency for signal_events. Prevents a single trigger from firing twice.
--! WHY: Clay can re-emit the same LinkedIn event if its weekly snapshot includes a
--!      row that was already-new last week. We don't want duplicate outbound.
--! BREAKS IF: trigger_id is not a deterministic hash (e.g., includes a timestamp).
--! UPDATED: 2026-05-11

-- Convention: trigger_id is a deterministic hash of (account_id, event_type, event_date).
-- Recomputing it from the same inputs always yields the same id.

-- This unique constraint is what prevents the duplicate insert.
alter table signal_events
  add constraint signal_events_trigger_id_unique
  unique (trigger_id);

-- Insert pattern used by Clay webhooks + cron jobs:
insert into signal_events (
  trigger_id, account_id, event_type, event_date,
  source, confidence, public_evidence_url, discovered_at
)
values (
  -- Deterministic hash so re-runs no-op
  md5(:account_id || ':' || :event_type || ':' || :event_date),
  :account_id, :event_type, :event_date,
  :source, :confidence, :public_evidence_url, now()
)
on conflict (trigger_id) do nothing
returning id, account_id, event_type;

--! WHY DETERMINISTIC HASH, NOT UUID
--! UUIDs would make every insert succeed, creating duplicates. The hash is
--! the "this is the same trigger" assertion in code.
--!
--! HOW TO DEBUG A MISSING TRIGGER
--! 1. Recompute the expected trigger_id manually
--! 2. SELECT from signal_events WHERE trigger_id = '<expected>'
--! 3. If present: trigger fired correctly, downstream issue
--! 4. If absent: enrichment lane didn't emit; check Clay logs
