# 1 — Get Your Data Queryable

> Walks **OS Steps 1 + 2** — repo per client, then data ingested daily · Audience: Alex (+ RevOps if there is one) · Outcome: terminal ready, repo cloned, your existing data mirrored into a place where Claude Code can ask questions across it

## What this walkthrough covers

The point isn't to install a production stack. The point is **to get the data Mento already has into one place where you can play with it.** Three things in order: terminal setup, clone the repo, set up Airbyte so HubSpot + Avoma + Slack mirror into Supabase via OAuth.

**The unlock once this is done:** a stakeholder can ask *"why did we close [last big logo]?"* and Claude reads the Avoma quotes, the Slack thread where the intro happened, the funding event 60 days prior, and the CHRO hire 30 days before that — and tells you. Same query for losses. That's the OS earning its keep on day one — not by automating anything, by making everything *answerable*.

Steps 5–7 of the OS — orchestration (Trigger.dev), outbound (SmartLead), enrichment APIs — are **not** part of this walkthrough. Those are execution work that comes after walkthroughs 2 and 3 surface a bottleneck worth operationalizing.

## Step 1 — Terminal setup

```bash
# Claude Code (one-line install) — https://claude.com/docs
curl -fsSL https://claude.ai/install.sh | sh

# git, if you don't already have it
xcode-select --install        # macOS
# (or apt/brew/winget on your OS)

# GitHub Desktop — optional, recommended for non-CLI stakeholders
# https://desktop.github.com
```

That's the entire local environment. No Node, no Python, no Docker — Claude Code is the workbench, and everything else (Supabase, Airbyte) runs in the cloud.

## Step 2 — Clone the repo

```bash
git clone git@github.com:mento/mento-gtm.git
cd mento-gtm/
claude     # opens Claude Code in this directory
```

The tree:

```
mento-gtm/
├── foundation/        # who Mento is — synthesis, ICP, playbooks
├── data/              # mirrors of HubSpot, Avoma, Slack (filled by Airbyte)
├── accounts/          # one folder per top account, auto-assembled
├── bottlenecks/       # captured in walkthrough 3
├── ideas/             # rep-flagged what-ifs
└── sql/               # queries you reuse — versioned
```

`data/` is empty until Airbyte is wired up.

## Step 3 — Set up Airbyte (the only integration layer for now)

Provision an Airbyte Cloud workspace (or self-host OSS) and provision a Supabase project (free tier is fine — Postgres + pgvector). Then in the Airbyte dashboard, add each source:

1. **HubSpot** → *Authorize* → standard HubSpot OAuth → destination = Supabase Postgres → daily sync, full refresh on accounts/contacts/deals, incremental on activities
2. **Avoma** → OAuth → destination = Supabase → daily sync of transcripts + summaries
3. **Slack** → OAuth → scope the deal-discussion channels Alex picks → daily sync of threads

That's it. No Crunchbase, Sumble, Apollo yet — those come later if you build workflows that need enrichment. **Start with what you already have.**

After the first sync runs, Supabase will have:

- `hubspot_contacts`, `hubspot_accounts`, `hubspot_deals`, `hubspot_activities`
- `avoma_transcripts`, `avoma_summaries`
- `slack_messages`

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

If counts look reasonable, your data is alive in a queryable place. **You're done with setup.** Walkthrough 2 is where you actually start playing with it.

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
| **5. Agentic dev to ship solutions** | Spec → research → test → ship the #1 bottleneck | This is where the brief's signal workflow lives. It's *step 5* not step 1 because shipping into a foundation that isn't there is what kills GTM-engineering teams. |
| **6. Roll out to the team** | The adoption mechanic for reps — Slack cards, HITL at draft, walkthroughs | Reps adopt differently than stakeholders. Stakeholders open Claude Code; reps live in Slack. Step 3 is for stakeholders; step 6 is for reps. |
| **7. Measure → pipeline + revenue** | Closed-loop attribution on what shipped | The only legitimate success metric. Without this, you can't tell whether step 5 worked, and you can't retune the weights for the next ship. |

**Three things to notice:**

