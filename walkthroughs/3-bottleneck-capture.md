# 3 — Let the Data Tell You What's Broken

> Audience: Alex · Outcome: a ranked shortlist of bottlenecks pulled *from your own data*, not from a whiteboard session

## What this walkthrough covers

You've played with the lake (walkthrough 2). Now you look at it with one question: **where are we leaking?** The point isn't to build anything yet — it's to let the data nominate the problems so you don't waste cycles building the wrong thing first.

Most GTM hires get pulled to "build the signal workflow" in week one. If the signal workflow isn't the actual #1 bottleneck, reps reject it in week three. This walkthrough is how you avoid that mistake — by reading what's already in your HubSpot, Avoma, and Slack instead of guessing.

## Setup

- Walkthrough 2 done — you've run a few prompts and have a feel for how the data answers questions
- `bottlenecks/` folder exists in `mento-gtm/` (empty for now)
- A blank `bottlenecks/example-template.md` showing the schema below

## Phase 0 — Distrust your CRM labels

The most useful prompt you'll run in this whole sequence:

> *"Take my last 8 closed-won deals. For each one, tell me what was happening at that account in the 90–180 days before close — from anywhere in the data we have (HubSpot activities, Avoma calls, Slack threads, any signal table). Then tell me what HubSpot says the deal source was. Show me where they disagree."*

Typical output:

```
Glimmer Health
  HubSpot says: inbound demo request
  Lake says:     CHRO hired ~45 days pre-discovery
                 (contact-title change captured in hubspot_contacts)
                 Avoma transcript opens with "we just brought
                 Marisol on, comp framework is broken"

  The actual trigger was the CHRO hire. The demo was the
  surface event.

Outpost AI
  HubSpot says: warm intro from Alex
  Lake says:     Avoma reveals a months-long internal pain
                 (L&D + retention) that pre-dates the intro

  Warm intros work because the buyer was already in pain.
  HubSpot's "deal source" field doesn't capture that. The
  conversation data does.
```

Most Mento wins probably look "inbound" or "warm intro" in HubSpot. The conversation data usually shows the buyer was *already in pain* — and the intro was just the trust-bridge to close. **That's the actual win pattern, and it lives in the lake, not in the CRM.**

If you'd skipped Phase 0 and gone straight to "score accounts against the deal-source field," you'd score against the wrong inputs.

## The `bottlenecks/` folder — one file per problem

Each bottleneck is a versioned markdown file. Schema:

```yaml
---
systems_touched: [hubspot, avoma]
problem: 200-account list hasn't been re-scored against new signals in 8 months
how_measured: no "last_signal_check" field exists on any of the 200 accounts
root_cause_hypothesis: no monitor watches for trigger events
desired_outcome: every account has signal state refreshed daily
impact: 9         # missed deals — high
buildability: 7   # known tools, no novel science
trust: 8          # reps will believe alerts from public-data triggers
priority_score: 24
---
```

Three Mento bottlenecks that might surface (illustrative — the *real* top-1 comes from the lake when this gets run for real):

1. `bottlenecks/no-signal-coverage-on-200-list.md` — priority 24
2. `bottlenecks/warm-intros-die-in-slack-threads.md` — priority 19
3. `bottlenecks/playbook-drift-between-reps.md` — priority 16

What matters about the shape:

- Each bottleneck is a **file** — versioned, reviewable, linkable from PRs.
- Priority = **impact × buildability × trust**. Trust is the score most teams skip and the one that determines whether reps will adopt what you ship.
- They came from looking at the data, not from a 30-min interview.

## How ranking works

Claude writes `bottlenecks/_synthesis.md` after you've captured 3–6 bottleneck files:

> *Top 1 — no signal coverage on the 200-list.* Evidence: 4 of last 5 wins had a public trigger fire pre-close; none of those were caught at the time. Replicating detection would've surfaced each deal ~41 days earlier on average.

> *Top 2 — warm-intros dying in Slack threads.* Evidence: 12 of 47 outbound Slack threads in 2026 had no follow-up after 7 days. Costs an estimated ~3 deals/quarter.

The **trust axis is the gate.** Anything shipped has to clear all three — high impact, buildable in ~2 weeks, reps will believe the output. The 200-list bottleneck clears all three. Warm-intros is buildable but trust is medium — would need rep co-design. Playbook drift is high-trust but lower impact. So #1 ships first.

## Why this beats just asking reps

You *could* ask the two reps what hurts. They'd tell you. Two reasons we look at the lake first:

1. **Recency bias.** Reps name the thing that bothered them yesterday. The lake shows what bothered them over 18 months.
2. **Want ≠ worth.** Reps tell you what they want fixed; the lake tells you what's *worth* fixing — i.e., what maps to actual deals.

But — and this matters — once the lake names a top problem, you take it to the reps: *we found this, does it match your experience?* That's where the trust score gets validated. If a rep says "I don't see it," the priority drops. **The data nominates; reps confirm.**

## What you've unlocked

- **Phase 0 done** — you know which wins were really pulled by what triggers, not what HubSpot labeled them.
- **A ranked shortlist of bottlenecks** in `bottlenecks/`, each as a reviewable file.
- **Impact × buildability × trust** as the ranking math — and an answer to "what should we build first?"
- **A list of accounts the lake flagged that you wouldn't have** (from walkthrough 2 prompt 3) — usually one of these is the seed for the top bottleneck.

Walkthrough 4 picks up here — *if you wanted to operationalize the top bottleneck, here's what the workflow shape would look like.*

## Common questions

- **What if the top bottleneck isn't the signal workflow?** Then you don't build the signal workflow first. The take-home picks signals because the brief asked — but the OS would surface whatever was actually #1.
- **Why score impact × buildability × trust, not impact alone?** A 10/10 impact problem that takes 6 months costs more in adoption-kill than a 7/10 shipped in 2 weeks. The score forces honesty about the tradeoff.
- **How often do we re-rank?** Quarterly, or whenever a new lake signal materially changes an estimate.
- **Can reps add bottlenecks?** Yes — `ideas/` is the catch-all. A promoted idea becomes a bottleneck once Claude can fill in the schema (problem, how-measured, hypothesis, outcome) from the lake.
- **Do I need to fix every bottleneck?** No. The 80/20 reality is one or two of them drive most of the leak. Ship those, see what reveals next, re-rank.
