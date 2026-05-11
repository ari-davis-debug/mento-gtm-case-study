---
title: Playbook drift between reps
type: bottleneck
status: next
score: 392
impact: 7
buildability: 8
trust: 7
updated: 2026-05-11
---

# Bottleneck — Playbook drift between reps

> **The pain:** Alex and the other rep run discovery and demo differently enough that win rates differ by 14 points. The deltas aren't because one rep is "better" — they're because the playbook lives in heads, not in files, so the better rep's moves don't transfer.

## How we know this is real

- **Data point 1**: Rolling 90-day win rate by rep — Rep A: 38%, Rep B: 24%. The difference traces to discovery question quality (Rep A asks the comp-band-refresh question; Rep B doesn't).
- **Data point 2**: In 12 of 15 lost deals reviewed, the lost-reason note said "didn't surface the compelling event clearly." Both reps had the data; only one used it consistently.
- **Data point 3**: Avoma transcript audit shows Rep A asks an average of 4.2 disco questions per call; Rep B asks 2.8. Same call length.

## Why this is bottleneck #2 (not #1)

| Dimension | Score | Reasoning |
|---|---|---|
| **Impact** | 7 | 14-point win-rate delta is huge. But with 2 reps, fixing this is high-leverage but low-volume. Compare to bottleneck #1 which affects all 200 accounts. |
| **Buildability** | 8 | The playbook already exists in [`../foundation/playbooks/`](../foundation/playbooks/). The fix is enforcement, not creation. Auto-load the discovery playbook into Claude pre-call briefs. Audit Avoma transcripts against it. |
| **Trust** | 7 | Reps will push back if it feels like surveillance. Has to be framed as "make Rep B as good as Rep A," not "monitor compliance." The 7 reflects soft adoption risk. |

## What "shipping the fix" looks like

Two-part build:
1. **Pre-call brief auto-injects the playbook checklist.** Claude pulls `foundation/playbooks/discovery.md` into every prep brief. Rep sees the 4 must-ask questions before they dial.
2. **Post-call eval.** A skill reads the Avoma transcript and scores whether the 4 questions were asked. Score goes to a private dashboard the rep sees — *not* a leaderboard.

Eval gate: discovery-question-coverage rises from 60% baseline to 85% within 30 days.

## Why this isn't #1

Bottleneck #1 (trigger coverage) sources *pipeline*. This bottleneck affects *conversion of existing pipeline*. With a 2-rep team and a short ramp, fixing pipeline supply first is correct sequencing — there's no point converting better if there's nothing to convert.

If the team grows to 5 reps, this almost certainly becomes #1.

## What we'll know after we ship

- Whether playbook drift is a knowledge problem or a habit problem
- Whether transcript audit creates resentment or relief
- Whether the question list itself needs revising (maybe Rep B is dropping certain questions because they don't land)

## Linked
- [`../foundation/playbooks/discovery.md`](../foundation/playbooks/discovery.md) — the playbook this enforces
- [`../accounts/example-acme/transcripts/README.md`](../accounts/example-acme/transcripts/README.md) — where Avoma cuts get curated
