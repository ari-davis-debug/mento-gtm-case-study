# Walkthroughs — look at your data, play with it, then decide what's worth building

> Each walkthrough is *"here's how I'd do this — your stack may differ"* — substitute your equivalents where they fit. The arc isn't "install a production system." It's **mirror what you have, play with it, find the leak, see what a workflow on top would look like, see what reps would experience.**

## Why this folder exists

The case study answers *what* to build. The 7-step OS folder answers *why this shape*. **This folder is the practical bridge** — written guides that show how Mento would get the foundation running and start exploring their own data, without committing to the full execution stack until there's evidence it's worth it.

The foundation stack used here — **Airbyte → Supabase → Claude Code** — is illustrative. Fivetran in place of Airbyte, raw Postgres in place of Supabase, Cursor in place of Claude Code; the pattern survives substitution. What matters is the shape: OAuth ingestion to a lake, queryable from a repo, with deterministic SQL doing the math.

## The arc

```
1. Get your data queryable     →    foundation stack live, lake mirrored daily
        ↓
2. Play with your data         →    three prompts across HubSpot/Avoma/Slack
        ↓
3. Let the data tell you       →    bottlenecks ranked from the lake, not interviews
   what's broken
        ↓
4. See the shape of a          →    "if we operationalized the top bottleneck,
   workflow on top                  here's the workflow shape" — not a deploy
        ↓
5. See what reps would         →    the Slack card a rep would actually see —
   experience                       the adoption test, before anything's built
```

**Walkthroughs 1–3 are things Mento can do on their own with the foundation stack.** Walkthroughs 4–5 are the *shape* of what comes next, so you can decide whether to operationalize — that's execution work, and it's what I'd run once embedded.

## The five walkthroughs

| # | Walkthrough | Audience | What it unlocks |
|---|---|---|---|
| 1 | [Get your data queryable](./1-installation-and-setup.md) | Alex (+ RevOps if there is one) | Foundation stack live: terminal, repo, Airbyte daily sync into Supabase |
| 2 | [Play with your data](./2-first-prompts-in-claude-code.md) | Alex (and any opted-in stakeholder) | Three starter prompts across HubSpot + Avoma + Slack on real Mento data |
| 3 | [Let the data tell you what's broken](./3-bottleneck-capture.md) | Alex | A ranked shortlist of bottlenecks pulled from the lake — not from a whiteboard |
| 4 | [The shape of a workflow built on your data](./4-shipping-the-signal-workflow.md) | Alex (technical co-founder shape) | The shape of the brief's signal workflow — spec, sources, backtest — without committing to the execution stack |
| 5 | [What the end-state looks like for reps](./5-rep-experience-in-slack.md) | Reps (Mento's 2) | The Slack card a rep would see — usable as the adoption test before anything is built |

## Reading order

- **Decision-makers** read #1, #4, #5 — that's setup, the workflow shape, and the rep experience. Enough to decide.
- **Hands-on** is the full sequence, each assumes the prior was completed.
- **New hires (post-rollout)** read all 5 in order on day one.

## What each walkthrough file contains

- **What this walkthrough covers** — one-sentence promise
- **Setup / what you need** — prerequisites
- **Step-by-step** — commands, SQL, prompts, expected output
- **What you've unlocked** — the takeaway
- **Common questions** — the FAQ that means we don't need a sixth walkthrough

## The foundation stack — only four tools

The whole point of this folder is that **you only install four tools to do walkthroughs 1–3:**

- **Claude Code** — the workbench
- **GitHub** — version control for the repo
- **Supabase** — the lake (Postgres + pgvector, free tier)
- **Airbyte** — OAuth ingestion of HubSpot, Avoma, Slack into Supabase

That's it. No Trigger.dev, no SmartLead, no BlitzAPI, no Crunchbase, no Sumble — those only matter *if* you decide to operationalize one of the bottlenecks (walkthrough 4 sketches what that would cost and look like).

## Why Airbyte specifically

It's OAuth-based — no API keys floating around. 350+ connectors as of 2026, including HubSpot, Avoma, Slack natively. **It's the only piece of the stack we get to *not build*.** Custom scrapers are where GTM-engineering teams die. Airbyte gives us the data layer for free so the time gets spent on the playbooks and (later) the build.

## What's NOT in this folder

- Code (would live in the planned `mento-gtm/` build repo — this is a case study, not the build)
- Real Mento data (we haven't seen any — examples are synthetic / placeholder, clearly labeled)
- Install instructions for the execution stack (Trigger.dev, SmartLead, etc.) — that's deliberately scoped to walkthrough 4's *"if you operationalize"* section, not the foundation