1. **Steps 1–4 are the foundation, and they're the part that's usually skipped.** A GTM engineer who shows up in week one and starts building automations has skipped the foundation and is gambling that the founder's gut is right. Sometimes it is. Mostly it isn't.
2. **Step 5 is *one* step, not the whole job.** The signal workflow lives inside step 5. So does the *next* thing Mento wants to build. So does the one after that. The OS is built once; the things shipped inside it are continuous.
3. **Steps 6 and 7 are execution work.** That's what a GTM engineer (me, post-hire) actually *does* day to day — rollout, attribution, weight retuning. The walkthroughs in this folder cover steps 1–5: what Mento can see, set up, and play with on their own. Steps 6–7 are what I'd run once embedded.

## My reasoning — why this minimal foundation stack

Three principles drive every tool pick:

1. **OAuth > API keys, every time.** API keys leak, expire, rotate at the worst moment. OAuth flows are bound to a workspace admin — when permissions change, the integration changes with them.
2. **Don't build what a connector already does.** GTM-engineering teams die in two places: custom scrapers and hand-rolled API integrations. Both are pure undifferentiated plumbing.
3. **Daily is the right cadence for the baseline.** Most signals — funding, exec hires, headcount, lifecycle — are 6–18 month patterns. Real-time webhooks sit *on top of* the daily lake when you need them, not instead.

**The foundation stack (just what you need to look at your data):**

| Tool | Why this one | What I'd swap it for | Docs |
|---|---|---|---|
| **Claude Code** | The repo is the interface, the terminal is the workbench. Reads files, runs SQL, edits playbooks in-context. | Cursor or another agentic IDE — file-first approach is what matters. | [claude.com/docs](https://claude.com/docs) |
| **GitHub** | Version control is non-negotiable. Every playbook, spec, signal rule is a file. | GitLab / Bitbucket — same shape. | [docs.github.com](https://docs.github.com) |
| **Supabase** | Postgres + pgvector + auth + storage in one. Free tier covers the early lake. The pgvector matters for Avoma topic-match scoring later. | Raw Postgres + Pinecone — works, more moving parts. | [supabase.com/docs](https://supabase.com/docs) |
| **Airbyte** | OAuth-based, 350+ connectors, daily sync to Supabase. The only piece of the read-side we get to *not build*. | Fivetran (more polished, more expensive) or Estuary (real-time, overkill at this scale). | [docs.airbyte.com](https://docs.airbyte.com) |

That's it for now. **Four tools, all OAuth or free-tier, all about reading what Mento already has.**

**What's NOT in the foundation stack** — and shouldn't be installed yet:

- *Orchestration* (Trigger.dev, Inngest, n8n) — only when you have a workflow to actually run on a schedule
- *Outbound execution* (SmartLead, Outreach, Apollo Sequences) — only when reps are approving drafts
- *Enrichment APIs* (BlitzAPI, Crunchbase Pro, Sumble) — only when scoring needs signals from outside Mento's own data

If walkthrough 3 surfaces a bottleneck worth operationalizing, the execution stack is what gets added on top. Until then, **don't pay for what you're not using yet.** That's the doing of OS step 5 — the work I'd run once embedded.

## What you've unlocked

- Terminal set up. Claude Code + git, no other local dependencies.
- Repo cloned. The OS has a home on Alex's machine.
- Airbyte syncing daily. Two years of HubSpot, Avoma, and Slack data, mirrored into Supabase, ready to query.
- You know *why* this shape and *why* this minimal stack.

That's the foundation. Walkthrough 2 is where you start asking it questions.

## Common questions

- **Does Airbyte have a connector for X?** Airbyte ships 350+ connectors as of 2026; HubSpot, Avoma, Slack are native. If something's missing, Airbyte's CDK lets us write a custom connector in a day.
- **Is this expensive?** Airbyte Cloud is per-row-synced. At Mento's scale (5K contacts, ~1K deals, ~12 won-deal transcripts) the daily sync runs comfortably under $100/mo, often under $50. Supabase free tier covers the early lake.
- **What if HubSpot data is messy?** That's a thing you'll *find* in walkthrough 2 (playing with the data) and *capture* as a bottleneck in walkthrough 3. Don't fix it pre-emptively.
- **Who needs to authorize?** Just Alex for OAuth (workspace admin on HubSpot, Avoma, Slack). No API keys to provision yet.
- **Why not start with the signal workflow directly?** Because shipping into a foundation that isn't there is what kills GTM-engineering teams. See "Why the 7-step shape" above.
