# `mento-gtm/` — Recommended File Structure

> The file system that makes the 7-step OS real. One repo per client; this is what it looks like for Mento.

## The shape

```
mento-gtm/
│
├── README.md                          # what this repo is, how to navigate
├── CLAUDE.md                          # how Claude Code should behave in this repo
│                                       (taxonomy, conventions, three-lane rule,
│                                        ICP language, "always check synthesis first")
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
├── data/                              # THE LAKE  (raw, Claude reads this directly)
│   ├── hubspot/                       # daily snapshots (CSV) or Airbyte mirror
│   │   ├── contacts/
│   │   ├── accounts/
│   │   ├── deals/
│   │   └── activities/
│   ├── avoma/                         # transcripts + summaries
│   │   ├── transcripts/
│   │   └── summaries/
│   ├── slack/                         # deal-channel threads
│   ├── apollo/                        # enrichment pulls
│   ├── signals/                       # funding, job postings, headcount deltas
│   │   ├── crunchbase/
│   │   ├── theirstack/
│   │   ├── sumble/
│   │   └── the-org/
│   └── 200-list.csv                   # the working target-account list
│
├── accounts/                          # ONE FOLDER PER TOP ACCOUNT  (auto-assembled)
│   └── <account-slug>/                # e.g. accounts/canva/
│       ├── deal.md                    # cross-cut of HubSpot + Avoma + Slack
│       ├── timeline.md                # 90-day signal trail
│       └── notes.md                   # rep/founder freeform notes
│
├── knowledge-base/                    # WHAT WE'VE LEARNED  (atomic, reusable)
│   ├── business/                      # market insights, segments, ICP findings
│   ├── methodology/                   # processes, frameworks, decisions
│   └── emergent/                      # new unvalidated concepts
│
├── bottlenecks/                       # CAPTURED IN STEP 4
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
│   ├── dedupe.sql                     # match-key tiering + merge precedence
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
│   │   ├── ingest-avoma-transcript/
│   │   ├── score-account/
│   │   └── draft-cold-email/
│   ├── commands/                      # slash-commands the team uses
│   │   ├── 200-list-check.md
│   │   ├── weekly-bottleneck-review.md
│   │   └── win-audit.md
│   ├── agents/                        # specialized workers (research, dev, ops)
│   └── settings.json                  # permissions, hooks
│
└── ingest/                            # RAW INPUTS  (before they're processed)
    └── raw/                           # drop-zone: PDFs, transcripts, decks, screenshots
```

## How it maps to the 7-step OS

| OS Step | Folders that live inside it |
|---|---|
| **1. Repo per client** | The whole tree exists — empty but shaped |
| **2. Data + playbooks into the repo** | `data/`, `foundation/`, `sql/`, optional Airbyte → `data/` daily |
| **3. Stakeholders into Claude Code** | `.claude/`, plus stakeholders running prompts that *read* every other folder |
| **4. Capture + prioritize bottlenecks** | `bottlenecks/` fills up |
| **5. Agentic dev to ship solutions** | `services/<workflow>/` — the top-ranked bottleneck graduates from `bottlenecks/` to `services/` |
| **6. Roll out to the team** | `.claude/commands/` — rep-facing slash-commands that hide complexity behind muscle memory |
| **7. Measure → pipeline + revenue** | `sql/outcomes_attribution.sql` + monthly re-fit PRs to `sql/icp_v*.sql` and `services/*/eval/` |

## How it mirrors the CIA client pattern

The CIA structures `clients/<client>/` with `foundation/`, `knowledge-base/`, `ideas/`, `research/`, `services/`, `ingest/`. **`mento-gtm/` is the same pattern, applied to one org instead of one row in a multi-client setup.** The differences are GTM-shaped, not structural:

| CIA `clients/<client>/` | `mento-gtm/` | Why the difference |
|---|---|---|
| `foundation/` | `foundation/` | Same — who they are |
| `knowledge-base/` | `knowledge-base/` | Same — what we've learned |
| `ideas/` | `ideas/` | Same — captures |
| `research/` | `research/` | Same — deep dives |
| `services/` | `services/` | Same — shipped builds |
| `ingest/context/raw/` | `ingest/raw/` | Same — drop-zone |
| *(implicit in services)* | `data/` | GTM repos need the lake explicit — it's the substrate everything reads from |
| *(implicit)* | `accounts/` | One folder per top account is GTM-specific — the unit of work is the account |
| *(implicit)* | `bottlenecks/` | GTM-engineering builds against ranked bottlenecks, not a fuzzy backlog |
| *(implicit)* | `sql/` | Playbooks-as-code is the GTM-engineering signature — separate from `services/` because the lake is read by everything, not just one service |

**The principle:** structure the repo so a stakeholder asking *"why did we close [account]?"* can be answered by Claude reading 4–6 files: `accounts/<slug>/deal.md`, `accounts/<slug>/timeline.md`, the relevant Avoma transcripts in `data/avoma/`, the playbook section that's currently live in `foundation/playbooks/`, and whatever's in `sql/v_priority_queue.sql` that explains the score.

## What goes in `CLAUDE.md` (the constitution)

The repo-level `CLAUDE.md` is what makes Claude Code behave consistently across stakeholders. It encodes:

- **Three-lane rule** — Enrichment / SQL / AI never overlap
- **Append by default** — search for existing nodes before creating new ones
- **Synthesis-first** — always read `foundation/_synthesis.md` and `bottlenecks/_synthesis.md` before answering
- **Evidence attribution** — `[VERIFIED: source:location]` / `[INFERRED]` / `[UNVERIFIABLE]`
- **ICP language** — what Mento calls "ICP," "trigger," "lifecycle stage" (so Claude doesn't drift)
- **Lane labels** — when surfacing a number, always label which lane produced it (`SQL` / `Enrichment` / `AI`)

The CIA's [`CLAUDE.md`](../../CLAUDE.md) is the reference. The `mento-gtm/CLAUDE.md` is a slimmer, GTM-shaped version of the same idea.

## Two things this structure deliberately rules out

1. **A `notes/` folder.** Everything has a home. A `notes/` folder is where files go to die — they get written, never linked, never re-read. If it's worth keeping, it goes in `foundation/`, `knowledge-base/`, `ideas/`, or `research/`.
2. **Per-rep folders.** Reps don't own folders; they own *workflows*. Their outputs land in shared folders (`accounts/`, `bottlenecks/`) so the next person picking up the account isn't starting from zero.

## What's next

- [Step 1 — Repo per client](./step-1-repo-per-client.md) — stand up the empty tree
- [Step 2 — Data + playbooks into the repo](./step-2-data-playbooks-ingested-daily.md) — fill the lake + write the playbooks as code
- [Quickstart 1 — Installation and setup](../quickstart/1-installation-and-setup.md) — walk this live on your own machine
