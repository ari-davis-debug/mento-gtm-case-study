---
title: Bottlenecks — Ranked Top-N
type: synthesis
domain: bottlenecks
status: validated
updated: 2026-05-11
---

# Bottlenecks — Ranked Top-N

> The current top bottlenecks Mento has, ranked. Re-scored monthly. The top item is what gets built in Step 5.

## Ranking

Score = **impact × buildability × stakeholder-trust** (each 1–10).

| # | Bottleneck | Impact | Buildability | Trust | Score | Status |
|---|---|---|---|---|---|---|
| 1 | [No trigger coverage on 200-list](./no-trigger-coverage-on-200-list.md) | 9 | 7 | 8 | **504** | 🟢 Ready to build (Step 5) |
| 2 | [Playbook drift between reps](./playbook-drift-between-reps.md) | 7 | 8 | 7 | **392** | 🟡 Next |
| 3 | [Intros dying in Slack threads](./intros-dying-in-slack-threads.md) | 6 | 9 | 6 | **324** | 🟡 Next |

## What "top-1 = build" means

The #1 bottleneck is what Step 5 (agentic dev) builds first. If a re-score shifts the #1, the active build either pivots or completes-then-pivots — never two parallel builds for a 2-rep team.

## Re-scoring cadence

- **Monthly** by default
- **Triggered** when:
  - A new bottleneck file lands that scores ≥ current #1
  - The current #1 ships and moves to `services/`
  - A stakeholder flags a missing pattern in the existing files

## How scoring works

| Dimension | What it measures |
|---|---|
| **Impact** | If we fixed this, how much would pipeline or revenue move? Scored 1–10. |
| **Buildability** | How shippable is the solution with current tools + capacity? 1–10. |
| **Stakeholder-trust** | If we ship the fix, will reps actually adopt it? 1–10 — the highest failure mode for a 2-rep team. |

Tie-breakers go to **trust**, not impact. A 9/7/8 beats a 10/9/3 every time because a 3-trust solution dies on the vine.

## What this synthesis is *not*

- It's not a roadmap. Roadmap implies sequenced commitments; bottlenecks get re-ranked monthly.
- It's not a backlog. Backlogs accumulate; bottlenecks get either shipped or demoted.
- It's not opinions. Every score has to be backed by data from the lake or by a documented stakeholder conversation.

## Demoted (kept for history)

- ~~**Drift between Avoma summaries and CRM notes.**~~ → Solved when Avoma auto-sync to HubSpot turned on 2026-04. (Demoted 2026-05-01.)
