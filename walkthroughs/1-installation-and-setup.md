# 1 — Installation and Setup

> Audience: Alex (+ RevOps if there is one) · Outcome: terminal ready, repo cloned, Airbyte syncing every source daily into Supabase

## What this walkthrough covers

Three things, in order: **terminal setup, clone the repo, set up Airbyte.** Plus the reasoning behind both the 7-step OS shape and the tech-stack picks — so if you'd run this differently, you know what you'd be trading.

## Step 1 — Terminal setup

Everything below assumes a working terminal with Claude Code installed.

```bash
# Claude Code (one-line install)
curl -fsSL https://claude.ai/install.sh | sh

# git, if you don't already have it
xcode-select --install        # macOS
# (or apt/brew/winget on your OS)

# GitHub Desktop — optional but recommended for non-CLI stakeholders
# https://desktop.github.com
```

That's the entire local environment. No Node, no Python, no Docker on the local machine — Claude Code is the workbench, and everything else (Supabase, Airbyte, Trigger.dev) runs in the cloud.

## Step 2 — Clone the repo

```bash
git clone git@github.com:mento/mento-gtm.git
cd mento-gtm/
claude     # opens Claude Code in this directory
```

The tree you should see:

```
mento-gtm/
├── foundation/        # who Mento is — synthesis, ICP, playbooks
├── data/              # mirrors of HubSpot, Avoma, Slack, enrichment (filled by Airbyte)
├── accounts/          # one folder per top account, auto-assembled
├── bottlenecks/       # captured in walkthrough 3
├── ideas/             # rep-flagged what-ifs
└── sql/               # dedupe, scoring, lifecycle — the playbooks
```

`data/` is empty until Airbyte is wired up — that's the next step.

## Step 3 — Set up Airbyte

Provision an Airbyte Cloud workspace (or self-host OSS — both work). Then in the dashboard, add each source, one at a time:

1. **HubSpot** → *Authorize* → standard HubSpot OAuth → destination = Supabase Postgres → daily sync, full refresh on accounts/contacts/deals, incremental on activities
2. **Avoma** → OAuth → destination = Supabase → daily sync of transcripts + summaries
3. **Slack** → OAuth → scope the deal-discussion channels Alex picks → daily sync of threads
4. **Crunchbase / Sumble / Apollo** → API-key sources (no OAuth on these) — paste keys into Airbyte's secrets manager, **never** into code

After the first sync runs, Supabase will have:

- `hubspot_contacts`, `hubspot_accounts`, `hubspot_deals`, `hubspot_activities`
- `avoma_transcripts`, `avoma_summaries`
- `slack_messages`
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

If those counts look reasonable, the lake is alive. You're done with setup.

---

## My reasoning — why the 7-step shape

Most GTM-engineer hires jump straight to "build the signal workflow." That's a mistake. The 7-step shape exists because the *order* matters more than any individual step.

**Foundation comes first, build comes second, operate comes third.** Skip any of those and the next two collapse.

| Step | What it is | Why it's in this position |
|---|---|---|
| **1. Repo per client** | One source-of-truth folder per client team | The repo is the artifact. No repo = no place for the OS to live. Has to exist before anything ingests into it. |
| **2. Data + playbooks ingested daily** | Airbyte → Supabase, with playbooks (dedupe, scoring, lifecycle) versioned as SQL | The lake is the substrate. Every later step assumes you can SQL across everything Mento has. Skip this and steps 4–7 are blind. |
| **3. Stakeholders into Claude Code on the repo** | Alex (then anyone) runs prompts against their own data | If stakeholders never open it, the OS dies in week one. Adoption *precedes* capability — a system nobody uses has zero capability regardless of what it can do. |
| **4. Capture + prioritize bottlenecks** | Bottlenecks surfaced from the lake (not interviews) | You can't build the right thing first without ranking what to build. The reason this is *step 4*, not step 1, is that you need 1–3 to be alive before the lake can credibly surface a bottleneck. |
| **5. Agentic dev to ship solutions** | Spec → research → test → ship the #1 bottleneck | This is the build the brief asks for. It's *step 5* not step 1 because shipping into a foundation that isn't there is what kills GTM-engineering teams. |
| **6. Roll out to the team** | The adoption mechanic for reps (not stakeholders) — Slack cards, HITL at draft, walkthroughs | Reps adopt differently than stakeholders. Stakeholders open Claude Code; reps live in Slack. Step 3 is for stakeholders; step 6 is for reps. |
| **7. Measure → pipeline + revenue** | Closed-loop attribution on what shipped | The only legitimate success metric. Without this, you can't tell whether step 5 worked, and you can't re-tune the weights for the next ship. |

**Three things to notice about the shape:**

1. **Steps 1–4 are the foundation, and they're the part that's usually skipped.** A GTM engineer who shows up in week one and starts building automations has skipped the foundation and is gambling that the founder's gut is right. Sometimes it is. Mostly it isn't.
2. **Step 5 is *one* step, not the whole job.** The signal workflow lives inside step 5. So does the *next* thing Mento wants to build. So does the one after that. The OS is built once; the things shipped inside it are continuous.
3. **Steps 6 and 7 are about durability.** Without 6, the build dies on contact with reps. Without 7, you can't tell which weights to retune next month. Both are what turns a project into a system.

