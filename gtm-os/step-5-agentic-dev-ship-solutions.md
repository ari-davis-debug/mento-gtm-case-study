# Step 5 — Agentic Dev to Ship Solutions

> Build · Day 10–45 (the longest step)

## What this step is

Take the top-ranked bottleneck from Step 4 and ship the thing that solves it. **Spec → research → test → ship**, run inside Claude Code, with the lake + the playbooks (Steps 1–2) as the substrate the build sits on.

For Mento, the assumed top bottleneck is **signal coverage on the 200-list** — so the ship is the buying-signal workflow Mento asked for in the brief.

## Why this step matters

The earlier steps make the build possible. *This* step is where the actual outbound system gets stood up and starts producing meetings. Without Steps 1–4, this step builds the wrong thing or builds it on bad data.

## What concrete work happens here

### Two halves of the build

```
                ┌────────────────────────────────────┐
                │       STEP 5 — the build           │
                └────────────────────────────────────┘
                                │
                ┌───────────────┴────────────────┐
                ▼                                 ▼
   ┌─────────────────────┐         ┌─────────────────────────┐
   │ Substrate (Part 2)  │         │ Build layer (Part 3)    │
   │ • Lake mirror       │  feeds  │ • Monitor (triggers)    │
   │ • Dedupe playbook   │ ──────▶ │ • Enrich (BlitzAPI etc.)│
   │ • Enrichment runs   │         │ • Score / prioritize    │
   │ • ICP scoring       │         │ • Route (deterministic) │
   │ • Lifecycle machine │         │ • Draft (AI + eval gate)│
   └─────────────────────┘         │ • HITL (Slack card)     │
                                   │ • Sequencer (SmartLead) │
                                   └─────────────────────────┘
```

The substrate has to be real before the build layer is worth shipping. Otherwise the signal workflow scores accounts using bad ICP weights, on top of a lake full of duplicates, with no lifecycle gates downstream. House of cards.

### Three-lane discipline (locked in throughout)
Every component in this step labels which lane it lives in:

- **Enrichment** (fetches from outside) — Crunchbase, BlitzAPI, The Org, Sumble, TheirStack, Firecrawl
- **SQL** (organizes data we already have) — dedupe, ICP scoring, trigger scoring, priority view, lifecycle transitions
- **AI** (interprets) — draft generation, LLM-as-judge eval gate, score-explanation paragraphs, edge-case escalation

A rep can ask *"why is this account #1 in my queue today?"* and trace the answer back to *which lane produced each number*.

### The hardest piece (the one I'd actually build)
The **draft generator with the eval gate**. Everything else — Crunchbase webhooks, SQL scoring, routing rules, Slack Block Kit cards, HubSpot upserts, SmartLead handoff — is plumbing. Wire-able in a day each.

The draft generator is what makes the workflow defensible: agentic email that sounds like Alex wrote it, references a real Avoma quote from a comparable Mento customer, ties to the specific signal that fired, and passes an automated voice-match check (≥ 0.85) before the rep ever sees it.

## Which take-home sections live inside this step

This is the biggest step of the OS, so both Parts 2 and 3 live inside it.

- **All of [Part 2 — Data Foundation Plan](../case-study/part2-data-foundation.md)** = the substrate half of this step
- **All of [Part 3 — Buying Signal Workflow](../case-study/part3-buying-signal-workflow.md)** = the build-layer half

## What's next

[Step 6 — Roll out to the team](./step-6-roll-out-to-team.md) — once the build is shipped, the rep adoption mechanic determines whether it lives or dies. Slack-direct delivery, HITL placement, rep-co-authored bottlenecks, written walkthroughs.
