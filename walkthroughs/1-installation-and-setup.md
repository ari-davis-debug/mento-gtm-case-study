# 1 — Installation and Setup

> Audience: Alex (+ RevOps if there is one) · Outcome: lake alive, daily sync running, repo cloned, agents wired to act in your apps

## What this walkthrough covers

How you'd stand up the foundation: every Mento source authorized via OAuth, mirrored daily into Supabase, with the `mento-gtm/` repo cloned and ready for Claude Code to read *and act*. Your exact stack may differ — swap your equivalent for any tool below.

## My heuristics for picking the stack

A few rules I default to before I touch a single config file. They've saved me more weekends than I can count.

1. **OAuth > API keys, every time.** Anything that supports OAuth, go OAuth. API keys leak, expire, rotate at the worst moment, and require you to babysit a secrets manager. OAuth flows are bound to a workspace admin's identity — when Alex's permissions change, the integration changes with him.
2. **Don't build what a connector already does.** The two places GTM-engineering teams die are (a) custom scrapers, (b) hand-rolled API integrations. Both are pure undifferentiated plumbing. Use Airbyte (for *ingestion* — data into a warehouse) and One (for *actions* — agents calling APIs live) before you write a line of integration code.
3. **Two integration layers, two purposes.** Airbyte = read-side (daily sync of HubSpot/Avoma/Slack into Supabase, for analysis). One = write-side (agents upserting contacts, posting Slack cards, creating SmartLead campaigns, in real time). They're complementary — you'll use both.
4. **Sign up first, configure second.** Provision every account before you start wiring anything. Nothing burns more momentum than getting halfway through a setup and discovering you need to wait 24 hours for a HubSpot Enterprise trial or a Crunchbase Pro approval. Day 1 is sign-up day, day 2 is wire-up day.
5. **Daily sync is the right cadence for the baseline.** Most GTM signals — funding, exec hires, headcount, lifecycle stage — are 6–18 month patterns, not real-time. Daily sync is cheap, reliable, and right. Real-time webhooks (Crunchbase funding events, SmartLead replies) sit *on top of* the daily lake, not instead of it.
6. **Validate against your transcripts, not your gut.** Once the lake is alive, the first thing to do is point Claude Code at Avoma and ask *"do the patterns you see in the data match what the reps said on calls?"* If they don't, the lake is wrong (bad ingestion, bad schema) — fix it before building anything on top.
7. **Show output before deploying.** Every new piece of the stack — every Trigger.dev job, every signal rule — gets run locally, returns JSON to the terminal, and gets eyeballed *before* it ships to production. Automations earn trust; they're not granted it.

## What you need installed before starting

