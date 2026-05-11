# 1 — Get Your Data Queryable

> Walks **OS Steps 1 + 2** — repo per client, then data + playbooks into the repo (2b: optional data lake) · Audience: Alex (+ RevOps if there is one) · Outcome: terminal ready, repo cloned, your existing data in a place where Claude Code can ask questions across it

## What this walkthrough covers

The point isn't to install a production stack. The point is **to get the stuff Mento already has into the repo so Claude Code can use it.** Three required moves and one optional level-up:

1. Terminal setup — Claude Code + git
2. Clone the repo
3. Get data + operating models + playbooks **into the repo** (board decks, sales playbooks, 90-day snapshot of deals/accounts/contacts, meeting transcripts)

3b *(optional, if you want a daily data lake)* — Airbyte OAuth pulling HubSpot/Avoma/Slack into a queryable store on a daily schedule.

**The unlock once this is done:** a stakeholder can ask *"why did we close [last big logo]?"* and Claude reads the Avoma quotes, the Slack thread where the intro happened, the funding event 60 days prior, and the CHRO hire 30 days before that — and tells you. Same query for losses. That's the OS earning its keep on day one — not by automating anything, by making everything *answerable*.

Steps 5–7 of the OS (build agents, roll out to reps, measure pipeline+revenue) are execution work that comes after walkthroughs 2 and 3 surface a bottleneck worth shipping.

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

