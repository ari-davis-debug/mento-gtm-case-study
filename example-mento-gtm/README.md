# `example-mento-gtm/` — Live Scaffold

> A click-around example of what `mento-gtm/` looks like once stood up. **Not real Mento data.** Every file here is illustrative — names, deals, transcripts, signals, SQL are placeholders shaped to show the pattern.

## Why this folder exists

[`gtm-os/repo-file-structure.md`](../gtm-os/repo-file-structure.md) describes the recommended tree. This folder *is* that tree, scaffolded. Open the folders. Read a file. The shape should be obvious in 5 minutes.

## Where to click first

| If you want to see… | Open |
|---|---|
| **The rolling "what we currently believe wins deals" doc** | [`foundation/_synthesis.md`](./foundation/_synthesis.md) |
| **What an account folder looks like** | [`accounts/example-acme/deal.md`](./accounts/example-acme/deal.md) |
| **How a bottleneck gets captured** | [`bottlenecks/no-trigger-coverage-on-200-list.md`](./bottlenecks/no-trigger-coverage-on-200-list.md) |
| **The playbooks-as-code substrate** | [`sql/icp_v0.sql`](./sql/icp_v0.sql) and [`sql/v_priority_queue.sql`](./sql/v_priority_queue.sql) |
| **A rep-facing slash-command** | [`.claude/commands/200-list-check.md`](./.claude/commands/200-list-check.md) |
| **The constitution that keeps Claude consistent** | [`CLAUDE.md`](./CLAUDE.md) |
| **The first thing that gets built (Part 3's signal workflow)** | [`services/signal-workflow/spec.md`](./services/signal-workflow/spec.md) |

## What's deliberately not here

- **Raw lake data.** No `data/` folder. If Step 2b is stood up, Supabase/BigQuery holds the lake — Claude reads it via the SQL files in `sql/`. Otherwise one-off exports drop into `ingest/raw/` and get processed into `accounts/<slug>/`.
- **Per-rep folders.** Reps don't own folders, they own workflows. Their outputs land in `accounts/`, `bottlenecks/`, `ideas/`.
- **A `notes/` graveyard.** Everything has a home. If a thought is worth keeping, it lands in `foundation/`, `knowledge-base/`, `ideas/`, or `research/`.

## How to read this scaffold

1. Start at [`CLAUDE.md`](./CLAUDE.md) — the constitution
2. Then [`foundation/_synthesis.md`](./foundation/_synthesis.md) — the rolling belief
3. Then [`accounts/example-acme/deal.md`](./accounts/example-acme/deal.md) — what reading-an-account looks like
4. Then [`bottlenecks/_synthesis.md`](./bottlenecks/_synthesis.md) — the ranked queue
5. Then `sql/` for the playbooks-as-code substrate

Every file shows you *the shape*, not the substance. Substance gets filled in once real Mento data is in.
