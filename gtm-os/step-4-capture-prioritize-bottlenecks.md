# Step 4 — Capture + Prioritize Bottlenecks

> Foundation · Day 7–10

## What this step is

Read the lake, write down what's broken, rank it. Each bottleneck becomes a node in `mento-gtm/bottlenecks/` with the same schema: *systems touched, problem, how measured, root cause hypothesis, desired outcome, priority score (impact × buildability × stakeholder-trust)*.

## Why this step matters

Most GTM-engineering hires skip this step and go straight to building the signal workflow. The system pumps the wrong leads at reps who don't trust it, and dies in week five. **Capturing bottlenecks from data — not from interviews — is what makes the build worth shipping.**

## What concrete work happens here

### Phase 0 — data archaeology, before anything else
*Distrust the CRM labels first.* HubSpot will say a deal was "inbound demo request"; the lake will often show the CHRO was hired 45 days prior. The CHRO hire is the actual signal.

Before ranking bottlenecks, cross-reference 8–10 won deals against what was *publicly true* about those accounts 6–18 months before close — funding state, headcount delta, exec turnover, careers-page churn. This is the input that makes the "outcome-backward ICP" in Part 2 honest.

It's the difference between *who is in the room* (filter) and *who is in pain right now* (segment).

### Bottleneck capture
Each bottleneck = one file. Example shape:

```yaml
# bottlenecks/example-no-trigger-coverage-on-200-list.md
---
systems_touched: [hubspot, apollo, manual]
problem: 200-account list hasn't been re-scored against signals in 8 months
how_measured: 0 of 200 accounts have a "last_signal_check" field
root_cause_hypothesis: no automated signal monitor exists; reps re-check manually only on outbound days
desired_outcome: every account on the 200-list has signal state refreshed daily, new triggers surfaced to the right rep
priority_score: impact 9 / buildability 7 / trust 8 = 24
---
```

### The gate
The top-ranked bottleneck is what gets built in Step 5. **Part 3's signal workflow only earns the right to ship if it's the top-ranked bottleneck.** If the audit surfaces a different #1 — intros dying in Slack threads, or playbook drift between reps — we build that instead.

The illustrative example above is exactly that: *illustrative*. The actual top-1 surfaces from the work in this step.

## Which take-home section lives inside this step

[Part 1 §3 — *"Capture + prioritize bottlenecks"*](../case-study/part1-diagnose-and-prioritize.md)

The Phase 0 data archaeology paragraph + the YAML schema example above are the same as in Part 1 §3.

## What's next

[Step 5 — Agentic dev to ship solutions](./step-5-agentic-dev-ship-solutions.md) — the top-ranked bottleneck (assumed to be the signal-coverage gap, for the purpose of Part 3) gets the spec → research → test → ship treatment.
