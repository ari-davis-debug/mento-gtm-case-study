# Mento GTM Engineer Take-Home — Submission

> Ari Davis · 2026-05-11
> Format: GitHub repo · three reading paths (run it · read the answers · understand the shape)

## TL;DR — what I'm proposing, and why

Mento's brief asks for three things: diagnose the problem, design a data foundation, build a buying-signal workflow. The honest read of Alex's Slack message is that **none of those three are the actual problem.** The actual problem is that Mento has been winning deals on instinct for two years and there's no system — no place — where that instinct lives outside the founders' heads.

So my submission doesn't propose an automation. **It proposes a GTM Operating System** — a versioned, queryable, multi-stakeholder repo that ingests everything Mento already has and lets the team work *with* their data instead of around it. The signal workflow Mento asked for in Part 3 is one component inside it. Parts 1 and 2 are the foundation that makes Part 3 worth shipping.

The shape is a 7-step pattern Tomas Cetner and I have been refining for building GTM operating systems for client teams in Claude Code. I've been building a personal version of this for a year (my own knowledge graph, the CIA — 350+ nodes, typed wiki-links, daily sync, agentic build discipline). Being explicit about the shape is how Mento evaluates whether I'm pattern-matching or pattern-applying.

## Three ways to read this repo — pick one

```
mento-case-study/
│
├── quickstart/      ← (1) "I want to get something working immediately"
│   1-installation-and-setup.md     · OS steps 1+2 · get data into the repo
│   2-first-prompts-in-claude-code.md · OS step 3   · play with your data
│   3-bottleneck-capture.md           · OS step 4   · let the data tell you what's broken
│
├── case-study/      ← (2) "I want the direct take-home answers"
│   part1-diagnose-and-prioritize.md
│   part2-data-foundation.md
│   part3-buying-signal-workflow.md
│
└── gtm-os/          ← (3) "I want to see how I think about the shape"
    step-1-stand-up-the-repo.md
    step-2-data-playbooks-ingested-daily.md
    step-3-stakeholders-in-claude-code.md
    step-4-capture-prioritize-bottlenecks.md
    step-5-agentic-dev-ship-solutions.md
    step-6-roll-out-to-team.md
    step-7-measure-pipeline-revenue.md
```

| If you want… | Go here | What you'll find |
|---|---|---|
| **Get something working on your data right now** | [`quickstart/`](./quickstart/) | 3 hands-on walks. **Required stack is just Claude Code + GitHub.** Daily data lake (Airbyte → Supabase/BigQuery/your pick) is an optional level-up. Walks OS steps 1–4 live. |
| **The direct take-home answers** | [`case-study/`](./case-study/) | One-page briefs answering each of Mento's three questions. Read in order, or jump to the one you care about. |
| **The framing — how I think about the shape** | [`gtm-os/`](./gtm-os/) | The 7-step OS, one file per step. Each step links to the part of the case study that lives inside it. |
| **The exact `mento-gtm/` file tree I'd stand up** | [`gtm-os/repo-file-structure.md`](./gtm-os/repo-file-structure.md) | Full recommended folder structure — modeled after how the CIA structures `clients/<client>/`, GTM-shaped. Every folder mapped to the OS step it lives inside. |

**No wrong order.** Each folder stands alone. The README is the bridge.

## The 7-step GTM OS shape

