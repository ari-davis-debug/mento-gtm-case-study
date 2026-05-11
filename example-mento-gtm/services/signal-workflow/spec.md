---
title: Signal Workflow — Spec
service: signal-workflow
status: in-development
bottleneck: no-trigger-coverage-on-200-list
owner: alex
started: 2026-05-01
target_ship: 2026-05-22
updated: 2026-05-11
---

# Signal Workflow

> Extends trigger detection to all 200 priority accounts and ships eval-passed outbound drafts to reps within 24 hours of trigger discovery.

## The problem

[`../../bottlenecks/no-trigger-coverage-on-200-list.md`](../../bottlenecks/no-trigger-coverage-on-200-list.md) — median trigger-to-discovery latency is 37 days. Target: ≤ 5 days.

## What success looks like

| Metric | Baseline | Target | Hard fail |
|---|---|---|---|
| Trigger-to-discovery latency (median) | 37 days | ≤ 5 days | > 10 days |
| Coverage of 200-list | ~30 accounts | 200 accounts | < 180 |
| Eval-pass rate on drafts | n/a | ≥ 70% first-pass | < 50% |
| Rep send rate (drafts that ship without edit) | n/a | ≥ 40% | < 20% |
| False-positive triggers (per week) | unknown | ≤ 3 | > 10 |

## Architecture (three lanes)

```
ENRICHMENT LANE                 SQL LANE                 AI LANE
────────────────                ────────                 ──────
Clay daily crawl    →     signal_events table      →   Trigger.dev task
LinkedIn + The Org   (with dedupe.sql constraint)      reads v_priority_queue
TheirStack                       ↓                            ↓
        ↓                v_priority_queue.sql          loads playbooks
   webhook write                  ↓                    drafts email
        ↓               emit ready_for_ai_draft        ↓
   POST /webhook              row to AI lane          eval-gate (≥ 0.85)
                                                      ↓
                                                ship to rep inbox (HITL)
                                                      ↓
                                                rep clicks send
                                                      ↓
                                          POST back to mark actioned_at
```

## Concrete components

### `triggers/`
- `trigger-watcher.ts` — Trigger.dev task, runs hourly, polls `v_priority_queue` for `ready_for_ai_draft = true`
- `draft-generator.ts` — pulls account context, loads playbook, calls LLM, runs eval, writes to rep inbox

### `prompts/`
- `outbound-draft.md` — versioned prompt for the draft. References `foundation/playbooks/outbound.md`
- `voice-rules.md` — what Mento's outbound voice sounds like (terse, specific, no buzzwords)

### `eval/`
- `voice-eval.md` — LLM-as-judge: does this draft sound like a human Mento rep?
- `factual-eval.md` — does every claim in the draft trace to a row in the lake?
- `trigger-eval.md` — does the draft actually use the trigger that fired?

### `webhooks/`
- `POST /webhooks/clay` — receives enrichment events, writes to `signal_events` with dedupe
- `POST /webhooks/hubspot` — receives reply events, marks `actioned_at` and pauses queue for that account
- `POST /webhooks/slack` — receives `/skip-acme` style commands from reps

## What's explicitly NOT in v1

- Multi-touch sequencing (just first touch)
- LinkedIn message variant (just email)
- CFO follow-up sequence (decided post-data — see `research/do-CHROs-actually-pick-comp-tools.md`)
- Auto-send (HITL is non-negotiable for the first 30 days)

## Eval gate before ship

Before this service goes live for all 200 accounts, it must pass:
1. **30-account pilot** with the existing covered list — measure eval-pass rate
2. **Backtest** on 50 historical triggers — would the drafts have shipped or not?
3. **Rep sign-off** — both reps review 10 drafts and confirm the voice is right

If pilot eval-pass rate < 70%, the prompt + voice rules get iterated before broader rollout.

## Linked
- [[../../knowledge-base/methodology/three-lane-rule.md]] — the architectural pattern
- [[../../foundation/playbooks/outbound.md]] — the playbook the draft prompt references
- [[../../sql/v_priority_queue.sql]] — the SQL handoff into this service
- [[../../accounts/example-acme/deal.md]] — the original motivating case
