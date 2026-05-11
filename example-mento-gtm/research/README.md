# research/

> Deep dives. Things that take >2 hours, that need multiple sources, that compound back to `knowledge-base/` or `foundation/_synthesis.md`.

## Research vs ideas vs notes

| Type | Lives in | Looks like |
|---|---|---|
| **Note** | `accounts/<slug>/notes.md` | "Sarah did GSB" |
| **Idea** | `ideas/` | "What if we crawled podcasts?" |
| **Research** | `research/` | A file with `runs/`, sources cited, conclusion |

## Anatomy of a research file

```yaml
---
title: Research title
type: research
status: in-progress | final
started: 2026-05-01
related: [[relevant-nodes]]
---

# Research title

## Question
[the precise question — one sentence]

## Why it matters
[what decision this informs]

## Runs

### Run r-2026-05-01-1430
**Source**: [where I looked]
**Finding**: [what I found]
**Confidence**: [low/medium/high]

### Run r-2026-05-02-0900
[...]

## Synthesis (current)
[what I currently believe given all runs]

## Open questions
[what I still don't know]
```

## Example files this folder will hold

- `do-CHROs-actually-pick-comp-tools.md` — investigating the buying-authority claim
- `how-long-does-series-c-take-to-do-band-refresh.md` — feeds the ICP timing model
- `competitive-objections-Q1-2026.md` — every objection raised in lost deals

## Promotion from research

When a research file gets to a confident conclusion:
1. The finding gets written into a `knowledge-base/` node
2. The research file gets `status: final` and stays as the audit trail
3. The synthesis (`foundation/_synthesis.md`) gets a one-line update with a link back

The research file is the *receipts*. The node is the *belief*.
