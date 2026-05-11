# Mento GTM Engineer Take-Home — Submission

> Ari Davis · 2026-05-11
> Format: GitHub repo + 1-page briefs per part + GTM OS step-by-step + short video walkthrough

## TL;DR — what I'm proposing, and why

Mento's brief asks for three things: diagnose the problem, design a data foundation, build a buying-signal workflow. The honest read of Alex's Slack message is that **none of those three are the actual problem.** The actual problem is that Mento has been winning deals on instinct for two years and there's no system — no place — where that instinct lives outside the founders' heads.

So my submission doesn't propose an automation. **It proposes a GTM Operating System** — a versioned, queryable, multi-stakeholder repo that ingests everything Mento already has and lets the team work *with* their data instead of around it. The signal workflow Mento asked for in Part 3 is one component inside it. Parts 1 and 2 are the foundation that makes Part 3 worth shipping.

The shape comes from a 7-step pattern Tomas Cetner published in May 2026 on building GTM operating systems for client teams in Claude Code. I'd already been building a version of this for a year (my own knowledge graph, the CIA — 350+ nodes, typed wiki-links, daily sync, agentic build discipline). His post named the structure I'd been working in. I'm using that structure here because it's the right shape for Mento, and because being explicit about the shape is how Mento evaluates whether I'm pattern-matching or pattern-applying.

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

## The 7-step GTM OS shape (h/t Tomas Cetner)

```
┌─────────────────────────────────────────────────────────────────────┐
│  GTM OPERATING SYSTEM — 7-step shape                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   1. Repo per client            ─┐                                  │
│   2. Data + ops models +         │  Foundation                      │
│      playbooks ingested daily    │                                  │
│      (Airbyte → Supabase)        │                                  │
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
| **2. Data + playbooks ingested daily** | Everything Mento has (HubSpot, Avoma, Slack, 200-list, enrichment) flows into Supabase daily, with the rules-about-the-data as playbooks in the repo | [Part 1 §1](./case-study/part1-diagnose-and-prioritize.md) — *"why everything, daily"* + **all of [Part 2](./case-study/part2-data-foundation.md)** — dedupe / enrichment / ICP scoring / lifecycle = the playbooks |
| **3. Stakeholders into Claude Code on the repo** | Alex + reps onboard via 1:1 sessions, recorded as walkthrough videos; first prompts run against their own data | [Part 1 §2](./case-study/part1-diagnose-and-prioritize.md) — 3 starter prompts, custom skills/commands graduate from these sessions |
| **4. Capture + prioritize bottlenecks** | Bottlenecks captured from the lake (not from interviews), ranked by impact × buildability × stakeholder-trust | [Part 1 §3](./case-study/part1-diagnose-and-prioritize.md) — `bottlenecks/` directory + Phase 0 data archaeology gate |
| **5. Agentic dev to ship solutions** | Spec → research → test → ship the top-ranked bottleneck | **All of [Part 2](./case-study/part2-data-foundation.md)** (the substrate the ship needs) + **all of [Part 3](./case-study/part3-buying-signal-workflow.md)** (the actual ship — the signal workflow) |
| **6. Roll out to the team** | Adoption mechanic — videos, HITL placement, rep-co-authored bottlenecks, Slack-direct delivery | [Part 1 risk section](./case-study/part1-diagnose-and-prioritize.md) + [Part 3 §(6)](./case-study/part3-buying-signal-workflow.md) — Slack-card HITL design |
| **7. Measure → pipeline + revenue** | Closed-loop attribution. Pipeline + revenue is the only legitimate success metric | [Part 2 §Q3](./case-study/part2-data-foundation.md) — monthly weight re-fit + [Part 3 §(7)](./case-study/part3-buying-signal-workflow.md) — deal-on-reply + outcomes loop |

**The story this tells:** *Mento asked three questions. The honest answer is they're not three things — they're parts of one OS. Here's the OS, and here's where each of those questions lives inside it.*

## Why this framing matters for Mento specifically

Three things make Mento a fit for this shape, not just any GTM-engineer playbook:

1. **Mento has the data, just not the system.** Two years of warm intros, exec dinners, and Avoma calls means the win-evidence already exists. The OS is the place to put it where Claude Code can find it.
2. **A two-rep team can't survive a "build first, adopt later" rollout.** If reps don't open the OS in week one, no automation built in week four matters. Steps 1–4 are *more* important here than at a 50-person org.
3. **Founder-instinct + rep-instinct divergence is the highest-value gap.** The OS is the only place that gap can be made visible (Step 4 captures it explicitly).

## On the video walkthrough

The video walks the **7-step OS, with each step showing where the take-home answer lives inside it.** Not three separate part walkthroughs — one story, three answers fit inside it.

```
0:00 – 1:30   GTM OS — the 7-step shape, why Mento needs it
1:30 – 3:30   Steps 1–4 (Foundation) → Part 1 lives here
3:30 – 5:30   Step 5 substrate → Part 2 lives here
5:30 – 8:00   Step 5 build layer → Part 3 lives here
8:00 – 9:00   Steps 6 + 7 → what comes after 60 days
9:00 – 9:30   Wrap — the repo + Claude Code + Mento
```

## What I'm not claiming

- I haven't seen Mento's actual HubSpot, Avoma, or Slack data. The bottleneck example in Part 1 is illustrative; the real top-1 surfaces from the work in Step 4.
- The 7-step shape is Cetner's, not mine. My contribution is applying it to Mento and naming what's missing.
- Steps 6 and 7 are sketched, not built. They depend on real reps, real deals, and real revenue lift — which can't be faked in a 2–3 hour case study.

## Read order

1. **This README** — the frame
2. **[`gtm-os/`](./gtm-os/)** — the 7-step shape, step by step (recommended)
3. **[`case-study/`](./case-study/)** — direct answers to the take-home (if you'd rather skip the framing)
4. **Video** — the same story, walked end-to-end

— Ari
