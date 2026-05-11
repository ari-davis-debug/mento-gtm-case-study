# Mento GTM Engineer Take-Home — Submission

> Ari Davis · 2026-05-11
> Format: GitHub repo + 1-page briefs per part + GTM OS step-by-step + written walkthroughs for standing it up

## TL;DR — what I'm proposing, and why

Mento's brief asks for three things: diagnose the problem, design a data foundation, build a buying-signal workflow. The honest read of Alex's Slack message is that **none of those three are the actual problem.** The actual problem is that Mento has been winning deals on instinct for two years and there's no system — no place — where that instinct lives outside the founders' heads.

So my submission doesn't propose an automation. **It proposes a GTM Operating System** — a versioned, queryable, multi-stakeholder repo that ingests everything Mento already has and lets the team work *with* their data instead of around it. The signal workflow Mento asked for in Part 3 is one component inside it. Parts 1 and 2 are the foundation that makes Part 3 worth shipping.

The shape is a 7-step pattern for building GTM operating systems for client teams in Claude Code. I've been building a version of this for a year (my own knowledge graph, the CIA — 350+ nodes, typed wiki-links, daily sync, agentic build discipline). I'm using that structure here because it's the right shape for Mento, and because being explicit about the shape is how Mento evaluates whether I'm pattern-matching or pattern-applying.

## How to read this repo

```
mento-case-study/
├── README.md                    ← you are here — GTM OS framing + navigation
│
├── case-study/                  ← DIRECT ANSWERS TO THE TAKE-HOME (the 3 questions)
│   ├── README.md                  index
│   ├── part1-diagnose-and-prioritize.md
│   ├── part2-data-foundation.md
│   └── part3-buying-signal-workflow.md
│
├── gtm-os/                      ← THE 7-STEP SHAPE, expanded
│   ├── README.md                  index + the 7-step diagram
│   ├── step-1-repo-per-client.md
│   ├── step-2-data-playbooks-ingested-daily.md
│   ├── step-3-stakeholders-in-claude-code.md
│   ├── step-4-capture-prioritize-bottlenecks.md
│   ├── step-5-agentic-dev-ship-solutions.md
│   ├── step-6-roll-out-to-team.md
│   └── step-7-measure-pipeline-revenue.md
│
├── workflow/                    ← Mermaid diagrams (rendered in GitHub + Notion)
├── data/                        ← sample input shapes (not real Mento data)
└── spec.md                      ← internal working spec (not part of the submission)
```

**Two reading paths, same content:**
- *"I just want the take-home answers"* → start in [`case-study/`](./case-study/)
- *"I want to see how you actually think about building this"* → start in [`gtm-os/`](./gtm-os/), each step links back to the take-home answer that lives inside it

## The 7-step GTM OS shape

