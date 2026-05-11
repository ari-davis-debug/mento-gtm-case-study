# Step 1 — Repo per Client

> Foundation · Day 1

## What this step is

Stand up `mento-gtm/` as the **single source-of-truth repo** for everything GTM. Versioned, queryable, multi-stakeholder. The place where Mento's accumulated win-evidence finally lives in a way that compounds.

## Why it's the first step

Two years of warm intros, exec dinners, and Avoma calls means Mento *has* the win-evidence — it just lives inside the founders' heads and across scattered tools. Until there's a repo, every "why did we close [logo]?" question gets a fresh round of memory-walking from the founders. The repo is the place that question gets answered from data instead.

## What concrete work happens here

```
mento-gtm/
├── foundation/                 # who Mento is
│   ├── _synthesis.md           # rolling: "what we currently believe wins deals"
│   ├── icp.md                  # written-down ICP (starts empty, fills from Step 3)
│   └── playbooks/              # rewritten live in Claude Code
├── data/
│   ├── hubspot/                # daily snapshots
│   ├── avoma/                  # transcripts + summaries
│   ├── slack/                  # deal-channel threads
│   ├── apollo/                 # enrichment pulls
│   └── signals/                # funding, job postings, headcount deltas
├── accounts/<account-slug>/    # one folder per top account, auto-assembled
│   ├── deal.md                 # cross-cuts of HubSpot + Avoma + Slack
│   └── timeline.md             # 90-day signal trail
├── bottlenecks/                # captured in Step 4
├── ideas/                      # rep-flagged what-ifs
└── sql/                        # every SQL playbook lives here, versioned
```

**Delivery:** a short video walks Alex through repo navigation. He runs it once with me; runs it himself the second time.

**Output:** `mento-gtm/` repo live, with empty-but-shaped folders ready for Step 2 to fill.

## Which take-home section lives inside this step

[Part 1 §1 — *"Stand up the GTM OS — repo + full daily ingestion"*](../case-study/part1-diagnose-and-prioritize.md)

The repo tree above is the same one in Part 1. The reason the take-home leads with this and not with "build the signal workflow" is exactly the reason this step is first in the OS: **without a place for the win-evidence to live, every downstream automation is built on sand.**

## What's next

[Step 2 — Data + playbooks ingested daily](./step-2-data-playbooks-ingested-daily.md) — fills the empty folders with real Mento data via Airbyte, and codifies the rules-about-the-data as playbooks in `sql/` and `foundation/playbooks/`.
