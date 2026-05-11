# 3 — Bottleneck Capture

> Audience: Alex · Outcome: top 1–2 bottlenecks ranked from the lake, not from interviews

## What this walkthrough covers

How to let the data tell you what to build first. Most GTM-engineer hires get pulled straight to "build the signal workflow." If you build the wrong thing first, reps reject it in week three and the whole OS dies. This is how to make sure you build the right thing.

## Setup

- Repo as it sits at the end of walkthrough 2 — lake alive, three starter prompts run
- `bottlenecks/` folder exists but is empty
- A `bottlenecks/example-template.md` with the schema in front-matter

## Phase 0 — Data archaeology (distrust the CRM labels)

Before ranking anything, run this in Claude Code:

> *"Take Mento's last 8 closed-won deals. For each one, tell me what was publicly true about that account 6 to 18 months before close — funding, headcount delta, exec turnover, Glassdoor inflection, careers-page churn. Then tell me what HubSpot says the deal source was. Show me where they disagree."*

Typical output:

```
Glimmer Health
  HubSpot says: inbound demo request
  Lake says:     CHRO Marisol Hwang hired 45 days pre-discovery
                 Series C ($80M) 62 days pre-discovery
                 23% headcount growth in 180d pre-close

  The actual trigger was the CHRO hire. The demo request was
  the surface event.

Outpost AI
  HubSpot says: warm intro from Alex
  Lake says:     L&D req opened 30 days pre-intro
                 Glassdoor career-growth score dropped 3.4 → 2.6
                 over the 9 months pre-intro

  Warm intros work because the buyer was already in pain.
  HubSpot doesn't capture that. The lake does.
```

Most of Mento's wins look "inbound" in HubSpot. The lake shows they weren't — they were ICP accounts that hit a trigger, and the warm intro was the trust-bridge to close. **That's the actual win pattern.** Without Phase 0, you'd build scoring against the wrong inputs.

## The `bottlenecks/` folder — one node per problem

Each bottleneck is a file with this schema:

```yaml
---
systems_touched: [hubspot, apollo, manual]
problem: 200-account list hasn't been re-scored against signals in 8 months
how_measured: 0 of 200 accounts have a "last_signal_check" field
root_cause_hypothesis: no automated signal monitor exists
desired_outcome: every account has signal state refreshed daily
impact: 9      # missed deals — high
buildability: 7 # tools exist, no novel science
trust: 8       # reps will believe alerts from public-data triggers
priority_score: 24
---
```

Three bottlenecks Mento likely has, written as nodes:

1. `bottlenecks/no-signal-coverage-on-200-list.md` — priority 24
2. `bottlenecks/warm-intros-die-in-slack-threads.md` — priority 19
3. `bottlenecks/playbook-drift-between-reps.md` — priority 16

Three things to notice:

1. Each bottleneck is a **file**, not a row in a spreadsheet — versioned, reviewable, linkable.
2. Priority is **impact × buildability × trust**. Trust is what keeps you from shipping technically-perfect things reps reject.
3. These came from the lake, not from interviews. That's the difference.

## How the ranking math works

Open `bottlenecks/_synthesis.md` — Claude writes it:

> Top 1 — no signal coverage on the 200-list. Driving factors: 4 of last 5 wins had a public trigger fire pre-close, none of those triggers were detected by Mento at the time. Replicating that detection would have surfaced the deal an average of 41 days earlier.

> Top 2 — warm-intros dying in Slack threads. Driving factor: 12 of 47 outbound Slack threads in 2026 have no follow-up after 7 days. Costs ~3 deals/quarter at current win rate.

The trust axis is the gate. Anything you ship has to clear all three — high impact, buildable in 2 weeks, reps will trust it. The 200-list bottleneck clears all three. Warm-intros is buildable but trust is medium — would need rep co-design. Playbook drift is high-trust but lower impact. Ship #1 first.

## Why this beats interviewing reps

You could have just asked the two reps what hurts. They'd tell you — they always do. Two reasons we don't:

1. **Recency bias** — reps name the thing that bothered them yesterday. The lake shows what bothers them over 18 months.
2. **Want ≠ worth** — reps tell you what they want fixed, not what's *worth* fixing. The lake tells you which problems map to deals.

But — and this matters — once the lake says "X is the top problem," go to the reps and say *we found this, does it match your experience?* That's where the trust score gets validated. If a rep says "I don't see it," the priority drops. **The data nominates; the rep confirms.**

Now you have the bottleneck. Walkthrough 4 is how you ship it.

## What you've unlocked

- **Phase 0 first** — distrust the CRM, cross-reference public data, find the real trigger.
- **Each bottleneck is a file** with a fixed schema. Reviewable, rankable, comparable.
- **Priority = impact × buildability × trust.** Trust is the score most teams skip.
- **Data nominates, reps confirm.** Not interviews to find bottlenecks; lake to find them, rep to validate.

## Common questions

- **What if the top bottleneck isn't the signal workflow?** Then we don't build the signal workflow first. The take-home picks the signal workflow because the brief asked for it — but the OS would have surfaced whichever was actually #1. The methodology doesn't change.
- **Why score impact × buildability × trust, not impact alone?** A 10/10 impact problem that takes 6 months to ship costs more in adoption-kill than a 7/10 problem shipped in 2 weeks. The score forces honesty about the tradeoff.
- **How often do we re-rank?** Quarterly. Or whenever a new lake signal materially changes the impact estimate on an existing bottleneck.
- **Can reps add bottlenecks?** Yes. The `ideas/` folder is the catch-all; promoted ideas become bottlenecks once Claude can fill in the schema (problem, how-measured, hypothesis, outcome).
