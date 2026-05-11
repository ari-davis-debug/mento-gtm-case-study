# `mento-gtm/` — Recommended File Structure

> The file system that makes the 7-step OS real. One repo, scoped to Mento, where every stakeholder lives.

## The shape

```
mento-gtm/
│
├── README.md                          # what this repo is, how to navigate
├── CLAUDE.md                          # how Claude Code should behave in this repo
│                                       (taxonomy, three-lane rule, ICP language,
│                                        "always check synthesis first")
│
├── foundation/                        # WHO MENTO IS  (stable, identity)
│   ├── _synthesis.md                  # rolling: "what we currently believe wins deals"
│   ├── icp.md                         # written-down ICP — V0 today, V1 after win-audit
│   ├── positioning.md                 # how Mento talks about itself + competitive map
│   ├── playbooks/                     # rewritten live from Avoma evidence
│   │   ├── discovery.md
│   │   ├── demo.md
│   │   ├── outbound.md
│   │   └── objection-handling.md
│   └── context/                       # founder + advisor context, board deck cuts
│       ├── alex.md
│       ├── co-founder.md
│       └── board-decks/
│
├── accounts/                          # ONE FOLDER PER TOP ACCOUNT  (the GTM unit of work)
│   └── <account-slug>/                # e.g. accounts/canva/
│       ├── deal.md                    # cross-cut of HubSpot + Avoma + Slack
│       ├── timeline.md                # 90-day signal trail
│       ├── transcripts/               # Avoma cuts that matter for this account
│       ├── signals/                   # funding, hires, headcount deltas — tied to this account
│       └── notes.md                   # rep / founder freeform
│
├── knowledge-base/                    # WHAT WE'VE LEARNED  (atomic, reusable)
│   ├── business/                      # market insights, segments, ICP findings
│   ├── methodology/                   # processes, frameworks, decisions
│   └── emergent/                      # new unvalidated concepts
│
├── bottlenecks/                       # CAPTURED IN STEP 4  (ranked queue, one file each)
│   ├── _synthesis.md                  # ranked top-N + rationale
│   ├── no-trigger-coverage-on-200-list.md
│   ├── playbook-drift-between-reps.md
│   └── intros-dying-in-slack-threads.md
│
├── ideas/                             # REP / FOUNDER WHAT-IFS  (raw captures)
│   └── <idea-slug>.md
│
├── research/                          # DEEP DIVES WITH RUNS  (win audits, segment research)
│   └── <topic-slug>.md
│
├── sql/                               # PLAYBOOKS AS CODE  (versioned, reviewable)
│   ├── dedupe.sql
│   ├── icp_v0.sql                     # scoring function — V0 today
│   ├── icp_v1_refit.sql               # after monthly logistic regression
│   ├── v_priority_queue.sql           # trigger + ICP → priority score
│   ├── lifecycle_transitions.sql      # state machine with no-downgrade
│   └── outcomes_attribution.sql       # closed-loop pipeline+revenue tie-back
│
├── services/                          # SHIPPED AUTOMATIONS  (the build layer)
│   └── signal-workflow/               # the Part 3 build, when it earns the right
│       ├── spec.md
│       ├── triggers/                  # Trigger.dev jobs
│       ├── prompts/                   # AI-lane prompts (draft, eval, summary)
│       ├── eval/                      # eval suite + thresholds
│       └── webhooks/                  # SmartLead, HubSpot, Slack
│
├── .claude/                           # CLAUDE CODE CONFIG  (skills, commands, agents)
│   ├── skills/                        # SOPs (per-task how-tos)
│   ├── commands/                      # slash-commands the team uses
│   │   ├── 200-list-check.md
│   │   ├── weekly-bottleneck-review.md
│   │   └── win-audit.md
│   ├── agents/                        # specialized workers
│   └── settings.json                  # permissions, hooks
│
└── ingest/                            # MANUAL DROP-ZONE  (PDFs, decks, screenshots)
    └── raw/                           # before things are processed into accounts/ or foundation/
```

## Where the actual raw data lives (not in the repo)

**The repo holds derived artifacts, not the lake itself.** Live customer data — HubSpot rows, full Avoma transcript dumps, Slack history — doesn't get committed to git. PII + size + churn make that a bad fit.

The lake lives one of two places, depending on whether OS Step 2b (the daily data lake) is stood up:

