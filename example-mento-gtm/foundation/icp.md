---
title: Mento ICP — V0
type: icp
domain: foundation
status: validated
version: v0
updated: 2026-05-11
related:
  - [[supports:_synthesis]]
  - [[implements:../sql/icp_v0.sql]]
---

# Mento ICP — V0

> The written-down ICP. V0 = today's best guess based on 12 won deals + 5 lost deals audited. V1 lands after the formal win-audit runs in Step 4.

## The archetype

**Series-B-to-Series-D B2B SaaS company, 150–800 employees, with a new CHRO or VP-People hired in the last 120 days.**

That's the headline. The components in detail:

| Dimension | V0 weight | Range | Why |
|---|---|---|---|
| **Funding stage** | 25% | Series B / C / D | Pre-B = no budget. Post-D = in-house or PE-controlled. |
| **Headcount** | 20% | 150–800 | Below 150, founders eyeball comp. Above 800, in-house team usually exists. |
| **Recent people-leader hire** | 30% | CHRO / VP People / Head of People hired in last 120 days | Highest-signal trigger from `_synthesis.md` belief #1. |
| **Industry** | 15% | B2B SaaS (vertical SaaS, dev tools, horizontal SaaS) | Where Mento has won. Excludes services, marketplaces, hardware. |
| **Geographic** | 5% | US + Canada primarily | Mento's GTM is North America. EU has data-residency complications. |
| **Negative signals** | 5% | PE-owned / has Pave or Compa already / founder-led with no people function | Each one of these collapses the deal probability |

## Disqualifying signals

A prospect can score high on V0 weights but still get filtered out if any of these are true:

- **Existing compensation tool in production** (Pave, Compa, Carta Total Comp) — not impossible to displace but ~3× longer cycle, not a fit for Mento's current capacity
- **PE-owned with active operating partner** — usually means tooling is mandated centrally
- **Bootstrapped + founder-led + < 150 headcount** — comp is still a side-of-desk concern, not a board topic
- **Within 30 days of a layoff announcement** — wrong moment, revisit in 6 months

## How scoring works

See [`../sql/icp_v0.sql`](../sql/icp_v0.sql) for the actual function. The high-level shape:

```
icp_score = (funding_weight × funding_fit)
          + (headcount_weight × headcount_fit)
          + (recent_hire_weight × hire_recency_score)
          + (industry_weight × industry_fit)
          + (geo_weight × geo_fit)
          - (negative_signal_penalty)

# tiers:
#  85–100 → Tier 1 ("hot")
#  60–84  → Tier 2 ("warm")
#  35–59  → Tier 3 ("nurture")
#  < 35   → out
```

## V0 → V1 pipeline

V0 is hand-tuned. V1 comes from the monthly logistic regression on `accounts × outcomes` once we have 90+ days of outcomes data flowing into Supabase/BigQuery. The pipeline:

1. Capture every account that *touched* (replied, demoed, opted out, closed-won, closed-lost) — that's the labeled training set
2. Run logistic regression — each ICP dimension → coefficient
3. Propose new weights as a PR to this file + `../sql/icp_v1_refit.sql`
4. Human review, merge, deploy
5. Re-run monthly

## What this ICP is *not*

- **It's not the segment.** Segment = "who is in pain right now." ICP = "who is in the room." Mento needs both — the segment is captured by `trigger_events` rows (CHRO hire, funding event, headcount delta).
- **It's not a permanent filter.** Accounts can move between tiers when triggers fire. The 200-list re-scores against the latest signals weekly.
- **It's not the positioning.** See [`positioning.md`](./positioning.md) for how Mento *talks* about its fit.
