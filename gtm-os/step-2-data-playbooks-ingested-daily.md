# Step 2 — Data + Ops Models + Playbooks Ingested Daily

> Foundation · Day 1–4

## What this step is

Fill the repo's empty folders. **Airbyte → Supabase pulls everything Mento has, daily** — not just 12 won-deal transcripts. Snapshots of accounts, contacts, deals, activities; full Avoma transcript library; Slack threads on deal channels; the 200-account list; Apollo/Crunchbase/Sumble enrichment; L&D job-board feeds.

Then the **playbooks** — the rules-about-the-data — get written down as code in the repo: dedupe logic, enrichment runbooks, ICP scoring function, lifecycle state machine.

## Why this step matters

The shape distinguishes **data** (the raw lake) from **playbooks** (the rules running on top of it). Most companies have one or the other. Mento has neither in a usable place — HubSpot is the rep UI, not the system of record for derived data. This step builds both.

**The lake** = where Claude Code can find context when a stakeholder asks *"why did we close this account?"*
**The playbooks** = how Mento decides what's an ICP, what's a duplicate, what's an SQL, what's a churn risk. Written down, versioned, reviewable.

## What concrete work happens here

### The lake (Airbyte → Supabase, daily)
- HubSpot OAuth → daily mirror of contacts, accounts, deals, activities
- Avoma → transcripts + summaries
- Slack → deal-channel threads
- Apollo + Crunchbase + Sumble + The Org → firmographic + signal enrichment
- Greenhouse + Lever + TheirStack → job-board feeds
- A small ingest worker auto-front-matters each file and routes it into the repo tree

### The playbooks (written down as code in `mento-gtm/`)
- `sql/dedupe.sql` — match-key tiering + merge precedence
- `sql/v_priority_queue.sql` — trigger + ICP → priority score
- `sql/icp_v0.sql` → `sql/icp_v1_*.sql` — the scoring function, V0 today, V1 after the win-audit
- `sql/lifecycle_transitions.sql` — state machine with no-downgrade guarantee
- `foundation/playbooks/discovery.md`, `outbound.md` — rewritten live in Claude Code from Avoma evidence

### The three-lane rule (locked in across the repo)
- **Enrichment** = pulls outside data INTO Supabase tables (BlitzAPI, Crunchbase, Sumble, The Org, Firecrawl)
- **SQL** = organizes data we already have (reads tables → math → writes tables)
- **AI** = interprets unstructured + structured content (drafts, eval, summaries, edge-case escalation)

The three never overlap. A rep can always trace any number on screen back to *which lane produced it*.

## Which take-home sections live inside this step

- [Part 1 §1 — *"why everything, daily"*](../case-study/part1-diagnose-and-prioritize.md) — the data side
- **All of [Part 2 — Data Foundation Plan](../case-study/part2-data-foundation.md)** — the playbooks
  - Q1 — dedupe playbook
  - Q2 — enrichment playbook + orchestrator
  - Q3 — ICP scoring playbook (V0 → V1)
  - Q4 — lifecycle playbook (canonical B2B pattern, SiriusDecisions Demand Waterfall)

Part 2 is the heaviest part of the submission *because this is the heaviest step of the OS*. Without the substrate, every downstream automation is a house of cards.

## What's next

[Step 3 — Stakeholders into Claude Code on the repo](./step-3-stakeholders-in-claude-code.md) — Alex (and any opted-in stakeholder) installs Claude Code, opens the repo, runs their first prompts against their own data.
