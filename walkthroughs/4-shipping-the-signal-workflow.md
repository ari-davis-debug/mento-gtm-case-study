# 4 — The Shape of a Workflow Built on Your Data

> Audience: Alex (technical co-founder shape) · Outcome: see what it would look like to take your top bottleneck and turn it into an operating workflow — *if and when you decide to*

## What this walkthrough covers

You've found the top bottleneck (walkthrough 3). This walkthrough is the **shape** of what shipping a workflow on top of it would look like — not a deploy guide. The actual deploy is the kind of thing I'd run once embedded (steps 6–7 of the OS); this is so you can *see the shape and decide if you'd want it built that way.*

The bottleneck we'll walk through is the brief's signal workflow — *no signal coverage on the 200-list.* Same shape applies to whichever bottleneck the lake actually surfaces as #1.

**Read this as "here's the picture," not "here's the install."** None of the execution-stack tools below need to be installed in walkthroughs 1–3.

## The shape, in five moves

```
┌─────────────────────────────────────────────────────────────────────┐
│  Signal workflow — shape, not stack                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   1. SPEC      "what does the workflow do, in one paragraph?"       │
│        ↓                                                            │
│   2. SOURCES   "what data fires it, with cross-checks?"             │
│        ↓                                                            │
│   3. BACKTEST  "would this have flagged our last 5 wins?"           │
│        ↓                                                            │
│   4. DRAFT     "what does the rep actually see when it fires?"      │
│        ↓                                                            │
│   5. EVAL      "before a rep sees a draft, what filters bad ones?"  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

The decision to *deploy* a real version of this comes after — and only if — these five moves all land cleanly. That's the bar.

## Move 1 — Spec (one paragraph in, one spec out)

In Claude Code:

> *"Write a one-page spec for a signal workflow that watches the 200-list for trigger events, scores each account daily, drafts a personalized outbound from the win-pattern playbooks, and surfaces the top 10 to the assigned rep — never auto-sending. Deterministic SQL for scoring, AI only for the draft + a short explanation. HITL at the draft, with an eval gate before the rep sees anything."*

Claude writes `specs/signal-workflow.md`. The spec is the conversation point — *is this the workflow you'd want?* If yes, it becomes the source of truth for everything downstream. If no, you edit one paragraph and Claude regenerates.

**That's a 10-minute artifact, not a 10-day project.**

## Move 2 — Signal sources (with cross-checks)

> *"For each signal — funding, exec hires, headcount growth, L&D postings — propose a primary data source and a cross-check. No single point of failure."*

Claude proposes:

| Signal | Primary | Cross-check |
|---|---|---|
| Series B/C/D | Crunchbase Pro webhook | The Org funding + TechCrunch RSS |
| Headcount ≥ 20% in 90d | Sumble | LinkedIn scrape + Crunchbase employees |
| New CHRO / CPO | The Org + Crunchbase people | LinkedIn announcement posts |
| L&D job posting | Sumble | Greenhouse + Lever board APIs |

**No signal rides on a single tool.** Sumble could go down tomorrow and the system still fires. The cross-check pattern is what makes a signal layer survive a vendor outage.

*Heads up: none of these are in walkthrough 1's foundation stack. They get added only if you decide to operationalize. Until then, you can still backtest in Move 3 against whatever historical signals are reconstructable from HubSpot/Avoma/Slack alone.*

## Move 3 — Backtest, before anything goes live

> *"For Mento's last 5 closed-won deals, replay the signals that would have fired in the 90 days pre-close. Score them with the proposed weights. Does the top decile correlate with closed-won?"*

A clean output looks like:

```
Backtest — proposed weights vs. closed-won
─────────────────────────────────────────
Glimmer Health     priority=170   ← won
Outpost AI         priority=145   ← won
Lithos Bio         priority=128   ← won
Conduit Labs       priority=118   ← won
Vesta Robotics     priority= 96   ← won

