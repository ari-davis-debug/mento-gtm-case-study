# Video 3 — Walking the Bottleneck Capture

> ~5 minutes · Audience: Alex · Goal: top 1–2 bottlenecks ranked from the lake, not from interviews

## What this video shows

By the end of 5 minutes, Alex has a ranked `bottlenecks/` folder — each bottleneck a markdown file with the same schema — and the top item is what video 4 builds.

## Setup before hitting record

- The repo as it sits at the end of video 2 — lake alive, three starter prompts run
- `bottlenecks/` folder exists but is empty
- Pre-prepared `bottlenecks/example-template.md` with the schema in front-matter

## Beat-by-beat

### 0:00–0:30 — Why this video matters

> *"Most GTM-engineer hires get pulled straight to 'build the signal workflow.' That's a mistake. If you build the wrong thing first, the reps reject it in week three and the whole OS dies. This video is how we make sure we build the right thing — by letting the data tell us what hurts, not the founder's gut."*

### 0:30–1:30 — Phase 0: data archaeology (distrust the CRM labels)

> *"Before we rank anything, we do something the brief calls Phase 0 — data archaeology."*

Run in Claude Code:

> *"Take Mento's last 8 closed-won deals. For each one, tell me what was publicly true about that account 6 to 18 months before close — funding, headcount delta, exec turnover, Glassdoor inflection, careers-page churn. Then tell me what HubSpot says the deal source was. Show me where they disagree."*

Show the output. Common pattern:

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

> *"Most of Mento's wins look 'inbound' in HubSpot. The lake shows they weren't — they were ICP accounts that hit a trigger, and the warm intro was the trust-bridge to close. That's the actual win pattern. Without Phase 0, we'd have built scoring against the wrong inputs."*

### 1:30–3:00 — The bottlenecks/ folder, one node per problem

Show the schema:

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

> *"Three things to notice. One: each bottleneck is a *file*, not a row in a spreadsheet — versioned, reviewable, linkable. Two: priority is `impact × buildability × trust` — the trust score is what keeps us from shipping technically-perfect things reps will reject. Three: these came from the lake, not from interviews. That's the difference."*

### 3:00–4:00 — How we rank — the math

Open `bottlenecks/_synthesis.md` — Claude wrote it:

> *"Top 1 — no signal coverage on the 200-list. Driving factors: 4 of last 5 wins had a public trigger fire pre-close, none of those triggers were detected by Mento at the time. Replicating that detection would have surfaced the deal an average of 41 days earlier."*

> *"Top 2 — warm-intros dying in Slack threads. Driving factor: 12 of 47 outbound Slack threads in 2026 have no follow-up after 7 days. Costs ~3 deals/quarter at current win rate."*

Score each on the trust axis explicitly:

> *"This is the gate. Anything we ship has to clear all three — high impact, buildable in 2 weeks, reps will trust it. The 200-list bottleneck clears all three. Warm-intros bottleneck is buildable but trust is medium — would need rep co-design. Playbook drift is high-trust but lower impact. We ship #1 first."*

### 4:00–5:00 — Why this beats interviewing reps

> *"You could have just asked the two reps what hurts. They'd tell you — they always do. The reason we don't is two-fold."*

1. *"Reps will name the thing that bothered them yesterday — recency bias. The lake shows what bothers them over 18 months."*
2. *"Reps will tell you what they want fixed, not what's *worth* fixing. The lake tells you which problems map to deals."*

> *"But — and this matters — once the lake says 'X is the top problem,' we go to the reps and say *we found this, does it match your experience?* That's where the trust score gets validated. If a rep says 'I don't see it,' the priority drops. The data nominates; the rep confirms."*

> *"Now we have the bottleneck. Video 4 is how we ship it."*

## What the viewer walks away knowing

- **Phase 0 first** — distrust the CRM, cross-reference public data, find the real trigger.
- **Each bottleneck is a file** with a fixed schema. Reviewable, rankable, comparable.
- **Priority = impact × buildability × trust.** Trust is the score most teams skip.
- **Data nominates, reps confirm.** Not interviews to find bottlenecks; lake to find them, rep to validate.

## Common questions this video should answer

- *"What if the top bottleneck isn't the signal workflow?"* → Then we don't build the signal workflow first. The take-home submission picks the signal workflow because the brief asked for it — but the OS would have surfaced whichever was actually #1. The methodology doesn't change.
- *"Why score impact × buildability × trust, not impact alone?"* → Because a 10/10 impact problem that takes 6 months to ship costs more in adoption-kill than a 7/10 problem shipped in 2 weeks. The score forces honesty about the tradeoff.
- *"How often do we re-rank?"* → Quarterly. Or whenever a new lake signal materially changes the impact estimate on an existing bottleneck.
- *"Can reps add bottlenecks?"* → Yes. The `ideas/` folder is the catch-all; promoted ideas become bottlenecks once Claude can fill in the schema (problem, how-measured, hypothesis, outcome).
