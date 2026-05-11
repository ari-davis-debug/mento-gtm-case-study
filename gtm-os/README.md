# GTM OS — the 7-step shape, step by step

> The deeper view of the same submission. Each step shows what's in it, why it's there, and which section of the take-home it answers.

## Why this folder exists

The [`case-study/`](../case-study/) folder gives Mento direct answers to the three questions in the brief. **This folder gives them the shape those answers live inside.**

The reason both exist: Mento's evaluator can read either path and get a complete picture. If they want the answers, they go to `case-study/`. If they want to see how I think about the system end-to-end, they walk the 7 steps here.

## The 7-step shape

```
Foundation
  1. Stand up the GTM repo
  2. Data + ops models + playbooks into the repo
  3. Stakeholders into Claude Code on the repo
  4. Capture + prioritize bottlenecks

Build
  5. Agentic dev to ship solutions

Operate
  6. Roll out to the team
  7. Measure → pipeline + revenue
```

## Walking the steps

| # | Step | File | Take-home section it answers | Quickstart |
|---|---|---|---|---|
| 1 | Stand up the GTM repo | [step-1-stand-up-the-repo.md](./step-1-stand-up-the-repo.md) | [Part 1 §1](../case-study/part1-diagnose-and-prioritize.md) | [WT 1 — Installation + setup](../quickstart/1-installation-and-setup.md) |
| 2 | Data + playbooks into the repo | [step-2-data-playbooks-ingested-daily.md](./step-2-data-playbooks-ingested-daily.md) | [Part 1 §1](../case-study/part1-diagnose-and-prioritize.md) + **all of [Part 2](../case-study/part2-data-foundation.md)** | [WT 1 — Installation + setup](../quickstart/1-installation-and-setup.md) |
| 3 | Stakeholders into Claude Code | [step-3-stakeholders-in-claude-code.md](./step-3-stakeholders-in-claude-code.md) | [Part 1 §2](../case-study/part1-diagnose-and-prioritize.md) | [WT 2 — First prompts](../quickstart/2-first-prompts-in-claude-code.md) |
| 4 | Capture + prioritize bottlenecks | [step-4-capture-prioritize-bottlenecks.md](./step-4-capture-prioritize-bottlenecks.md) | [Part 1 §3](../case-study/part1-diagnose-and-prioritize.md) | [WT 3 — Bottleneck capture](../quickstart/3-bottleneck-capture.md) |
| 5 | Agentic dev to ship solutions | [step-5-agentic-dev-ship-solutions.md](./step-5-agentic-dev-ship-solutions.md) | **All of [Part 2](../case-study/part2-data-foundation.md)** + **all of [Part 3](../case-study/part3-buying-signal-workflow.md)** | *(post-hire — needs real deals)* |
| 6 | Roll out to the team | [step-6-roll-out-to-team.md](./step-6-roll-out-to-team.md) | [Part 1 risk section](../case-study/part1-diagnose-and-prioritize.md) + [Part 3 §(6)](../case-study/part3-buying-signal-workflow.md) | *(post-hire — needs real reps)* |
| 7 | Measure → pipeline + revenue | [step-7-measure-pipeline-revenue.md](./step-7-measure-pipeline-revenue.md) | [Part 2 §Q3 weight re-fit](../case-study/part2-data-foundation.md) + [Part 3 §(7)](../case-study/part3-buying-signal-workflow.md) | *(post-hire — needs a month of data)* |

## How to read

- Each step file follows the same shape: *what it is → why it's there → what concrete work happens in it → which take-home answer lives inside it → links*.
- Reading them in order tells the full story of how I'd run Mento's first 60 days.
- Reading any one in isolation gets you the answer to *"why does this step matter, and what does it produce?"*

## The shape, made concrete

[**`repo-file-structure.md`**](./repo-file-structure.md) — the full recommended `mento-gtm/` file tree, with each folder mapped to the OS step it lives inside. Mirrors how the CIA structures `clients/<client>/`, GTM-shaped. Read this if you want to see *exactly* what the repo looks like before any code runs.
