# `example-mento-gtm/` — Live Scaffold

> A click-around example of what `mento-gtm/` looks like once stood up. **Not real Mento data.** Every file here is illustrative — names, deals, transcripts, signals, SQL are placeholders shaped to show the pattern.

## 👉 If you only have 5 minutes, click these 3 files

1. **[`foundation/_synthesis.md`](./foundation/_synthesis.md)** — the rolling "what we currently believe wins deals." This is the file the team rewrites monthly. **The whole OS rotates around this doc.**
2. **[`accounts/example-acme/deal.md`](./accounts/example-acme/deal.md)** — what one account folder looks like, fully filled out. Score 87/100, lane-labeled sources, every claim traceable.
3. **[`bottlenecks/_synthesis.md`](./bottlenecks/_synthesis.md)** — the ranked queue. **Top-1 is what Step 5 builds first.** Every bottleneck has its own file with scoring rationale.

Those three files show you the read → score → build loop in 5 minutes. Everything else is supporting structure.

## Why this folder exists

[`gtm-os/repo-file-structure.md`](../gtm-os/repo-file-structure.md) describes the recommended tree. This folder *is* that tree, scaffolded. Open the folders. Read a file. The shape should be obvious.

## Where to click next (the longer tour)

| If you want to see… | Open |
|---|---|
| **The playbooks-as-code substrate** | [`sql/v_priority_queue.sql`](./sql/v_priority_queue.sql) — the canonical SQL→AI handoff |
| **How ICP gets scored** | [`sql/icp_v0.sql`](./sql/icp_v0.sql) — hand-weighted V0; [`sql/icp_v1_refit.sql`](./sql/icp_v1_refit.sql) — logistic regression V1 |
| **The first thing that gets built (Part 3's signal workflow)** | [`services/signal-workflow/spec.md`](./services/signal-workflow/spec.md) |
| **A rep-facing slash-command** | [`.claude/commands/200-list-check.md`](./.claude/commands/200-list-check.md) |
| **The constitution that keeps Claude consistent** | [`CLAUDE.md`](./CLAUDE.md) |
| **The three-lane rule (Enrichment / SQL / AI never overlap)** | [`knowledge-base/methodology/three-lane-rule.md`](./knowledge-base/methodology/three-lane-rule.md) |
| **An ICP archetype with weights + disqualifiers** | [`foundation/icp.md`](./foundation/icp.md) |
| **A worked outbound email by trigger type** | [`foundation/playbooks/outbound.md`](./foundation/playbooks/outbound.md) |

## What's deliberately not here

- **Raw lake data.** No `data/` folder. If Step 2b is stood up, Supabase/BigQuery holds the lake — Claude reads it via the SQL files in `sql/`. Otherwise one-off exports drop into `ingest/raw/` and get processed into `accounts/<slug>/`.
- **Per-rep folders.** Reps don't own folders, they own workflows. Their outputs land in `accounts/`, `bottlenecks/`, `ideas/`.
- **A `notes/` graveyard.** Everything has a home. If a thought is worth keeping, it lands in `foundation/`, `knowledge-base/`, `ideas/`, or `research/`.

## The 15-minute read (full tour)

1. [`CLAUDE.md`](./CLAUDE.md) — the constitution
2. [`foundation/_synthesis.md`](./foundation/_synthesis.md) — rolling belief
3. [`foundation/icp.md`](./foundation/icp.md) — the scorecard
4. [`accounts/example-acme/deal.md`](./accounts/example-acme/deal.md) — what reading-an-account looks like
5. [`accounts/example-acme/timeline.md`](./accounts/example-acme/timeline.md) — the 90-day signal chronology
6. [`bottlenecks/_synthesis.md`](./bottlenecks/_synthesis.md) — ranked queue
7. [`bottlenecks/no-trigger-coverage-on-200-list.md`](./bottlenecks/no-trigger-coverage-on-200-list.md) — the #1 in detail
8. [`sql/v_priority_queue.sql`](./sql/v_priority_queue.sql) — the SQL→AI handoff
9. [`services/signal-workflow/spec.md`](./services/signal-workflow/spec.md) — what gets built

Every file shows you *the shape*, not the substance. Substance gets filled in once real Mento data is in.