```
┌─────────────────────────────────────────────────────────────────────┐
│  GTM OPERATING SYSTEM — 7-step shape                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   1. Stand up the GTM repo     ─┐                                  │
│   2. Data + ops models +         │  Foundation                      │
│      playbooks into the repo     │   (this is what quickstart/      │
│      (2b optional: data lake     │    walks live on real data)      │
│       via Airbyte)               │                                  │
│   3. Stakeholders into          ─┤                                  │
│      Claude Code on the repo     │                                  │
│   4. Capture + prioritize       ─┘                                  │
│      bottlenecks                                                    │
│                                                                     │
│   5. Agentic dev to ship        ─┐  Build                           │
│      solutions (spec → research  │  (case-study + gtm-os describe   │
│      → test → ship)             ─┘   it; doing it is post-hire)     │
│                                                                     │
│   6. Roll out to the team       ─┐  Operate                         │
│      (rep adoption mechanic)     │                                  │
│   7. Measure → pipeline +        │                                  │
│      revenue (closed-loop      ─┘                                   │
│      attribution)                                                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## How the 7-step OS maps to the take-home

Each step of the OS gets a file in `gtm-os/` and links into the **specific section of the take-home that lives inside it.**

| OS Step | What it is | Where the take-home lives | Quickstart |
|---|---|---|---|
| **1. Stand up the GTM repo** | Spin up `mento-gtm/` as the single source-of-truth repo for the org | [Part 1 §1](./case-study/part1-diagnose-and-prioritize.md) | [WT 1](./quickstart/1-installation-and-setup.md) |
| **2. Data + ops models + playbooks into the repo** | Board decks, sales playbooks, 90-day deal/account/contact snapshot, meeting transcripts → into `data/` so Claude can find them. **2b (optional):** daily data lake via Airbyte (Supabase / BigQuery / your pick) when manual exports get old | [Part 1 §1](./case-study/part1-diagnose-and-prioritize.md) + **all of [Part 2](./case-study/part2-data-foundation.md)** | [WT 1](./quickstart/1-installation-and-setup.md) |
| **3. Stakeholders into Claude Code on the repo** | Alex + reps onboard via 1:1 sessions; first prompts run against their own data | [Part 1 §2](./case-study/part1-diagnose-and-prioritize.md) | [WT 2](./quickstart/2-first-prompts-in-claude-code.md) |
| **4. Capture + prioritize bottlenecks** | Bottlenecks captured from the lake (not interviews), ranked by impact × buildability × stakeholder-trust | [Part 1 §3](./case-study/part1-diagnose-and-prioritize.md) | [WT 3](./quickstart/3-bottleneck-capture.md) |
| **5. Agentic dev to ship solutions** | Spec → research → test → ship the top-ranked bottleneck | **All of [Part 2](./case-study/part2-data-foundation.md)** + **all of [Part 3](./case-study/part3-buying-signal-workflow.md)** | *(post-hire)* |
| **6. Roll out to the team** | Adoption mechanic — HITL placement, rep-co-authored bottlenecks, Slack-direct delivery | [Part 1 risk section](./case-study/part1-diagnose-and-prioritize.md) + [Part 3 §(6)](./case-study/part3-buying-signal-workflow.md) | *(post-hire)* |
| **7. Measure → pipeline + revenue** | Closed-loop attribution. Pipeline + revenue is the only legitimate success metric | [Part 2 §Q3](./case-study/part2-data-foundation.md) + [Part 3 §(7)](./case-study/part3-buying-signal-workflow.md) | *(post-hire)* |

**The story this tells:** *Mento asked three questions. The honest answer is they're not three things — they're parts of one OS. Here's the OS, and here's where each of those questions lives inside it.*

## Why this framing matters for Mento specifically

1. **Mento has the data, just not the system.** Two years of warm intros, exec dinners, and Avoma calls means the win-evidence already exists. The OS is the place to put it where Claude Code can find it.
2. **A two-rep team can't survive a "build first, adopt later" rollout.** If reps don't open the OS in week one, no automation built in week four matters. Steps 1–4 are *more* important here than at a 50-person org.
3. **Founder-instinct + rep-instinct divergence is the highest-value gap.** The OS is the only place that gap can be made visible (Step 4 captures it explicitly).

## What the GTM OS is *for*

**The OS is not a deliverable. It's a workshop.** Once it's stood up, it's where every new GTM thing Mento wants to build gets built — new signal types, new playbooks, new scoring rules, new rep workflows. The signal workflow in Part 3 is the *first* thing built inside it, not the only thing.

**Where you go when you want to do X:**

| When Mento wants to… | Where to go in the OS | What gets created |
|---|---|---|
| **Add a new signal source** (new API, new trigger type) | [`gtm-os/step-2`](./gtm-os/step-2-data-playbooks-ingested-daily.md) + Airbyte connector → new row in `signal_events` | New Airbyte source, new SQL signal rule, weights folded into Part 2 §Q3 |
| **Rewrite a playbook** (discovery, demo, objection handling) | Claude Code prompt against `data/avoma/transcripts/` → diff in `foundation/playbooks/` | New playbook PR, versioned, reviewable |
| **Capture a new bottleneck** (rep flagged, founder noticed, lake surfaced) | [`bottlenecks/`](./case-study/part1-diagnose-and-prioritize.md) — one markdown file per bottleneck | New bottleneck node, ranked by impact × buildability × trust |
| **Ship a new workflow** (churn-risk monitor, expansion-signal alerts) | [`gtm-os/step-5`](./gtm-os/step-5-agentic-dev-ship-solutions.md) — spec → research → test → ship | New Trigger.dev jobs, eval-gated, deployed |
| **Re-tune ICP weights** (the lake disagrees with your math) | [Part 2 §Q3](./case-study/part2-data-foundation.md) → monthly logistic regression on `outcomes` | New `archetype_score_*` weights, PR for human review |
| **Add a new archetype** (a new win pattern emerges) | [Part 2 §Q3](./case-study/part2-data-foundation.md) → new SQL CASE-statement column on `accounts` | New archetype score column, MAX() routing picks it up |
| **Onboard a new stakeholder** (RevOps hire, new founder advisor) | [`quickstart/`](./quickstart/) — 3 written guides | Stakeholder running their own prompts in ~1 hour |
| **Re-rank what to build next** (quarterly, or when the lake surfaces a new top problem) | [`gtm-os/step-4`](./gtm-os/step-4-capture-prioritize-bottlenecks.md) | Updated `bottlenecks/_synthesis.md` |
| **Audit a number you don't trust** (priority score, draft quality, lifecycle stage) | Click "Trigger detail" in the Slack card → SQL breakdown of every weight | Every claim one click from source — no black boxes |

**The pattern is always the same.** A new thing wants to exist → it becomes a file → Claude Code uses the lake + existing playbooks to ship it → the eval gate filters it → reps see the output → outcomes flow back into the monthly retrain. **Every shipped thing makes the next thing easier to ship.** That's what makes it an OS, not a project.

## What I'm not claiming

- I haven't seen Mento's actual HubSpot, Avoma, or Slack data. The bottleneck example in Part 1 is illustrative; the real top-1 surfaces from the work in Step 4.
- Steps 5–7 are sketched, not built. The doing of them needs real reps, real deals, and real revenue lift — which can't be faked in a 2–3 hour case study.

— Ari
