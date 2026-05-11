# 1 — Installation and Setup

> Audience: Alex (+ RevOps if there is one) · Outcome: lake alive, daily sync running, repo cloned

## What this walkthrough covers

How you'd stand up the foundation: every Mento source authorized into Airbyte, mirrored daily into Supabase, with the `mento-gtm/` repo cloned and ready for Claude Code to read. Your exact stack may differ — swap your equivalent for any tool below.

## What you need installed before starting

| Layer | Tool | Why |
|---|---|---|
| Repo working surface | **Claude Code** + **GitHub Desktop** + git | Where stakeholders ask the system questions |
| Data lake | **Supabase** project (free tier fine to start) | Postgres + pgvector — system of record |
| Ingestion | **Airbyte** (Cloud or self-hosted OSS) | OAuth connectors, 350+ sources, daily sync to Supabase |
| Orchestration | **Trigger.dev** project | Where the signal-workflow jobs run (walkthrough 4) |
| Source-system admin access | **HubSpot**, **Avoma**, **Slack** | Workspace admin needed to authorize OAuth scopes |
| Outbound execution | **SmartLead** account | Multi-channel sequencing (email + LinkedIn + SMS) |
| Enrichment API keys | **BlitzAPI**, **Crunchbase Pro**, **Sumble**, **BuiltWith / TheirStack** | Verified contacts + signal sources |

Stack choices are illustrative — if Mento already uses Fivetran, n8n, or another orchestrator, the pattern still works.

## Step 1 — Clone the repo, see the shape

```bash
git clone git@github.com:mento/mento-gtm.git
cd mento-gtm/
```

The tree:

```
mento-gtm/
├── foundation/                 # who Mento is — synthesis, ICP, playbooks
├── data/                       # mirrors of HubSpot, Avoma, Slack, enrichment
├── accounts/<account-slug>/    # one folder per top account, auto-assembled
├── bottlenecks/                # captured in walkthrough 3
├── ideas/                      # rep-flagged what-ifs
└── sql/                        # dedupe, scoring, lifecycle — the playbooks
```

Everything Mento has flows into `data/`. The subfolders stay empty until Airbyte is connected — that's the next step.

## Step 2 — Airbyte: authorize every source via OAuth

In the Airbyte dashboard, add one source at a time:

1. **HubSpot** → *Authorize* → standard HubSpot OAuth → destination = Supabase Postgres → sync schedule = *daily*, full refresh on accounts/contacts/deals, incremental on activities
2. **Avoma** → OAuth → destination = Supabase → daily sync of transcripts + summaries
3. **Slack** → OAuth → scope the deal-discussion channels Alex picks → daily sync of threads
4. **Apollo / Crunchbase / Sumble** → API-key sources (no OAuth on these) — paste keys into Airbyte's secrets manager, **never** into code

Airbyte is the only piece of the stack we get to *not build*. No scrapers. No babysitting webhooks. Alex authorizes each source once via the same OAuth flow he's done a hundred times — Google, GitHub, anything — and the daily sync is live.

**Why daily, not real-time?** Most Mento signals — funding, exec hires, headcount — are not real-time. They're 6–18 month patterns. Daily is the right cadence for the baseline. Real-time webhooks (e.g. Crunchbase funding events) sit on top of the daily lake, not instead of it.

## Step 3 — Confirm the lake is alive in Supabase

In the Supabase dashboard, the tables Airbyte just created should appear:

- `hubspot_contacts`, `hubspot_accounts`, `hubspot_deals`, `hubspot_activities`
- `avoma_transcripts`, `avoma_summaries`
- `slack_messages` (the deal-channel threads)
- `crunchbase_funding_events`, `crunchbase_people`
- `sumble_hiring_signals`, `sumble_headcount`

Quick sanity check in the Supabase SQL editor:

```sql
select count(*) from hubspot_contacts;

select count(*) from avoma_transcripts
where created_at > now() - interval '90 days';

select account_slug, count(*) as transcript_count
from avoma_transcripts
group by account_slug
order by transcript_count desc
limit 10;
```

If counts look reasonable, the lake is alive. Two years of Mento's data, in one place, queryable with SQL.

## Step 4 — The repo's `data/` folder fills itself

A small ingest worker watches the Supabase tables and writes markdown front-mattered snapshots into the repo tree. After a day, `data/` looks like:

```
mento-gtm/data/
├── hubspot/
│   └── 2026-05-11/
│       ├── accounts.snapshot.md
│       ├── deals.snapshot.md
│       └── activities.snapshot.md
├── avoma/
│   └── transcripts/
│       └── 2026-05-11/...
├── slack/
└── signals/
```

The Supabase tables are the **system of record**. The repo files are what **Claude Code reads** when you're working in the terminal. Same data, two views — one for math, one for context.

## What you've unlocked

- **Airbyte does the integration plumbing.** OAuth once per source. Daily sync to Supabase.
- **Supabase is the system of record.** All derived data — scores, dedupe, lifecycle — lives there.
- **The repo is the working surface.** It mirrors the lake into markdown + SQL files Claude Code can read.
- **No API keys floating around.** OAuth for HubSpot / Avoma / Slack; secrets manager for the rest.

From this moment forward, every stakeholder can clone this repo, open Claude Code, and ask questions across HubSpot, Avoma, and Slack at the same time without writing a line of SQL. That's the foundation for walkthroughs 2–5.

## Common questions

- **Does Airbyte have a connector for X?** Airbyte ships 350+ connectors as of 2026; HubSpot, Avoma, Slack, Apollo, Crunchbase, Sumble are all natively supported. If something's missing, Airbyte's CDK lets us write a custom connector in a day.
- **Is this expensive?** Airbyte Cloud's pricing is per-row-synced. At Mento's scale (5K contacts, ~1K deals, ~12 won-deal transcripts) the daily sync runs comfortably under $100/mo, often under $50.
- **What if HubSpot data is messy?** That's what the dedupe playbook (`sql/dedupe.sql`) is for. We don't fix HubSpot at the source; we mirror it, clean it in Supabase, push verified properties back. Detailed in Part 2 Q1.
- **Who else needs to authorize?** Just Alex for the OAuth flows (he's the workspace admin on HubSpot, Avoma, Slack). API-key sources (Apollo, Crunchbase, Sumble) get added to Airbyte's secrets manager once.
- **What about real-time signals like funding announcements?** Daily is the baseline. Crunchbase's webhook for funding events fires immediately on announcement — lands in a separate `signal_events` table, on top of the daily lake. Covered in walkthrough 4.
