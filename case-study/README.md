# Case Study — Direct Answers to the Take-Home

> The three questions Mento asked. The three answers, one per file.

This folder holds the direct take-home answers. If you want the wider framing — *why* this is the answer, where it fits in a 7-step GTM OS — start at the [top-level README](../README.md) or in [`gtm-os/`](../gtm-os/).

## The three parts

| Part | File | What it answers | Time |
|---|---|---|---|
| **1** | [part1-diagnose-and-prioritize.md](./part1-diagnose-and-prioritize.md) | First 3 things, in what order, what to gather in week 1, biggest 60-day risk | ~5 min read |
| **2** | [part2-data-foundation.md](./part2-data-foundation.md) | Dedupe, enrichment, ICP scoring (V0 → V1), lifecycle state machine | ~10 min read |
| **3** | [part3-buying-signal-workflow.md](./part3-buying-signal-workflow.md) | Monitor → enrich → score → route → draft → HITL → sequencer, with code | ~10 min read |

## How each part maps to the GTM OS

```
Part 1   →   Steps 1, 2, 3, 4  (Foundation)
Part 2   →   Step 5's substrate (the lake + the playbooks)
Part 3   →   Step 5's build layer (the signal workflow itself)
After 60d →  Steps 6, 7  (Roll out, Measure)
```

Each `gtm-os/step-N-*.md` file links back to the exact section of the take-home that lives inside it.
