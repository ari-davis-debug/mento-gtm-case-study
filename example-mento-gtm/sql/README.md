# sql/

> Playbooks-as-code. Every SQL file here is a deterministic rule that runs against the lake (Supabase or BigQuery, depending on Step 2b choice).

## Why SQL, not Python notebooks

- **Reviewable in PR diffs.** A weight change in `icp_v1_refit.sql` shows up as `+0.21 → +0.28`, not as a cell output in a notebook.
- **Re-runnable.** Any rep with read access to the lake can re-run a query and get the same answer.
- **Auditable.** When we say "we scored Acme 87/100," we can show the exact query.

## What lives here

| File | What it does | How often it runs |
|---|---|---|
| `dedupe.sql` | Idempotency for `signal_events` (no double-fire on same trigger) | On every write |
| `icp_v0.sql` | Hand-weighted ICP scorecard | Monthly until V1 ready |
| `icp_v1_refit.sql` | Logistic regression refit on closed-won outcomes | Monthly |
| `v_priority_queue.sql` | The view that emits the rep queue | Hourly |
| `lifecycle_transitions.sql` | Tracks account stage moves (cold → engaged → demo → close) | Daily |
| `outcomes_attribution.sql` | Joins close-won/lost back to the triggering signal | Weekly |

## Lane discipline

These files live in the **SQL lane** ([[../knowledge-base/methodology/three-lane-rule.md]]). They:
- ✅ Compute, join, dedupe, score, attribute
- ❌ Generate text (that's AI)
- ❌ Hit external APIs (that's enrichment)

If a SQL file is reaching for an LLM, it's been miscategorized.

## How to read these (for reviewers)

Each file is annotated heavily. The convention is:
- `--! WHAT:` describes the output
- `--! WHY:` describes the business reason
- `--! BREAKS IF:` describes what would invalidate the query

This means you can read the SQL like a doc and infer the system from the queries alone.
