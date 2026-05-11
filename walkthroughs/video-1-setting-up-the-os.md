# Video 1 — Setting Up the OS

> ~7 minutes · Audience: Alex (+ RevOps if there is one) · Goal: lake is alive, daily sync running, repo cloned

## What this video shows

By the end of 7 minutes, Mento's data is mirrored into Supabase on a daily schedule, the `mento-gtm/` repo is open on Alex's machine, and the folders that were empty 10 minutes ago have content flowing into them.

## Setup before hitting record

- Two browser windows open: **Airbyte Cloud dashboard** + **Supabase project dashboard**
- One terminal window open with `mento-gtm/` already cloned (we'll show the clone command on screen, then cut to the cloned tree — saves a minute of `git clone` waiting)
- Synthetic HubSpot + Avoma + Slack data pre-loaded in a sandbox account if Alex's real data isn't available yet
- VS Code (or Claude Code's editor view) open on `mento-gtm/`, sidebar visible

## Beat-by-beat

### 0:00–0:30 — What problem this video solves

> *"Mento has two years of data sitting in HubSpot, Avoma, Slack, and a spreadsheet of 200 target accounts. None of it is in a place where Claude Code — or a stakeholder — can ask questions across it. In the next 7 minutes we fix that."*

Frame the problem in one breath. Don't describe Airbyte yet.

### 0:30–1:30 — The shape of the OS

Switch to the cloned `mento-gtm/` repo in VS Code. Walk the tree:

```
mento-gtm/
├── foundation/                 # who Mento is — synthesis, ICP, playbooks
├── data/                       # mirrors of HubSpot, Avoma, Slack, enrichment
├── accounts/<account-slug>/    # one folder per top account, auto-assembled
├── bottlenecks/                # captured in Step 4
├── ideas/                      # rep-flagged what-ifs
└── sql/                        # dedupe, scoring, lifecycle — the playbooks
```

> *"Everything Mento has flows into `data/`. The folders inside it stay empty until we connect Airbyte. So that's the next move."*

### 1:30–4:00 — Airbyte: connect every source via OAuth

Switch to Airbyte Cloud. **One source at a time, OAuth flow each:**

1. **HubSpot source** → click *"Authorize"* → standard HubSpot OAuth screen → granted → destination = Supabase Postgres → sync = *daily, full refresh on accounts/contacts/deals, incremental on activities*
2. **Avoma source** → same OAuth flow → destination = Supabase → daily sync of transcripts + summaries
3. **Slack source** → OAuth → channel scope (the deal-discussion channels Alex picks) → daily sync of threads
4. **Apollo / Crunchbase / Sumble** → API key sources (no OAuth on these — show the secrets manager pattern, *don't paste keys on screen*)

> *"Airbyte is the only piece of this stack we get to not build. We're not writing scrapers. We're not babysitting webhooks. Alex authorizes each source once via the same OAuth dance you've already done a hundred times — Google, GitHub, anything — and the daily sync is live."*

> *"Why daily, not real-time? Because most Mento signals — funding, exec hires, headcount — are not real-time signals. They're 6–18 month patterns. Daily is the right cadence for the data; the live webhooks for Crunchbase funding events sit on top of this baseline, not instead of it."*

Show one sync running. Point at the sync log filling in.

### 4:00–5:30 — The lake comes alive in Supabase

Switch to Supabase dashboard.

Show the Tables view. The tables Airbyte just created:

- `hubspot_contacts`, `hubspot_accounts`, `hubspot_deals`, `hubspot_activities`
- `avoma_transcripts`, `avoma_summaries`
- `slack_messages` (the deal-channel threads)
- `crunchbase_funding_events`, `crunchbase_people`
- `sumble_hiring_signals`, `sumble_headcount`

Run a quick SQL in the Supabase SQL editor:

```sql
select count(*) from hubspot_contacts;
select count(*) from avoma_transcripts where created_at > now() - interval '90 days';
select account_slug, count(*) as transcript_count
from avoma_transcripts
group by account_slug
order by transcript_count desc
limit 10;
```

> *"This is what 'the lake' means. Two years of Mento's data, in one place, queryable with SQL. We don't have to write integrations — we have to write the playbooks that run on top of this."*

### 5:30–6:30 — Back to the repo: data folder is alive

Switch back to VS Code. The `data/` folder that was empty at 1:00 now has subfolders auto-populating via a small ingest worker that watches the Supabase tables and writes markdown front-mattered snapshots into the repo tree:

```
mento-gtm/data/
├── hubspot/
│   ├── 2026-05-11/
│   │   ├── accounts.snapshot.md
│   │   ├── deals.snapshot.md
│   │   └── activities.snapshot.md
├── avoma/
│   └── transcripts/
│       └── 2026-05-11/...
├── slack/
└── signals/
```

> *"The Supabase tables are the system of record. The repo files are what Claude Code reads when you're working in the terminal. Same data, two views — one for math, one for context."*

### 6:30–7:00 — What you just unlocked

> *"From this moment forward, every stakeholder — Alex, future RevOps hires, anyone Mento brings in — can clone this repo, open Claude Code, and ask questions across HubSpot, Avoma, and Slack at the same time without writing a line of SQL. That's the foundation for everything in videos 2–5."*

> *"Tomorrow's video: Alex opens Claude Code and runs his first three prompts against this data."*

## What the viewer walks away knowing

- **Airbyte does the integration plumbing.** OAuth into each source once. Daily sync to Supabase.
- **Supabase is the system of record.** All derived data — scores, dedupe, lifecycle — lives there.
- **The repo is the working surface.** It mirrors the lake into markdown + SQL files Claude Code can read.
- **No API keys floating around.** OAuth for HubSpot / Avoma / Slack; secrets manager for the rest.

## Common questions this video should answer

- *"Does Airbyte have a connector for X?"* → Airbyte Cloud ships 350+ connectors as of 2026; HubSpot, Avoma (via Avoma's API), Slack, Apollo, Crunchbase, Sumble are all natively supported. If something's missing, Airbyte's CDK lets us write a custom connector in a day.
- *"Is this expensive?"* → Airbyte Cloud's pricing is per-row-synced. At Mento's scale (5K contacts, ~1K deals, ~12 won-deal transcripts) the daily sync runs comfortably under $100/mo, often under $50.
- *"What if HubSpot data is messy?"* → That's what the dedupe playbook (`sql/dedupe.sql`) is for. We don't fix HubSpot at the source; we mirror it, clean it in Supabase, and push verified properties back. Detailed in Part 2 Q1.
- *"Who else needs to authorize?"* → Just Alex for the OAuth flows. He's the workspace admin on all three (HubSpot, Avoma, Slack). The API-key sources (Apollo, Crunchbase, Sumble) get added to the Airbyte secrets manager once.
- *"What about real-time signals like funding announcements?"* → Daily sync is the baseline. Crunchbase has a webhook for funding events that fires immediately on announcement — that webhook lands in a separate `signal_events` table, on top of the daily lake. Covered in video 4.
