# Step 7 — Measure → Pipeline + Revenue

> Operate · Day 60 onward (the only legitimate success metric)

## What this step is

Closed-loop attribution. The OS earns its keep when **pipeline and revenue go up** — not when a script runs on a cron, not when a queue fills, not when a Slack card gets clicked. Cetner names this explicitly: *"you moved the constraint correctly when pipeline & revenue go up."*

## Why this step matters

Every prior step can be done correctly and still fail at this one. Reps could approve drafts that go nowhere. Signals could fire on accounts that never convert. ICP scoring could be confidently wrong. Step 7 is the feedback loop that keeps the rest of the system honest — and re-tunes the weights when reality disagrees with the math.

## What concrete work happens here

### The outcomes loop
```
   trigger fires → enriched → scored → routed → drafted → approved → sent
                                                                       │
                                                                       ▼
                                  SmartLead webhook on sent/open/reply/booked/opt-out
                                                                       │
                                                                       ▼
                                          Supabase `outcomes` table
                                                                       │
                                                                       ▼
                              Monthly: logistic regression
                              on trigger_events × outcomes
                                                                       │
                                                                       ▼
                              New weights proposed as PR
                              (human review, never auto-merge)
```

### What gets tuned, with what data

| What's tuned | Data source | Frequency |
|---|---|---|
| **Trigger scoring weights** (Part 3 §3) | `trigger_events` × `outcomes` (sent → replied → booked) | Monthly logistic regression |
| **ICP scoring weights** (Part 2 §Q3) | `accounts` × `outcomes` (won vs lost) | Monthly logistic regression |
| **Draft generator prompts** | Diff between agent draft and rep-edited version | Continuous (every approve with edits) |
| **Lifecycle stage definitions** (Part 2 §Q4) | Disqualification reasons + reconversion patterns | Quarterly review |

### Deal-on-reply pattern (the clean attribution unlock)
An approved cold email is *intent to outbound*, not pipeline. The deal record only gets created when **the account replies** (or books a meeting). That's the first earned signal — *this account is engaging.*

Until then we have everything we need to attribute later: contact upserted, activity logged, email logged, trigger row in Supabase. We can always *create* the deal retroactively. But we can't easily *unmess* a pipeline polluted with unreplied cold-email rows.

### The single source-of-truth metric
**Pipeline + closed-won revenue, attributable back to a specific trigger event.** Everything else (approval rate, draft quality scores, eval-gate pass rate) is leading-indicator vanity. This is the metric Step 7 measures, and the metric the OS gets evaluated on.

## Which take-home sections live inside this step

- [Part 2 §Q3 — *"V0's tier weights get re-fit monthly"*](../case-study/part2-data-foundation.md) — ICP weight tuning
- [Part 3 §(7) — *"Approve → CRM sync → Sequencer"* + outcomes loop](../case-study/part3-buying-signal-workflow.md) — deal-on-reply pattern + monthly trigger-weight re-fit

## How this closes the loop

Step 7's outputs feed back into Step 5 (better weights = better priority queue) and Step 6 (better drafts = more rep trust). The OS isn't a project that ships once — it's a system that gets sharper every month *because* the outcomes loop exists.

That's the whole point of the 7-step shape: every step makes the next one's job easier, and the last step makes the whole system smarter.

## ← Back to the start

[GTM OS index](./README.md) · [Top-level README](../README.md) · [Case study answers](../case-study/)
