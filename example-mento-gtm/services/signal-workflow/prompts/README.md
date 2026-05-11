# prompts/

> Versioned LLM prompts. Each prompt is a markdown file. Changes go through PR review.

## Why prompts are files, not strings in code

1. **Diffable.** A prompt edit shows up in a PR as a clean text diff. A prompt-as-string-in-code edit is mixed in with other changes.
2. **Reviewable by non-engineers.** Reps can comment on prompt PRs and propose changes without writing TypeScript.
3. **Versioned.** Each prompt has a header noting which version produced which eval scores. Rolling back is `git checkout`.

## Files

| File | Purpose |
|---|---|
| `outbound-draft.md` | The main prompt — generates the first-touch email |
| `voice-rules.md` | Inline voice rules referenced from `outbound-draft.md` |
| `context-loader.md` | Instructions for what context to pull (which account fields, which playbook sections) |

## Anatomy of a prompt file

```yaml
---
title: Outbound draft prompt
version: v0.4
eval_score_baseline: 0.87 (voice-eval, 30-account pilot)
last_changed: 2026-05-10
changelog:
  - v0.4: tightened opening sentence per rep feedback
  - v0.3: added trigger-specific framing
---

# System
[role description]

# Context
[what gets loaded — account, trigger, playbook section]

# Task
[what to generate, format]

# Constraints
[hard rules, voice rules link]
```

## Versioning rule

Bump version on any change that could affect eval score. Don't bump version for typo fixes inside comments.
