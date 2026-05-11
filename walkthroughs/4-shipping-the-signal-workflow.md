# 4 — Shipping the Signal Workflow

> Audience: Alex (technical co-founder shape) · Outcome: see how a top-ranked bottleneck becomes a shipped, eval-gated workflow

## What this walkthrough covers

Take the #1 bottleneck from walkthrough 3 — *no signal coverage on the 200-list* — and ship it inside the OS. **Spec → research → test → ship**, with HITL placement at the right point. By the end, a `trigger_events` table is filling with rows and the Slack-card hook is wired (walkthrough 5 is what the rep sees).

## Setup

- Repo at the end of walkthrough 3 — three ranked bottlenecks
- Trigger.dev account provisioned, no jobs deployed yet
- BlitzAPI, Crunchbase, Sumble API keys in the Airbyte secrets manager
- A synthetic 200-list with 5 accounts queued to fire signals during testing (Glimmer, Outpost, Lithos, Conduit, Vesta)

## Step 1 — Write the spec (one paragraph in, one spec out)

In Claude Code:

> *"Write me a spec for the signal workflow. Inputs: the 200-list + ICP ≥ 70 inbound. Outputs: top-10 priority queue per rep per day, delivered as a Slack card with verified contact and a personalized draft email. Constraints: deterministic scoring SQL, AI only for the draft and a short explanation paragraph, HITL at the draft, never auto-send, eval gate before draft pings the rep."*

Claude writes `specs/signal-workflow.md`. Key sections:

- **Stages** — Monitor / Enrich / Score / Route / Draft / HITL / Approve→CRM→Sequencer
- **The three lanes** — what runs as enrichment, what runs as SQL, what runs as AI
- **Eval gate** — LLM-as-judge against held-out won emails, threshold 0.85
- **Out-of-scope** — auto-send, multi-step nurture (SmartLead handles that)

One paragraph from you. One spec from Claude. Reviewable, version-controlled, the source of truth for everything you ship next.

## Step 2 — Research: pick tools, with cross-checks

> *"For each signal source — funding, exec hires, headcount growth, L&D postings — propose a primary API and a cross-check. Justify each against the alternatives. No single point of failure."*

Claude pulls from the case study's tool research and returns:

| Signal | Primary | Cross-check |
|---|---|---|
| Series B/C/D | Crunchbase Pro webhook | The Org funding + TechCrunch RSS |
| Headcount ≥ 20% | Sumble | LinkedIn Firecrawl + Crunchbase employee tracking |
| New CHRO/CPO | The Org + Crunchbase people | LinkedIn announcement posts |
| L&D job posting | Sumble | Greenhouse + Lever board APIs |

No signal rides on a single tool. Sumble could go down tomorrow and the system still fires. That's not paranoia; that's how you build a signal layer that survives a vendor outage.

## Step 3 — Backtest before deploy

> *"Before we wire this live, backtest. For each of Mento's last 5 closed-won deals, replay the public signals that fired in the 90 days pre-close. Score them with the current weights. Confirm the top decile correlates with closed-won."*

Claude reads `data/hubspot/deals.snapshot.md` and `data/signals/`, runs the SQL:

```
Backtest — trigger weights vs. closed-won
─────────────────────────────────────────
Glimmer Health     priority=170  ←   won
Outpost AI         priority=145  ←   won
Lithos Bio         priority=128  ←   won
Conduit Labs       priority=118  ←   won
Vesta Robotics     priority= 96  ←   won

Top decile of all triggers in window: 89% closed-won
AUC: 0.83 (target ≥ 0.75)
```

This is the test gate. If the SQL weights don't separate won and lost deals cleanly, the weights are wrong and you tune them before any rep sees a result. **AUC of 0.83 clears the floor.** Ship.

Second eval before deploy: LLM-as-judge against held-out won emails. *"Voice match, trigger specificity, lake-evidence grounded, length under 120 words, no AI tells."* Drafts under 0.85 retry with feedback before they leave the system.

## Step 4 — Ship via Trigger.dev

Four jobs ship as one PR:

1. `monitor-crunchbase-webhook` — funding events
2. `monitor-the-org-daily` — exec hires
3. `monitor-sumble-daily` — headcount + L&D postings
4. `score-and-route` — runs after every `trigger_events` insert

Deploy from the terminal:

```bash
cd mento-gtm/trigger
npx trigger.dev deploy
```

Production deploy. The jobs run on Trigger.dev's infrastructure — no VPS to monitor, no cron to babysit, no scrapers to host. Trigger.dev runs the schedule, retries on failure, and gives you observability for free.

## Step 5 — HITL placement: why the draft, not the trigger

Most signal-workflow builds put the rep in the loop at the wrong place — they want the rep to approve every trigger. That's approval fatigue. Reps ignore it by week three. System dies.

Put the human in the loop at the **draft** — because reading a good draft is trust-building, but approving a trigger is chore-checking. Same hands-on, different feel.

The Slack-card shape (walkthrough 5 shows the live thing):

- Priority + score breakdown
- Verified contact (BlitzAPI)
- Draft email preview
- Three buttons: Approve & Send / Edit / Skip

The eval gate already filtered drafts under 0.85 — by the time the rep sees one, it's good. **The rep's job is taste, not quality control.** Taste is what reps are uniquely good at.

## What just shipped

- Spec written
- Tools picked with cross-checks
- Weights backtested against 5 won deals
- Eval gate locked at 0.85
- Trigger.dev jobs deployed
- Slack hook wired

The 200-list is being checked daily. Walkthrough 5 is the moment a rep opens Slack and sees the first card.

## What you've unlocked

- **Spec, research, test, ship — four stages, one repo.** Every artifact lives in `mento-gtm/`.
- **Backtest before deploy.** AUC ≥ 0.75 against won deals or the weights are wrong.
- **Eval gate before HITL.** Drafts under 0.85 retry; the rep never sees a bad one.
- **HITL at the draft, not the trigger.** Trust comes from good drafts, not gated triggers.
- **Trigger.dev does the orchestration.** No infrastructure to run for a 2-rep team.

## Common questions

- **Why Trigger.dev and not n8n?** Code-first. Version-controlled. Code review applies. n8n is the alternative for ops logic that needs to change weekly without a deploy — explained in Part 2 Q2.
- **What if the AUC is below 0.75?** Don't ship. Tune the weights by hand against the won-deal cohort, re-test, re-ship. Closed-loop monthly retrain (Step 7) is the long-term answer; weight bootstrapping is the short-term one.
- **What if a rep doesn't like the draft?** Edit button. The diff between agent draft and rep edit is the highest-quality training signal you get. Captured to `outcomes` and fed into the next eval-gate calibration.
- **How do we know we're not over-fitting the backtest?** 20% holdout. Train weights on 80%, test on 20%. Math is in Part 2 Q3.
- **What's the cost?** Trigger.dev free tier covers the deployment. BlitzAPI is the largest single cost ($499 email + $599 phone, unlimited). Crunchbase API and Sumble are seat-based — under $1K/mo combined. Detailed in Part 2 Q2.