```
┌─────────────────────────────────────────────────────────────────────┐
│  GTM OPERATING SYSTEM — 7-step shape                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   1. Repo per client            ─┐                                  │
│   2. Data + ops models +         │  Foundation                      │
│      playbooks into the repo     │                                  │
│      (2b optional: data lake     │                                  │
│       via Airbyte)               │                                  │
│   3. Stakeholders into          ─┤                                  │
│      Claude Code on the repo     │                                  │
│   4. Capture + prioritize       ─┘                                  │
│      bottlenecks                                                    │
│                                                                     │
│   5. Agentic dev to ship        ─┐  Build                           │
│      solutions (spec → research  │                                  │
│      → test → ship)             ─┘                                  │
│                                                                     │
│   6. Roll out to the team       ─┐  Operate                         │
│      (rep adoption mechanic)     │                                  │
│   7. Measure → pipeline +        │                                  │
│      revenue (closed-loop      ─┘                                   │
│      attribution)                                                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## How the 7-step OS maps to the take-home, step by step

This is the spine. Each step of the OS gets a file in `gtm-os/` and links into the **specific section of the take-home that lives inside it.**

| OS Step | What it is | Where the take-home lives inside it |
|---|---|---|
| **1. Repo per client** | Stand up `mento-gtm/` as the single source-of-truth repo | [Part 1 §1](./case-study/part1-diagnose-and-prioritize.md) — repo tree, Airbyte OAuth, daily sync |
| **2. Data + operating models + playbooks into the repo** | Board decks, sales playbooks, 90-day deal/account/contact snapshot, meeting transcripts — into `data/` so Claude can find them. **2b (optional):** daily data lake via Airbyte (Supabase / BigQuery / your pick) when manual exports get old | [Part 1 §1](./case-study/part1-diagnose-and-prioritize.md) — *"why everything, daily"* + **all of [Part 2](./case-study/part2-data-foundation.md)** — dedupe / enrichment / ICP scoring / lifecycle = the playbooks |
| **3. Stakeholders into Claude Code on the repo** | Alex + reps onboard via 1:1 sessions; first prompts run against their own data. Written walkthroughs in [`walkthroughs/`](./walkthroughs/) show how to stand it up. | [Part 1 §2](./case-study/part1-diagnose-and-prioritize.md) — 3 starter prompts, custom skills/commands graduate from these sessions |
| **4. Capture + prioritize bottlenecks** | Bottlenecks captured from the lake (not from interviews), ranked by impact × buildability × stakeholder-trust | [Part 1 §3](./case-study/part1-diagnose-and-prioritize.md) — `bottlenecks/` directory + Phase 0 data archaeology gate |
| **5. Agentic dev to ship solutions** | Spec → research → test → ship the top-ranked bottleneck | **All of [Part 2](./case-study/part2-data-foundation.md)** (the substrate the ship needs) + **all of [Part 3](./case-study/part3-buying-signal-workflow.md)** (the actual ship — the signal workflow) |
| **6. Roll out to the team** | Adoption mechanic — written walkthroughs, HITL placement, rep-co-authored bottlenecks, Slack-direct delivery | [Part 1 risk section](./case-study/part1-diagnose-and-prioritize.md) + [Part 3 §(6)](./case-study/part3-buying-signal-workflow.md) — Slack-card HITL design |
| **7. Measure → pipeline + revenue** | Closed-loop attribution. Pipeline + revenue is the only legitimate success metric | [Part 2 §Q3](./case-study/part2-data-foundation.md) — monthly weight re-fit + [Part 3 §(7)](./case-study/part3-buying-signal-workflow.md) — deal-on-reply + outcomes loop |

**The story this tells:** *Mento asked three questions. The honest answer is they're not three things — they're parts of one OS. Here's the OS, and here's where each of those questions lives inside it.*

## Why this framing matters for Mento specifically

Three things make Mento a fit for this shape, not just any GTM-engineer playbook:

1. **Mento has the data, just not the system.** Two years of warm intros, exec dinners, and Avoma calls means the win-evidence already exists. The OS is the place to put it where Claude Code can find it.
2. **A two-rep team can't survive a "build first, adopt later" rollout.** If reps don't open the OS in week one, no automation built in week four matters. Steps 1–4 are *more* important here than at a 50-person org.
3. **Founder-instinct + rep-instinct divergence is the highest-value gap.** The OS is the only place that gap can be made visible (Step 4 captures it explicitly).

## What the GTM OS is *for*

**The OS is not a deliverable. It's a workshop.** Once it's stood up, it's where every new GTM thing Mento wants to build gets built — new signal types, new playbooks, new scoring rules, new rep workflows. The signal workflow in Part 3 is the *first* thing built inside it, not the only thing. Everything after is the same pattern: someone has an idea or hits a bottleneck → it gets captured in the repo → Claude Code (with the lake underneath) takes it from idea to shipped.

**Where you go when you want to do X:**

| When Mento wants to… | Where to go in the OS | What gets created |
|---|---|---|
| **Add a new signal source** (new API, new trigger type) | [`gtm-os/step-2`](./gtm-os/step-2-data-playbooks-ingested-daily.md) + Airbyte connector → new row in `signal_events` table | New Airbyte source, new SQL signal rule, weights folded into Part 2 §Q3 archetype scoring |
| **Rewrite a playbook** (discovery, demo, objection handling) | Claude Code prompt against `data/avoma/transcripts/` → diff in `foundation/playbooks/` | New playbook PR, versioned, reviewable |
| **Capture a new bottleneck** (rep flagged, founder noticed, lake surfaced) | [`bottlenecks/`](./case-study/part1-diagnose-and-prioritize.md) — one markdown file per bottleneck, schema in walkthrough 3 | New bottleneck node, ranked against existing by impact × buildability × trust |
| **Ship a new workflow** (e.g. churn-risk monitor, expansion-signal alerts) | [`gtm-os/step-5`](./gtm-os/step-5-agentic-dev-ship-solutions.md) — spec → research → test → ship | New Trigger.dev jobs, eval-gated, deployed |
| **Re-tune ICP weights** (the lake disagrees with your math) | [Part 2 §Q3](./case-study/part2-data-foundation.md) → monthly logistic regression on `outcomes` table | New `archetype_score_*` weights, PR for human review |
| **Add a new archetype** (a new win pattern emerges) | [Part 2 §Q3](./case-study/part2-data-foundation.md) → new SQL CASE-statement column on `accounts` | New archetype score column, MAX() routing automatically picks it up |
| **Onboard a new stakeholder** (RevOps hire, new founder advisor) | [`walkthroughs/`](./walkthroughs/) — 3 written guides | Stakeholder running their own prompts in ~1 hour |
| **Re-rank what to build next** (quarterly, or when lake surfaces a new top problem) | [`gtm-os/step-4`](./gtm-os/step-4-capture-prioritize-bottlenecks.md) — re-run the ranking against current `bottlenecks/` | Updated `bottlenecks/_synthesis.md` |
| **Audit a number you don't trust** (priority score, draft quality, lifecycle stage) | Click "Trigger detail" in the Slack card → SQL breakdown of every weight | Every claim is one click from source — no black boxes |

**The pattern is always the same.** A new thing wants to exist → it becomes a file (a bottleneck, a spec, a playbook, a signal rule) → Claude Code uses the lake + the existing playbooks to ship it → the eval gate filters it → reps see the output in Slack → outcomes flow back into the monthly retrain. **Every shipped thing makes the next thing easier to ship.** That's what makes it an OS and not a project.

## On the walkthroughs folder

[`walkthroughs/`](./walkthroughs/) contains three written guides — **a live representation of the 7-step OS, walked one step at a time on real Mento data.** Required foundation stack is just **Claude Code + GitHub**. Daily data lake (Airbyte → Supabase / BigQuery / your pick) is an optional level-up — illustrative, swap your equivalents where they fit.

| # | Walkthrough | OS step | What it unlocks |
|---|---|---|---|
| 1 | [Get your data queryable](./walkthroughs/1-installation-and-setup.md) | Steps 1 + 2 | Foundation stack live, daily sync running, repo cloned. *The lake is queryable.* |
| 2 | [Play with your data](./walkthroughs/2-first-prompts-in-claude-code.md) | Step 3 | Three starter prompts across HubSpot + Avoma + Slack on real data. *Stakeholders inside the system.* |
| 3 | [Let the data tell you what's broken](./walkthroughs/3-bottleneck-capture.md) | Step 4 | Bottlenecks ranked from the lake, not interviews. *You know what's worth building.* |

**Steps 5–7 of the OS are execution work** — what I'd run once embedded (agentic dev, rollout to reps, closed-loop measurement). They're sketched in `gtm-os/step-5`, `step-6`, `step-7` and in Parts 2 + 3 of the case study, but not as walkthroughs you'd run yourself — the doing of them needs real reps, real deals, real revenue lift.

## What I'm not claiming

- I haven't seen Mento's actual HubSpot, Avoma, or Slack data. The bottleneck example in Part 1 is illustrative; the real top-1 surfaces from the work in Step 4.
- Steps 6 and 7 are sketched, not built. They depend on real reps, real deals, and real revenue lift — which can't be faked in a 2–3 hour case study.

## Read order

1. **This README** — the frame
2. **[`gtm-os/`](./gtm-os/)** — the 7-step shape, step by step (recommended)
3. **[`case-study/`](./case-study/)** — direct answers to the take-home (if you'd rather skip the framing)
4. **[`walkthroughs/`](./walkthroughs/)** — written guides for standing this up on your own machine

— Ari
