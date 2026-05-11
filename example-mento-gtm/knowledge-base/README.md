# knowledge-base/

> Atomic concept nodes. Reusable across accounts, bottlenecks, ideas, research.

## What a node is

One concept, one file. Front-matter, wiki-links, evidence attribution. Append-by-default.

A node is not:
- A meeting note (those go to `accounts/<slug>/transcripts/`)
- A deal-specific belief (that goes to `accounts/<slug>/deal.md`)
- A rolling synthesis (that goes to `foundation/_synthesis.md`)

A node IS:
- A reusable concept (e.g., "what a CHRO actually controls")
- A pattern observed across 3+ deals
- A framework (e.g., the 6-dimension ICP weight calc)

## Domains

```
knowledge-base/
├── business/     # market concepts, deal patterns, buyer behavior
├── methodology/  # how we work — playbooks-as-files, eval gates
└── emergent/     # unvalidated patterns that may graduate to business/ or methodology/
```

## Lifecycle

`emergent` → `validated` → `canonical` (or `deprecated`)

A node graduates when:
- **emergent → validated**: 3+ deals or events back the claim
- **validated → canonical**: pattern survives a re-rank cycle and is referenced from a synthesis
- **canonical → deprecated**: pattern stops predicting; explicit demotion note added

## Linking

Every node has 2+ wiki-links. Typed edges preferred:

```markdown
related:
  - [[implements:foundation/playbooks/outbound.md]]
  - [[contradicts:emergent/comp-band-refresh-not-a-trigger.md]]
```

## What goes where

| Question | Answer |
|---|---|
| "Why do CHRO hires correlate with Mento wins?" | `business/chro-hire-as-compelling-event.md` |
| "How do we score ICP fit?" | `methodology/icp-scoring.md` (references `foundation/icp.md`) |
| "Does board-comp-review predict pipeline?" | `emergent/board-comp-review-as-trigger.md` (unvalidated) |
