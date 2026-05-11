# ideas/

> Quick captures. Sparks. Things that might be worth building or researching, kept here until they earn promotion to `bottlenecks/`, `research/`, or `services/`.

## What an idea is

A short markdown file (often <50 lines) with:
- The spark — what triggered it
- The hypothesis — what we think would happen if we built/researched it
- The cost — rough estimate to validate

Ideas are **cheap to write**. Don't agonize. Capture, then walk away. If it survives 2 weeks of cooling, look at it again.

## Idea → next state

| Outcome | Where it goes |
|---|---|
| "This is real — let's score it" | Move/rewrite as a `bottlenecks/<name>.md` |
| "This needs evidence first" | Move/rewrite as `research/<name>.md` with `runs/` |
| "This is a feature build" | Becomes `services/<service>/spec.md` |
| "This was a bad idea" | Add a one-line demotion note and leave the file |

## Example files this folder will hold

- `chro-trigger-via-podcast-mentions.md` — "What if we crawled podcasts for CHRO interviews to predict who's about to be hired?"
- `slackbot-for-intro-followups.md` — Already promoted to bottleneck #3
- `auto-generated-discovery-recap.md` — promoted to `services/`

## Front-matter

```yaml
---
title: Short idea title
type: idea
status: draft | promoted | demoted
captured: 2026-05-11
related: [[any-relevant-node]]
---
```