Top decile of triggers in window: 89% closed-won
AUC: 0.83  (target ≥ 0.75)
```

**This is the gate.** If the math doesn't separate won-from-lost cleanly on data you already have, you don't deploy — you tune the weights by hand against the won cohort and re-backtest. **Most of the value of this walkthrough is being able to run this test before anyone wires up a single API.**

## Move 4 — Draft (what the rep actually sees)

The draft is the artifact reps interact with. Spec from Move 1 says: *AI for the draft, deterministic SQL for the score, human for taste.* In Claude Code, you can preview what a draft looks like for any test account:

> *"Draft an outbound for Glimmer Health if the workflow fires. Pull a relevant quote from one of our last 5 wins where the buyer talked about post-CHRO comp pain. Reference the specific trigger. Under 120 words, in Alex's voice."*

You'll see the actual email. You'll know whether it sounds like Mento or like generic outbound AI. **If it doesn't sound like Alex, the draft generator isn't ready — and that's a finding worth knowing before any deploy.**

## Move 5 — Eval gate (before any rep sees a bad draft)

LLM-as-judge against a held-out cohort of won emails. Threshold 0.85 on:

- Voice match (does this sound like Alex?)
- Trigger specificity (does it actually reference the trigger?)
- Lake grounding (does it cite a real Avoma quote / win pattern?)
- Length under 120 words
- No AI tells

**Drafts under 0.85 retry with feedback before they ever reach a rep.** The rep's job is taste, not quality control. Quality control is the eval gate's job.

## What an *operationalized* version would look like (when you're ready)

Once moves 1–5 land cleanly, the execution stack adds three things on top of the foundation stack from walkthrough 1:

| Layer | Tool | What it does |
|---|---|---|
| **Orchestration** | Trigger.dev | Runs `monitor-crunchbase`, `monitor-the-org`, `monitor-sumble`, `score-and-route` jobs daily/webhook |
| **Enrichment** | Crunchbase Pro, Sumble, The Org, BlitzAPI | Fills the signal tables that the SQL scores against |
| **Outbound** | SmartLead (multi-channel: email + LinkedIn + SMS) | Sends approved drafts on the cadence Alex sets |

Total marginal cost: **~$2.5K/mo** for the execution stack on top of the foundation. Compared to a single mid-market hire's loaded cost, that's the trade.

But the only reason to install this stack is *after* moves 1–5 have proven the workflow worth operationalizing. **Until then, don't pay for what you're not using.** That's what walkthrough 1 was building toward.

## HITL placement — why the draft, not the trigger

Most signal-workflow builds put the rep in the loop at the wrong place — they want approval on every trigger. That's chore-checking, and reps ignore it by week three. System dies.

Put the human at the **draft** — reading a good draft is trust-building. The eval gate has already filtered bad ones. **By the time the rep sees a card, it's worth their taste, not their fatigue.**

Walkthrough 5 is what that Slack card looks like in the rep's hands — end-state, not build-instructions.

## What you've unlocked

- **You can see the shape of a workflow without installing the stack.**
- **Backtest is the gate before deploy** — AUC ≥ 0.75 against historical wins or the weights are wrong.
- **HITL at the draft, eval gate above it** — the rep's role is taste, not QA.
- **You know what the execution stack would cost** and what each piece would do — so when (if) you operationalize, the decision is clean.

## Common questions

- **Why this much rigor before shipping?** Because the cost of building the wrong workflow isn't the cost of the workflow — it's the cost of losing rep trust. Once a 2-rep team rejects something, the next thing you ship is fighting uphill.
- **Why Trigger.dev over n8n/Inngest, if we operationalize?** Code-first, version-controlled, code review applies. n8n is fine for ops logic that needs to change weekly without a deploy — different shape.
- **What if the backtest is below 0.75?** Don't ship. Tune the weights by hand against the won-deal cohort, re-test. Closed-loop monthly retrain is the long-term answer; manual bootstrap is the short-term one.
- **What if a rep doesn't like a draft?** Once operationalized, the Slack card has an Edit button. The diff between agent draft and rep edit is the highest-quality training signal you'll ever get — captured to `outcomes`, fed into the next eval-gate calibration.
- **Can we operationalize less than the full workflow?** Yes. The cheapest first ship is just the Slack card with manual approval, no SmartLead. Trigger.dev free tier + the existing lake + Slack webhook. Adds maybe $0/mo and tests the rep-adoption mechanic before you pay for the rest.