## My reasoning — why this tech stack

Three principles drive every tool pick below:

1. **OAuth > API keys, every time.** API keys leak, expire, rotate at the worst moment, and require babysitting a secrets manager. OAuth flows are bound to a workspace admin — when permissions change, the integration changes with them.
2. **Don't build what a connector already does.** GTM-engineering teams die in two places: custom scrapers, and hand-rolled API integrations. Both are pure undifferentiated plumbing. If a connector exists, use it.
3. **Daily is the right cadence for the baseline.** Most signals — funding, exec hires, headcount, lifecycle — are 6–18 month patterns. Real-time webhooks (Crunchbase funding events, SmartLead replies) sit *on top of* the daily lake, not instead of it.

| Tool | Why this one | What I'd swap it for |
|---|---|---|
| **Claude Code** | The repo is the interface, the terminal is the workbench. Claude Code reads files, runs SQL, edits playbooks, all in-context. | Cursor or another agentic IDE — pattern survives, the file-first approach is what matters. |
| **GitHub** | Version control is non-negotiable. Every playbook, spec, signal rule is a file. | GitLab / Bitbucket — same shape. |
| **Supabase** | Postgres + pgvector + auth + storage in one. Free tier covers the early lake. The pgvector matters for Avoma topic-match scoring. | Raw Postgres + Pinecone — works, more moving parts. |
| **Airbyte** | OAuth-based, 350+ connectors, daily sync to Supabase. The only piece of the read-side we get to *not build*. | Fivetran (more polished, more expensive) or Estuary (real-time, overkill at this scale). |
| **Trigger.dev** | Code-first orchestration. Jobs are TypeScript files, version-controlled, code-reviewed. Free tier covers a 2-rep team. | Inngest (similar shape) or n8n (for ops logic that changes weekly without a deploy — different use case, both can coexist). |
| **SmartLead** | Multi-channel sequencing (email + LinkedIn + SMS) with webhook events for sent/open/reply/booked. The outcomes loop in step 7 reads these. | Outreach or Apollo Sequences — same pattern, different price points. |
| **BlitzAPI** | Verified email + phone for contacts. Flat-rate pricing ($499 email + $599 phone, unlimited) — predictable at Mento's scale. | Apollo / ZoomInfo for verified contacts — credit-based, harder to predict cost on a 200-list working hard. |
| **Crunchbase Pro** | Funding events, exec changes, headcount. Webhook for real-time funding announcements. | The Org + manual TechCrunch RSS — works as cross-check, not as primary. |
| **Sumble** | API for hiring signals (CHRO/VP People hires), layer-3 director changes, headcount deltas. | Greenhouse/Lever job-board APIs as cross-check; no full replacement at this fidelity. |

**Where I'm opinionated, where I'm flexible:**

- **Opinionated:** OAuth-first, version-controlled playbooks, daily sync baseline, deterministic SQL for scoring (not LLM-judgment-as-scoring). These are load-bearing — change them and the whole shape collapses.
- **Flexible:** every specific vendor above. Fivetran/Airbyte, Trigger.dev/Inngest, SmartLead/Outreach — the *shape* matters; the brand on the bill doesn't.

## What you've unlocked

- **Terminal set up.** Claude Code + git, no other local dependencies.
- **Repo cloned.** The OS has a home on Alex's machine.
- **Airbyte syncing daily.** Two years of HubSpot, Avoma, and Slack data, mirrored into Supabase, ready to query.
- **You know *why* this shape and *why* this stack.** When something needs to change, you'll know what's load-bearing and what's swappable.

From this moment forward, every stakeholder can clone this repo, open Claude Code, and ask questions across HubSpot, Avoma, and Slack at the same time without writing a line of SQL. That's the foundation for walkthroughs 2–5.

## Common questions

- **Does Airbyte have a connector for X?** Airbyte ships 350+ connectors as of 2026; HubSpot, Avoma, Slack, Apollo, Crunchbase, Sumble are all natively supported. If something's missing, Airbyte's CDK lets us write a custom connector in a day.
- **Is this expensive?** Airbyte Cloud's pricing is per-row-synced. At Mento's scale (5K contacts, ~1K deals, ~12 won-deal transcripts) the daily sync runs comfortably under $100/mo, often under $50.
- **What if HubSpot data is messy?** That's what the dedupe playbook (`sql/dedupe.sql`) is for. Mirror it, clean it in Supabase, push verified properties back. Detailed in Part 2 Q1.
- **Who else needs to authorize?** Just Alex for OAuth flows (workspace admin on HubSpot, Avoma, Slack). API-key sources (Crunchbase, Sumble, BlitzAPI) get added to Airbyte's secrets manager once.
- **What about real-time signals like funding announcements?** Daily is the baseline. Crunchbase's webhook for funding events fires immediately on announcement — lands in a separate `signal_events` table, on top of the daily lake. Covered in walkthrough 4.
- **Why not start with the signal workflow directly?** Because shipping into a foundation that isn't there is what kills GTM-engineering teams. See "My reasoning — why the 7-step shape" above.
