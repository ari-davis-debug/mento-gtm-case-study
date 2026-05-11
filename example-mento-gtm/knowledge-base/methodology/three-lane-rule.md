---
title: The three-lane rule
type: node
node_type: framework
domain: methodology
status: canonical
topics: [mento, methodology, architecture]
related:
  - [[implements:foundation/_synthesis.md]]
  - [[supports:services/signal-workflow/spec.md]]
updated: 2026-05-11
---

# The three-lane rule

> Enrichment, SQL, and AI run as three separate lanes. They hand off; they never overlap. When a system breaks, you debug exactly one lane.

## The lanes

| Lane | Owns | Hands off to |
|---|---|---|
| **Enrichment** | Public data → structured rows (Clay, LinkedIn, The Org) | SQL |
| **SQL** | Canonical state, derived state, prioritization, attribution | AI (queue rows) + reps (queue UI) |
| **AI** | Drafting outbound, summarizing transcripts, briefing reps | Reps (humans send) |

## Why this works

1. **One lane = one debugger.** When a deal misroutes, you check SQL only. When a trigger doesn't fire, you check enrichment only. When an email reads off-brand, you check AI only.
2. **No silent ML in SQL.** ICP scoring is logistic regression with visible weights, not a black-box model embedded in a view.
3. **No SQL in AI prompts.** The AI lane reads pre-computed rows; it doesn't run queries during generation. (Reduces hallucination + latency.)
4. **No AI in enrichment.** Enrichment is deterministic crawls. AI never "decides" if a hire counts as a CHRO — that's a Clay rule.

## Anti-patterns

- **AI doing dedupe** → wrong. SQL does dedupe.
- **SQL running an LLM call inside a view** → wrong. AI draft happens after the queue is built.
- **Enrichment "smart fields" that use AI to classify** → wrong. If a classification needs AI, the row comes in raw and AI runs as a separate downstream step.

## Worked example — Acme

```
Enrichment lane:
  LinkedIn weekly snapshot fires
  Clay job detects CHRO hire (rule: title contains "Chief People" or "CHRO")
  Writes row to supabase.linkedin_role_changes

SQL lane:
  Trigger on linkedin_role_changes writes to signal_events
  v_priority_queue.sql joins signal_events to accounts, scores, sorts
  Queue row emitted with account_id, trigger_type, score

AI lane:
  Trigger.dev job picks up queue row
  Reads foundation/playbooks/outbound.md, foundation/icp.md, account context
  Drafts email
  LLM-as-judge evals against voice rules
  If score ≥ 0.85 → ship to rep inbox for HITL approval
  Rep clicks send
```

Three handoffs. Three debug surfaces. No overlap.

## When this rule bends

Only in two cases:
1. **Enrichment that requires NER on unstructured text** (e.g., parsing a job description for seniority). The enrichment lane *may* call an LLM for the extraction, but the output is a deterministic field, not a generated paragraph.
2. **AI that needs a quick SQL lookup mid-generation** (e.g., "what was this rep's last call with this account?"). Allow a read-only query, but never a write.

Both exceptions require a comment in the code that says *why* the lane rule bent.

## Linked
- [[services/signal-workflow/spec.md]] — the canonical three-lane implementation
- [[foundation/_synthesis.md]] — three-lane rule is in the founding beliefs