| Setup | Where the lake lives | How Claude reads it |
|---|---|---|
| **Minimum** (Claude Code + GitHub only) | One-off CSV exports dropped in `ingest/raw/`, processed manually into `accounts/<slug>/` | Claude reads the curated derived files in `accounts/`, `foundation/`, etc. |
| **+ Step 2b** (Airbyte → Supabase / BigQuery / Postgres) | External database — never in the repo | Claude reads via SQL queries that live in `sql/`. Outputs flow back into `accounts/<slug>/` as derived markdown |

**Why no top-level `data/` folder:** in practice nobody on the team browses raw HubSpot tables. They open `accounts/canva/deal.md` and that file already has the relevant cuts woven in. The lake is plumbing; the curated account folder is what gets read.

## How it maps to the 7-step OS

| OS Step | Folders that live inside it |
|---|---|
| **1. Stand up the repo** | The whole tree exists — empty but shaped |
| **2. Data + playbooks into the repo** | `foundation/`, `sql/`, `accounts/` curated files. Optional 2b: Airbyte → external lake |
| **3. Stakeholders into Claude Code** | `.claude/`, plus stakeholders running prompts that *read* every other folder |
| **4. Capture + prioritize bottlenecks** | `bottlenecks/` fills up |
| **5. Agentic dev to ship solutions** | `services/<workflow>/` — the top-ranked bottleneck graduates from `bottlenecks/` to `services/` |
| **6. Roll out to the team** | `.claude/commands/` — rep-facing slash-commands that hide complexity behind muscle memory |
| **7. Measure → pipeline + revenue** | `sql/outcomes_attribution.sql` + monthly re-fit PRs to `sql/icp_v*.sql` and `services/*/eval/` |

## How it mirrors the CIA client pattern

The CIA structures `clients/<client>/` with `foundation/`, `knowledge-base/`, `ideas/`, `research/`, `services/`, `ingest/`. **`mento-gtm/` is the same pattern, applied to one org.** Two GTM-shaped additions:

| CIA `clients/<client>/` | `mento-gtm/` | Why the difference |
|---|---|---|
| `foundation/` | `foundation/` | Same |
| `knowledge-base/` | `knowledge-base/` | Same |
| `ideas/` | `ideas/` | Same |
| `research/` | `research/` | Same |
| `services/` | `services/` | Same |
| `ingest/context/raw/` | `ingest/raw/` | Same — drop-zone |
| *(implicit)* | `accounts/` | One folder per top account — GTM unit of work |
| *(implicit)* | `bottlenecks/` | GTM-engineering builds against a ranked queue, not a fuzzy backlog |
| *(implicit)* | `sql/` | Playbooks-as-code is the GTM-engineering signature |

The principle: structure the repo so a stakeholder asking *"why did we close [account]?"* gets answered by Claude reading 4–6 files inside `accounts/<slug>/` + `foundation/playbooks/` + `sql/v_priority_queue.sql`. No raw-lake archaeology required.

## What goes in `CLAUDE.md`

The repo-level `CLAUDE.md` is what makes Claude Code behave consistently across stakeholders:

- **Three-lane rule** — Enrichment / SQL / AI never overlap
- **Append by default** — search for existing nodes before creating new ones
- **Synthesis-first** — always read `foundation/_synthesis.md` and `bottlenecks/_synthesis.md` before answering
- **Evidence attribution** — `[VERIFIED: source:location]` / `[INFERRED]` / `[UNVERIFIABLE]`
- **ICP language** — what Mento calls "ICP," "trigger," "lifecycle stage" (so Claude doesn't drift)
- **Lane labels** — when surfacing a number, always label which lane produced it

The CIA's [`CLAUDE.md`](../../CLAUDE.md) is the reference. `mento-gtm/CLAUDE.md` is a slimmer, GTM-shaped version.

## Two things this structure deliberately rules out

1. **A top-level `data/` folder.** Raw exports don't belong in git. The lake lives in Supabase/BigQuery (if 2b is stood up) or in `ingest/raw/` as one-off drops. Curated cuts live in `accounts/<slug>/` where they're actually read.
2. **Per-rep folders.** Reps don't own folders; they own *workflows*. Outputs land in shared folders (`accounts/`, `bottlenecks/`) so the next person picking up the account isn't starting from zero.

## What's next

- [Step 1 — Stand up the repo](./step-1-stand-up-the-repo.md) — the empty tree, day one
- [Step 2 — Data + playbooks into the repo](./step-2-data-playbooks-ingested-daily.md) — fill `foundation/` + `sql/`, stand up the optional lake
- [Quickstart 1 — Installation and setup](../quickstart/1-installation-and-setup.md) — walk this live on your own machine
