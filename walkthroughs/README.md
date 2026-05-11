# Walkthroughs — how you'd actually stand this up

> The adoption mechanic, written out. Each walkthrough is *"here's how I'd do this — your stack may differ"* — substitute your equivalents where they fit.

## Why this folder exists

The case study answers *what* to build. The 7-step OS folder answers *why this shape*. **This folder is the practical bridge** — written guides that show how a stakeholder (or new hire) would actually get the system running on their own machine.

The stack used here (Airbyte → Supabase → Trigger.dev → Claude Code → SmartLead) is illustrative. The pattern survives substitution — Fivetran instead of Airbyte, n8n instead of Trigger.dev, Outreach instead of SmartLead. What matters is the shape: OAuth ingestion to a lake, deterministic SQL for math, AI for the parts where taste matters, HITL at the draft.

## The five walkthroughs

| # | Walkthrough | Audience | What it unlocks |
|---|---|---|---|
| 1 | [Installation and setup — Airbyte OAuth + repo tree](./1-installation-and-setup.md) | Alex (+ RevOps if there is one) | Lake alive, daily sync running, repo cloned |
| 2 | [First prompts in Claude Code](./2-first-prompts-in-claude-code.md) | Alex (and any opted-in stakeholder) | Stakeholder running 3 starter prompts against their own data |
| 3 | [Bottleneck capture](./3-bottleneck-capture.md) | Alex | Top 1–2 bottlenecks ranked from the lake, not from interviews |
| 4 | [Shipping the signal workflow](./4-shipping-the-signal-workflow.md) | Alex (technical co-founder shape) | A top-ranked bottleneck becomes a shipped, eval-gated workflow |
| 5 | [Rep experience in Slack](./5-rep-experience-in-slack.md) | Reps (Mento's 2) | What a rep actually does — first card, three buttons |

## Reading order

- **Decision-makers** can read #1 and #5 — those are the bookends. Setup and rep experience.
- **The full series** is the proper sequence; each walkthrough assumes the prior one was completed.
- **New hires** (post-rollout) read all 5 in order on day one.

## What each walkthrough file contains

Every walkthrough is structured the same way:

- **What this walkthrough covers** — one-sentence promise
- **Setup / what you need installed** — prerequisites before starting
- **Step-by-step** — commands, SQL, prompts, expected output
- **What you've unlocked** — the takeaway
- **Common questions** — the FAQ that means we don't need a sixth walkthrough

## The connector that makes this whole series possible

**Airbyte.** It's the OAuth-based ingestion layer that pulls HubSpot, Avoma, Slack, Apollo, Crunchbase, Sumble, Greenhouse / Lever, and TheirStack into Supabase on a daily schedule. **No API keys floating around** — Alex authorizes each source once via the standard OAuth dance, and the daily sync is live. Walkthrough 1 is mostly about Airbyte.

Why Airbyte and not a hand-rolled integration: it's the only piece of the stack we get to *not build*. Custom scrapers are where GTM-engineering teams die. Airbyte gives us the data layer for free and lets us spend the time on the playbooks and the build (the parts that are actually Mento's).

## What's NOT in this folder

- Code (lives in the planned `mento-gtm/` build repo — this is a case study, not the build)
- Real Mento data (we haven't seen any — examples show synthetic / placeholder data, clearly labeled)
