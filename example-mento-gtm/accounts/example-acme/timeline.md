---
title: Acme Corp — 90-Day Signal Timeline
type: account-timeline
account_slug: example-acme
updated: 2026-05-11
---

# Acme Corp — 90-Day Signal Timeline

> Every public-data event tied to Acme in the last 90 days, plus every internal touch.

## The chronological view

| Date | Event | Lane | Source | Implication |
|---|---|---|---|---|
| 2026-02-14 | Headcount delta +18 → 412 total | Enrichment | LinkedIn weekly snapshot | Crossed the 150-cutoff threshold ages ago, but compounding |
| 2026-02-28 | New VP Eng hired | Enrichment | The Org | Not a Mento trigger, noted for context |
| 2026-03-15 | **CHRO hired (Sarah K.)** | Enrichment | The Org + LinkedIn | **Primary Mento trigger** |
| 2026-04-01 | Job board surge: 6 new senior IC postings | Enrichment | TheirStack | Secondary signal — comp-band drift forming |
| 2026-04-22 | Trigger row written to `signal_events` | SQL | `signal_events` table | Trigger officially recognized by the system |
| 2026-04-23 | Acme moved to Tier 1 in priority queue | SQL | `v_priority_queue.sql` re-run | Auto-routed to outbound queue |
| 2026-05-08 | Cold outbound email sent (eval-passed draft) | AI + SQL | `services/signal-workflow/` | Email score 0.91 |
| 2026-05-09 | Sarah replied — demo booked | SQL | `hubspot.activities` | Reply within 18 hours, fast cycle |
| 2026-05-10 | Discovery prep brief generated | AI | Claude Code in `transcripts/` | Pre-call brief ready for Alex |
| 2026-05-14 | Demo (upcoming) | — | — | — |

## What's notable

- **The lag between trigger event and trigger discovery was 37 days.** CHRO was hired 2026-03-15; the `signal_events` row didn't write until 2026-04-22. Bottleneck → captured as [`../../bottlenecks/no-trigger-coverage-on-200-list.md`](../../bottlenecks/no-trigger-coverage-on-200-list.md).
- **The cycle from trigger row → reply was 17 days.** That's fast for Mento and likely a function of the CHRO trigger's salience.
- **Three signals fired in sequence** (headcount → CHRO hire → job-board surge). The compound signal is what makes Acme a Tier-1, not any single event.

## What this timeline is for

When a rep opens this folder, this is the second file they read after `deal.md`. The headline is in `deal.md`; the story is here.

When Claude is asked *"why did we close Acme?"* (after the deal closes), it reads this timeline forward and finds the load-bearing trigger. That belief gets folded into `foundation/_synthesis.md` if the pattern repeats.
