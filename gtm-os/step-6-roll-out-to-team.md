# Step 6 — Roll Out to the Team

> Operate · Day 45–60

## What this step is

Get the workflow into the hands of Mento's two reps in a way they actually use. **Adoption mechanic** — not feature delivery.

## Why this step matters

A two-rep team that has closed deals on instinct for two years will reject any system producing leads they don't recognize as "ours." This is the highest failure mode in the 60-day plan — bigger than data quality, bigger than build complexity. Step 6 is designed against that exact failure.

## What concrete work happens here

### The three pillars of adoption

| Pillar | What it is | Why it works |
|---|---|---|
| **Slack-direct delivery** | The system pings the rep in Slack, not Gmail drafts. Rich card with score breakdown, verified contact, draft preview, deep links | Reps check Slack 100× a day; Gmail draft folder gets ignored. |
| **HITL placement at draft, not trigger** | Rep approves the *email*, not the *signal*. Approval fatigue is the killer; reading a good draft is trust-building, not chore-checking | Trust comes from seeing a *good draft*, not a *good trigger*. |
| **Rep-co-authored bottlenecks** | The thing being shipped (Step 5) is one of the bottlenecks the team ranked in Step 4 — not an automation a GTM engineer guessed they needed | Reps adopt what they helped pick. |

### The written walkthrough series
The adoption mechanic in practice. Five written walkthroughs live in [`quickstart/`](../quickstart/):

1. **Installation and setup** — Airbyte OAuth into HubSpot/Avoma/Slack, repo tree tour
2. **First prompts in Claude Code** — what a stakeholder does in their first 45 minutes
3. **Bottleneck capture** — how Step 4 surfaces the top 1–2 problems
4. **Shipping the signal workflow** — spec → tests → ship, with HITL placement
5. **Rep experience in Slack** — the signal-card UX

Mento can hand the walkthroughs to the next hire and onboard them in a morning.

### Slack-card design (the actual UX rep sees)
Detailed in [Part 3 §(6)](../case-study/part3-buying-signal-workflow.md). One-page brief, three buttons (Approve & Send / Edit / Skip), every claim deep-linked to source.

## Which take-home sections live inside this step

- [Part 1 *"Biggest risk to 60 days"* section](../case-study/part1-diagnose-and-prioritize.md) — adoption is named as the #1 risk, mitigations embedded in this step
- [Part 3 §(6) — *"HITL — Slack-direct, not Gmail"*](../case-study/part3-buying-signal-workflow.md) — the actual rep-facing UX

## What's next

[Step 7 — Measure → pipeline + revenue](./step-7-measure-pipeline-revenue.md) — adoption is necessary but not sufficient. The OS only earns its keep when pipeline and revenue move. Closed-loop attribution is the final step.
