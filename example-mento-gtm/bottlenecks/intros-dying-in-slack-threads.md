---
title: Intros dying in Slack threads
type: bottleneck
status: next
score: 324
impact: 6
buildability: 9
trust: 6
updated: 2026-05-11
---

# Bottleneck — Warm intros dying in Slack threads

> **The pain:** When an investor or founder offers a warm intro, it gets thrown into a Slack thread, the connector says "happy to make the intro," and then... nothing. Three weeks later someone says "wait, did we ever follow up with Sarah at Comparable Co?"

## How we know this is real

- **Data point 1**: Manual audit of #intros Slack channel for last 60 days: 18 offered intros. Of those, 7 were actioned within a week, 4 were actioned within a month (degraded), 7 never actioned at all.
- **Data point 2**: One of the never-actioned intros was to a CHRO who would have been a Tier-1 fit. They signed with Pave 6 weeks later.
- **Data point 3**: When we tracked the time-to-intro-sent for the ones that *did* close-won, the median was 4 days. Slow follow-up correlates with no follow-up.

## Why this is bottleneck #3

| Dimension | Score | Reasoning |
|---|---|---|
| **Impact** | 6 | Warm intros convert way better than cold (probably 4–5×), but volume is low. 18 offered/60d ≈ 100/yr. Even at 50% conversion improvement, low total deal volume. |
| **Buildability** | 9 | Trivial. Slack bot listens for "intro" keyword + name mention, creates a row in a Supabase table, pings the assigned rep at 3-day and 7-day marks if no outbound has fired. Maybe 3 days of build. |
| **Trust** | 6 | Reps + founders may find Slack-bot pings annoying. Connectors (investors) won't know it exists, which is fine. The 6 reflects "this works only if reps don't mute the bot." |

## Why this isn't #1 or #2

Volume. Bottlenecks #1 and #2 affect the entire pipeline; this affects ~100 events/year. High *per-event* leverage, low *total* leverage. Plus it's so cheap to build that it'll get knocked out fast once #1 ships.

## What "shipping the fix" looks like

```
Slack message in #intros mentions [name] + "intro"
  ↓
Bot extracts {connector, target, target_company, offered_at}
  ↓
Writes to supabase.warm_intros
  ↓
3 days later: if no outbound sent → DM the assigned rep
  ↓
7 days later: if still no outbound → escalate to founder
```

Eval gate: intro-to-outbound time drops from "never / median 12 days" → median 3 days within 30 days.

## What we'll know after we ship

- Whether the bottleneck is "nobody remembered" (this fix solves it) or "nobody had time" (this fix doesn't solve it)
- Whether warm intros actually convert at the rate we think they do (we'll have data finally)

## Linked
- [`../services/signal-workflow/spec.md`](../services/signal-workflow/spec.md) — adjacent build, same Slack patterns
