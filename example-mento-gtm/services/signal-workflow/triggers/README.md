# triggers/

> Trigger.dev tasks. The runtime that polls the SQL lane and dispatches to the AI lane.

## Tasks

| File | Schedule | What it does |
|---|---|---|
| `trigger-watcher.ts` | hourly cron | Polls `v_priority_queue` where `ready_for_ai_draft = true`; emits one `draft-needed` event per row |
| `draft-generator.ts` | event-driven | Receives `draft-needed`; loads context; calls LLM; runs eval; ships to rep inbox |
| `actioned-watcher.ts` | hourly cron | Polls HubSpot for replies; marks `actioned_at` in `signal_events`; pauses queue for that account |

## Why Trigger.dev (not cron + Express)

- **Retry semantics for free** — if an LLM call fails, Trigger retries with backoff. Our cron would have to re-implement that.
- **Observability** — every run has a dashboard URL we can paste in PRs ("this draft was generated here").
- **Concurrency limits** — for 200 accounts, we never need more than a few drafts at once. Trigger's queue prevents accidental fan-out.

## Lane rule reminder

This folder is the **runtime**. It shuttles data between lanes. It does not:
- Generate text (that's `prompts/` + LLM)
- Score (that's `eval/`)
- Run SQL beyond simple reads of `v_priority_queue`