| Layer | Tool | Why |
|---|---|---|
| Repo working surface | **Claude Code** + **GitHub Desktop** + git | Where stakeholders ask the system questions |
| Data lake | **Supabase** project (free tier fine to start) | Postgres + pgvector — system of record |
| Ingestion (read-side) | **Airbyte** (Cloud or self-hosted OSS) | OAuth connectors, 350+ sources, daily sync to Supabase |
| Agent action layer (write-side) | **One** ([withone.ai](https://withone.ai)) | OAuth-based integration platform, 250+ apps, 47K+ pre-built actions for agents — agents call `actions execute hubspot upsert_contact` instead of writing API code |
| Orchestration | **Trigger.dev** project | Where the signal-workflow jobs run (walkthrough 4) |
| Source-system admin access | **HubSpot**, **Avoma**, **Slack** | Workspace admin needed to authorize OAuth scopes |
| Outbound execution | **SmartLead** account | Multi-channel sequencing (email + LinkedIn + SMS) |
| Enrichment API keys | **BlitzAPI**, **Crunchbase Pro**, **Sumble**, **BuiltWith / TheirStack** | Verified contacts + signal sources |

Stack choices are illustrative — if Mento already uses Fivetran (instead of Airbyte) or Composio (instead of One), the pattern still works. The shape is what matters: OAuth ingestion + OAuth agent actions + a warehouse in the middle.

## Step 1 — Sign-up day: provision everything before you wire anything

Before any OAuth flow, every account exists:

```
□ Claude Code installed (curl ... | sh)
□ GitHub Desktop installed, mento-gtm repo created (empty)
□ Supabase project provisioned (free tier)
□ Airbyte Cloud account (or OSS self-hosted)
□ One account (withone.ai) — install: brew install one or npm i -g @withone/cli
□ Trigger.dev project created
□ HubSpot workspace admin verified
□ Avoma workspace admin verified
□ Slack workspace admin verified
□ SmartLead account provisioned
□ BlitzAPI, Crunchbase Pro, Sumble, BuiltWith — accounts active, keys in hand
```

Day 1 is checking boxes. Day 2 is wiring. Don't try to do them on the same day.

## Step 2 — Clone the repo, see the shape

```bash
git clone git@github.com:mento/mento-gtm.git
cd mento-gtm/
```

The tree:

```
mento-gtm/
├── foundation/                 # who Mento is — synthesis, ICP, playbooks
├── data/                       # mirrors of HubSpot, Avoma, Slack, enrichment (filled by Airbyte)
├── actions/                    # One action specs — what agents can DO in each app
├── accounts/<account-slug>/    # one folder per top account, auto-assembled
├── bottlenecks/                # captured in walkthrough 3
├── ideas/                      # rep-flagged what-ifs
└── sql/                        # dedupe, scoring, lifecycle — the playbooks
```

`data/` is what flows in (read-side, via Airbyte). `actions/` is what flows out (write-side, via One). Everything else is the rules-about-the-data that Claude Code uses to reason.

## Step 3 — Airbyte: authorize every source via OAuth (read-side)

In the Airbyte dashboard, add one source at a time:

1. **HubSpot** → *Authorize* → standard HubSpot OAuth → destination = Supabase Postgres → sync schedule = *daily*, full refresh on accounts/contacts/deals, incremental on activities
2. **Avoma** → OAuth → destination = Supabase → daily sync of transcripts + summaries
3. **Slack** → OAuth → scope the deal-discussion channels Alex picks → daily sync of threads
4. **Apollo / Crunchbase / Sumble** → API-key sources (no OAuth on these) — paste keys into Airbyte's secrets manager, **never** into code

Airbyte is the only piece of the read-side we get to *not build*. No scrapers. No babysitting webhooks. Alex authorizes each source once via the same OAuth flow he's done a hundred times — Google, GitHub, anything — and the daily sync is live.

## Step 4 — One: authorize the same apps for agent actions (write-side)

This is the piece most case studies skip. Pulling data is solved; **letting agents *act* on it** is where everything-but-One asks you to write integration code.

```bash
# install if you haven't
brew install one

# authorize each platform — One handles the OAuth flow in your browser
one --agent connect hubspot
one --agent connect slack
one --agent connect gmail        # for sending the approved drafts
one --agent connect smartlead    # for the multi-step sequence handoff
one --agent connect notion       # if you use Notion for playbooks/specs
```

Each command opens a browser tab, runs the OAuth dance, stores the token in `~/.one/config.json`. Done.

From this point, agents in `mento-gtm/` can do things like:

```bash
one --agent actions execute hubspot upsert_contact -d '{
  "email": "marisol@glimmer.health",
  "properties": {
    "firstname": "Marisol",
    "lastname": "Hwang",
    "jobtitle": "CHRO",
    "source": "mento-signal-trigger:chro-hire-glimmer"
  }
}'

one --agent actions execute slack send_message -d '{
  "channel": "#signals-alex",
  "blocks": [...]    # the signal card payload
}'
```

No API integration code. No managing tokens. No "did we use v1 or v2 of HubSpot's API." The agent says "upsert this contact" — One does it.

**Why it matters here:** when Claude Code drafts an email and the rep approves it in Slack, the *approve* button needs to (a) log the activity in HubSpot, (b) hand the lead off to SmartLead's sequencer, (c) post a confirmation back in Slack. Three apps, three API surfaces. One call each via One. No custom integration code on Mento's side.

## Step 5 — Confirm the lake is alive in Supabase

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

If counts look reasonable, the lake is alive.

## Step 6 — Validate against transcripts before building anything

This is the step that catches half of all bad ingestions. Before you trust the lake, open Claude Code and ask:

> *"For my last 5 closed-won deals, compare what HubSpot says happened (deal_source, owner, stage transitions) against what the Avoma transcripts say (who was on the call, what topics, what the buyer's stated trigger was). Tell me where they agree and where they disagree."*

If the lake is healthy, Claude can cross-reference both sources cleanly and the disagreements are interesting (HubSpot under-reports, transcripts over-detail). If the lake is broken, you'll see obvious gaps — transcripts missing for deals that obviously had calls, contacts not linked to accounts, stage transitions out of order. **Fix those before walkthrough 2.**

## Step 7 — The repo's `data/` folder fills itself

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

- **Airbyte handles read-side plumbing.** OAuth once per source. Daily sync to Supabase. No scrapers.
- **One handles write-side plumbing.** OAuth once per app. Agents call `actions execute` instead of writing API code.
- **Supabase is the system of record.** All derived data — scores, dedupe, lifecycle — lives there.
- **The repo is the working surface.** It mirrors the lake into markdown + SQL files Claude Code can read, and the `actions/` folder is what Claude Code uses to act.
- **No API keys floating around.** OAuth for HubSpot / Avoma / Slack / Gmail / SmartLead via Airbyte and One; secrets manager for the API-key-only sources (Crunchbase, Sumble, BlitzAPI).

From this moment forward, every stakeholder can clone this repo, open Claude Code, and both *ask* questions across the lake *and* take actions in HubSpot / Slack / Gmail / SmartLead — without writing a line of integration code. That's the foundation for walkthroughs 2–5.

## Common questions

- **Why two integration layers (Airbyte + One)?** Different purposes. Airbyte is for *batch reads* (mirror the world into a warehouse, daily). One is for *live writes* (agents acting on the world, now). Trying to do both with one tool means picking between "great syncs, awkward actions" and "great actions, awkward syncs."
- **Does One have a connector for X?** 250+ apps as of 2026 — HubSpot, Salesforce, Shopify, Slack, Gmail, Zendesk, Stripe, Notion, GitHub, Apollo, Brevo, Klaviyo, Gong, Fireflies, and 230+ more. Check `one --agent platforms list`. If it's not there, write a custom action (rare).
- **Does Airbyte have a connector for X?** 350+ connectors. HubSpot, Avoma, Slack, Apollo, Crunchbase, Sumble are all native. Missing one? Airbyte's CDK lets us write a custom connector in a day.
- **Is this expensive?** Airbyte Cloud per-row pricing — Mento's scale runs under $100/mo, often under $50. One has a free tier for early use; paid plans scale with action volume. Supabase free tier covers the early lake.
- **What if HubSpot data is messy?** That's what the dedupe playbook (`sql/dedupe.sql`) is for. Mirror it, clean it in Supabase, push verified properties back via One. Detailed in Part 2 Q1.
- **Who else needs to authorize?** Just Alex for OAuth flows (workspace admin on HubSpot, Avoma, Slack, Gmail). API-key sources (Crunchbase, Sumble, BlitzAPI) get added to Airbyte's secrets manager once.
- **What about real-time signals like funding announcements?** Daily is the baseline. Crunchbase's webhook for funding events fires immediately on announcement — lands in a separate `signal_events` table, on top of the daily lake. Covered in walkthrough 4.
