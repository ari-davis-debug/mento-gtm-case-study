---
title: No trigger coverage on 200-list
type: bottleneck
status: ready-to-build
score: 504
impact: 9
buildability: 7
trust: 8
updated: 2026-05-11
---

# Bottleneck — No trigger coverage on 200-list

> **The pain:** Of the 200 named accounts on the priority list, only ~30 have any trigger detection running against them. The other 170 sit dark until a rep manually checks LinkedIn or The Org. By the time we notice a CHRO hire, the buying window is half-closed.

## How we know this is real

- **Data point 1**: Acme CHRO was hired 2026-03-15. Our `signal_events` table didn't fire until 2026-04-22 — **37 days of lag** while the window was hottest.
- **Data point 2**: In the last 90 days, 8 of the 23 deals that closed-won had a trigger event that we discovered *after* the buyer already responded. We won despite the lag, not because of timing.
- **Data point 3**: Manual rep audit of the 200-list found 11 CHRO hires we'd missed entirely in the last quarter. Three of those went to competitors.

## Why this is the #1 bottleneck

| Dimension | Score | Reasoning |
|---|---|---|
| **Impact** | 9 | Direct line to pipeline. Every missed trigger = potential lost deal. 200 accounts × ~3 triggers/yr = 600 missed shots minimum. |
| **Buildability** | 7 | Trigger ingestion exists for ~30 accounts. Extending coverage is a Clay enrichment job + cron + SQL row write. Maybe 2 weeks of build. The 7 (not 9) reflects that source quality varies — The Org isn't as clean as LinkedIn. |
| **Trust** | 8 | Reps actively want this. They're the ones flagging the gaps. Adoption risk is low because they already use the trigger queue when it exists. |

## What "shipping the fix" looks like

A Trigger.dev job that runs daily for all 200 accounts:
1. Pulls LinkedIn + The Org + TheirStack via Clay
2. Diffs against `signal_events` table
3. Writes new rows for CHRO hires, headcount deltas ≥10%, job-board surges, funding rounds
4. Notifies the assigned rep via Slack when a Tier-1 trigger fires

Eval gate: trigger latency drops from 37 days median → 5 days median within 30 days of ship.

## What this is NOT

- Not a "build a CRM" project. The triggers write to the SQL lake, the lake writes to `v_priority_queue.sql`, the queue routes to reps. The CRM is already HubSpot.
- Not a re-do of the existing trigger workflow. The existing one for ~30 accounts works fine; this extends it to 170 more.
- Not an ML problem. The triggers are deterministic rules (CHRO hired → fire). ICP scoring is a separate downstream concern.

## What we'll know after we ship

- Whether expanded coverage actually changes win rate or just creates noise
- Whether 200 is the right number or whether 100 high-precision is better
- Whether the 5-day SLA is achievable or if the sources are too laggy

## Demoting criteria

- Trigger-to-discovery lag drops below 7 days median for 30 consecutive days → demote
- OR the next bottleneck scores higher in monthly re-rank → demote

## Linked
- [`../accounts/example-acme/timeline.md`](../accounts/example-acme/timeline.md) — the Acme case that motivated this
- [`../sql/v_priority_queue.sql`](../sql/v_priority_queue.sql) — what consumes the trigger rows
- [`../services/signal-workflow/spec.md`](../services/signal-workflow/spec.md) — the build spec (in flight)