That's the entire local environment. No Node, no Python, no Docker. **Claude Code is the workbench.**

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
├── data/              # exports + transcripts (filled in step 3)
├── accounts/          # one folder per top account
├── bottlenecks/       # captured in walkthrough 3
├── ideas/             # rep-flagged what-ifs
└── sql/               # queries you reuse — versioned
```

## Step 3 — Get the stuff *into the repo*

This is the part most teams skip. Drop the following into `mento-gtm/data/` as files (CSV, markdown, PDF — Claude reads all of them):

- **Operating models** — board decks, current sales playbook, ICP doc, comp plan
- **HubSpot snapshot (90-day)** — export deals, accounts, contacts, activities as CSV via HubSpot's native export
- **Avoma transcripts** — last 90 days of discovery + demo + closed-won calls, downloaded as markdown or .txt
- **Slack threads** — copy-paste the deal-discussion threads that mattered into `data/slack/`. (Tedious, but for a 90-day snapshot you only do it once.)
- **The 200-list** — drop the CSV

**Context is everything. Perfect file systems don't matter as much as having the data where Claude can find it.** A messy `data/` folder beats a pristine HubSpot that Claude can't read.

That's enough to get from "the OS has a home" to "the OS knows what's in it" — walkthroughs 2 and 3 run fine on this.

## Step 3b *(optional)* — Daily data lake

Once you find yourself running the same export-and-drop dance every two weeks, you graduate to a daily sync. **Airbyte does this for you over OAuth** — no API keys, 350+ connectors, runs in the cloud:

1. Provision an Airbyte Cloud workspace (or self-host OSS)
2. Pick a destination — **any of these work**: Supabase (Postgres + pgvector, free tier), BigQuery (best for scale), raw Postgres on Render/Neon, or even flat-file destinations dumping CSVs back into `data/`
3. In Airbyte, add sources:
   - **HubSpot** → OAuth → daily sync, incremental on activities
   - **Avoma** → OAuth → daily transcripts + summaries
   - **Slack** → OAuth → scope deal-discussion channels → daily threads

After the first sync, you have a queryable table for each source. Claude Code can SQL against the destination directly.

**Which destination?** Doesn't matter much at Mento's scale. Started a lot of clients on Supabase (cheap, fast to wire up), will likely move to BigQuery as the data grows. Pick the one the team is closest to operating already.

**You don't need this for walkthroughs 2 and 3.** Files in `data/` get you 80% of the value. The data lake matters when you want the answers to refresh themselves daily without anyone running an export.

## What you've unlocked

- Terminal set up. Claude Code + git, no other local dependencies.
- Repo cloned. The OS has a home on Alex's machine.
- Data in `data/`. Claude can read board decks, transcripts, HubSpot exports, and Slack threads in one breath.
- *(Optional)* Daily Airbyte sync — same data, refreshes itself.

## My reasoning — why the 7-step shape

Most GTM-engineer hires jump straight to "build the signal workflow." That's a mistake. The 7-step shape exists because the **order** matters more than any individual step.

**Foundation comes first, build comes second, operate comes third.** Skip any of those and the next two collapse.

| Step | What it is | Why it's in this position |
|---|---|---|
| **1. Stand up the GTM repo** | One source-of-truth folder for the org's GTM. GitHub for version control, permissions, easy rollback. | The repo is the artifact. No repo = no place for the OS to live. Has to exist before anything ingests into it. |
| **2. Data + operating models + playbooks into the repo** | Board decks, sales playbooks, 90-day snapshot of deals/accounts/contacts, meeting transcripts. **2b (optional):** daily data lake via Airbyte (Supabase / BigQuery / your pick). | Context is everything. Perfect file systems matter less than just having it where Claude can find it. |
| **3. Stakeholders into Claude Code, pointed at the repo** | Alex (then anyone) downloads the app, connects GitHub, runs first prompts. Self-serves huge value on data they already had. | If stakeholders never open it, the OS dies in week one. Adoption *precedes* capability. |
| **4. Capture + prioritize bottlenecks** | Bottlenecks from data + rep + manager feedback. Systems touched, problem, how-measured, root cause, desired outcome. | You can't build the right thing first without ranking what to build. |
| **5. Agentic dev to ship solutions** | Skills, implementations in existing tools (Clay, Nooks, Usergems), or custom agents. **Spec → research → tests → ship.** Skip the spec/research/tests and you build a house of cards. | This is where the brief's signal workflow lives. *Step 5* not step 1 because shipping into a foundation that isn't there is what kills GTM-engineering teams. |
| **6. Roll out to the team** | It's not enough to build "agents." Reps need to actually use it. Sometimes that's a CSV in Outreach. Sometimes a Google Doc list. Increasingly: custom MCPs in something like Composio. | Reps adopt differently than stakeholders. Stakeholders open Claude Code; reps live in their tools. |
| **7. Measure → pipeline + revenue** | Closed-loop attribution. You moved the constraint correctly when pipeline & revenue go up. | The only legitimate success metric. Stay focused, test fast, keep iterating. |

**Three things to notice:**

1. **Steps 1–4 are the foundation.** Usually skipped. A GTM engineer who shows up week one and builds automations has skipped the foundation and is gambling on founder gut.
2. **Step 5 is *one* step.** The signal workflow lives in step 5. So does the next thing. So does the one after that. The OS is built once; the things shipped *inside* it are continuous.
3. **Steps 6 and 7 are execution work.** That's the post-hire job — rollout, attribution, retuning. The walkthroughs in this folder cover steps 1–4. Steps 5–7 are documented in `gtm-os/` and Parts 2 + 3 of the case study, but the *doing* of them is what I'd run once embedded.

## My reasoning — why this minimal foundation stack

Two principles drive every tool pick:

1. **OAuth > API keys, every time.** API keys leak, expire, rotate at the worst moment. OAuth flows bind to a workspace admin — when permissions change, the integration changes with them.
2. **Don't build what a connector already does.** GTM-engineering teams die in two places: custom scrapers and hand-rolled API integrations. Both are pure undifferentiated plumbing.

**The required foundation stack (what you actually need for walkthroughs 1–3):**

| Tool | Why this one | What I'd swap it for | Docs |
|---|---|---|---|
| **Claude Code** | The repo is the interface, the terminal is the workbench. Reads files, runs SQL, edits playbooks in-context. | Cursor or another agentic IDE — file-first approach is what matters. | [claude.com/docs](https://claude.com/docs) |
| **GitHub** | Version control is non-negotiable. Every playbook, spec, signal rule is a file. | GitLab / Bitbucket — same shape. | [docs.github.com](https://docs.github.com) |

**Two tools. That's it for the minimum.** Drop files into `data/`, and walkthrough 2 works.

**Optional level-up — daily data lake:**

| Tool | When you need it | Docs |
|---|---|---|
| **Airbyte** | OAuth-based daily sync — when you're tired of running exports every two weeks. 350+ connectors. | [docs.airbyte.com](https://docs.airbyte.com) |
| **Destination** — Supabase / BigQuery / Postgres / flat files | Wherever Airbyte writes. Started a lot of clients on Supabase, moving to BigQuery as data grows. None of these are required for walkthrough 2 if you have files in `data/`. | [supabase.com/docs](https://supabase.com/docs) · [cloud.google.com/bigquery](https://cloud.google.com/bigquery) |

**What's NOT in the foundation stack** — and shouldn't be installed yet:

- *Orchestration* (Trigger.dev, Inngest, n8n) — only when you have a workflow to run on a schedule (OS step 5)
- *Outbound execution* (SmartLead, Outreach, Apollo Sequences) — only when reps are approving drafts (OS step 6)
- *Enrichment APIs* (BlitzAPI, Crunchbase Pro, Sumble) — only when scoring needs signals from outside Mento's own data (OS step 5)

If walkthrough 3 surfaces a bottleneck worth operationalizing, the execution stack is what gets added on top. Until then, **don't pay for what you're not using yet.**

## Common questions

- **Do I really not need a database?** Not for walkthroughs 2 and 3. Claude reads CSVs, transcripts, markdown, PDF, JSON directly out of `data/`. The database matters when you want SQL across millions of rows or daily auto-refresh. At Mento's scale, files-in-repo gets you a long way.
- **Why Airbyte if I do go the data lake route?** OAuth, not API keys. 350+ connectors out of the box. The one piece of the stack we get to *not build*. Custom scrapers are where GTM-engineering teams die.
- **Supabase or BigQuery for the data lake?** Supabase is faster to wire up (free tier, Postgres + pgvector in one). BigQuery is better at scale and if the team already lives in GCP. Either works. Pick the one the team is closer to operating.
- **What if HubSpot data is messy?** Find that in walkthrough 2 and capture it as a bottleneck in walkthrough 3. Don't fix it pre-emptively.
- **Who needs to authorize?** Alex (workspace admin on HubSpot, Avoma, Slack) if you go the Airbyte route. Nobody if you start with manual exports.
- **Why not start with the signal workflow directly?** Because shipping into a foundation that isn't there is what kills GTM-engineering teams. See "Why the 7-step shape" above.
