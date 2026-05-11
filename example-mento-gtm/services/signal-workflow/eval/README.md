# eval/

> LLM-as-judge gates that drafts must pass before reaching a rep inbox.

## The eval bar

Three judges run on every draft. All three must pass.

| Judge | Threshold | What it checks |
|---|---|---|
| `voice-eval.md` | ≥ 0.85 | Does this read like a human Mento rep? (terse, specific, no buzzwords) |
| `factual-eval.md` | 1.0 (binary) | Does every claim trace to a row in the lake? |
| `trigger-eval.md` | ≥ 0.80 | Does the draft actually use the trigger that fired? |

## Why three judges

Each measures a different failure mode:
- A draft can sound human but invent facts (voice ✅, factual ❌)
- A draft can be factually correct but read like AI slop (factual ✅, voice ❌)
- A draft can pass both but ignore the trigger (e.g., "CHRO was hired" → email about wellness programs)

## What "fail" means

- A failed draft goes back to the AI lane with the failing judge's feedback
- It retries up to 2x
- If it still fails, it's logged to `eval_failures` and a rep sees it tagged as "needs manual write"
- Rep can then either write from scratch or click "regenerate" with overridden constraints

## Why HITL even after passing

Eval gates don't replace humans — they reduce rep workload to the *good* drafts. Reps still click send on every email for the first 30 days post-ship. After 30 days + clean attribution data, we'll re-evaluate auto-send for the highest-confidence (eval > 0.95) drafts.

## Eval drift detection

Weekly cron runs the same 50 historical drafts against the current eval. If average score drifts > 0.05 from last week, an alert fires. This catches:
- Prompt edits that silently degrade quality
- Voice rules that became outdated
- The judge model itself drifting (e.g., GPT-5 vs GPT-5.1 scoring differently)
