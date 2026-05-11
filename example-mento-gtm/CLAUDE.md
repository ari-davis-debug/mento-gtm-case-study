# CLAUDE.md — How Claude Code behaves in this repo

> The constitution. Every Claude Code session in `mento-gtm/` reads this first.

## Always-on rules

### 1. Synthesis-first
Before answering any substantive question, read:
- `foundation/_synthesis.md` — what we currently believe wins deals
- `bottlenecks/_synthesis.md` — what's currently broken, ranked

If the answer to the question is already in these files, surface it. Don't re-derive.

### 2. Three-lane rule (never overlap)
Every number, draft, or claim you surface must label which lane produced it:
- **Enrichment** — pulled from outside (BlitzAPI, Crunchbase, Sumble, The Org, Firecrawl, Apollo)
- **SQL** — read tables in the lake → math → wrote tables (dedupe, ICP scoring, trigger scoring, lifecycle, attribution)
- **AI** — interpreted unstructured content (draft generation, eval gate, score-explanation paragraphs, edge-case escalation)

If a rep asks *"why is this account #1 in my queue today?"* they should get an answer that names the lane behind each component.

### 3. Append before you create
Search for an existing node before creating a new one. The default is **append to a fat node**, not fragment into thin ones. New files only when the *concept type* is genuinely different (concept / framework / data-source / person).

### 4. Evidence attribution
Every claim that isn't trivial gets a tag:
- `[VERIFIED: source:location]` — direct evidence (e.g., `[VERIFIED: avoma:canva-discovery-call-2026-03-12-min-14]`)
- `[INFERRED: logic from sources]` — deduced from multiple inputs
- `[UNVERIFIABLE]` — can't confirm; flag for research

### 5. ICP language (don't drift)
What Mento calls things:
- **ICP** — Mento's V0 archetype is *Series-B-to-Series-D B2B SaaS with a recent CHRO or VP-People hire and ≥150 headcount*
- **Trigger** — a public-data event that fires the priority queue (funding, exec hire, headcount delta ≥10%, job-board surge for a target role)
- **Lifecycle stage** — canonical B2B funnel (MQL → SAL → SQL → Opp → Closed). No downgrades.
- **The 200-list** — Alex's curated target-account list. Always re-scored against the latest signals.

Don't substitute synonyms. Don't say "Series B+ SaaS" when the synthesis says "Series-B-to-Series-D B2B SaaS."

## Per-folder behavior

| Folder | What Claude does there |
|---|---|
| `foundation/` | Read-mostly. Edits get reviewed via PR. The synthesis is the rolling belief, edit with care. |
| `accounts/<slug>/` | Auto-assemble cross-cuts. Write to `deal.md` and `timeline.md` only after running the relevant SQL view. |
| `bottlenecks/` | One file per bottleneck. Use the YAML schema. Score with impact × buildability × stakeholder-trust. |
| `ideas/` | Low-friction captures. Don't grade or filter at write-time. |
| `research/` | Append Runs to existing files when topic + client + recency align (< 8h). Otherwise new file. |
| `sql/` | Versioned playbooks. Every change is a PR. Never write here without explaining the diff in the commit. |
| `services/` | One folder per shipped workflow. Spec → research → tests → ship. Never skip the spec. |

## Slash commands available to reps

| Command | What it does |
|---|---|
| `/200-list-check` | Run the priority queue against the 200-list, surface top-10 with score breakdown |
| `/weekly-bottleneck-review` | Surface bottlenecks ranked impact × buildability × trust |
| `/win-audit` | Cross-reference 8–10 won deals against publicly-true signals 6–18 months pre-close |

Reps don't open Claude Code in the early weeks — they get the *output*. Stakeholders (Alex + advisors) open Claude Code and use commands directly.

## What never happens

- **Never** auto-merge a SQL or playbook change. Always PR.
- **Never** generate a cold-email draft that hasn't passed the eval gate (≥ 0.85 voice match).
- **Never** label a deal "won" without a corresponding row in `outcomes` table.
- **Never** create a new lifecycle stage outside the canonical funnel.
