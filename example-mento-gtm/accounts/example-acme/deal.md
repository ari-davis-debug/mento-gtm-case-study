---
title: Acme Corp — Deal Cross-Cut
type: account-deal
account_slug: example-acme
status: active
stage: SQL
priority_tier: 1
updated: 2026-05-11
---

# Acme Corp — Deal Cross-Cut

> Illustrative example. Not real data. Shows what Claude auto-assembles when a stakeholder asks *"what's happening with Acme?"*

## Headline

**Tier 1, score 87/100, currently SQL.** First demo booked 2026-05-14. CHRO hired 38 days ago. Series C closed 9 months ago. Trigger fire date: 2026-04-22.

| What | Value | Source |
|---|---|---|
| Funding stage | Series C | `crunchbase` (Enrichment lane) |
| Headcount | 412 | `crunchbase` + LinkedIn delta (Enrichment lane) |
| CHRO hired | Sarah K. — 38 days ago | `the-org` (Enrichment lane) |
| ICP score | 87/100 | `sql/icp_v0.sql` (SQL lane) |
| Last touch | Demo booked via outbound email 2026-05-08 | `hubspot.activities` (SQL lane) |
| Deal stage | SQL | `hubspot.deals` (SQL lane) |

## Why this account scored Tier 1

From `sql/v_priority_queue.sql`, score breakdown:
- Funding stage (Series C) → 22/25 weight
- Headcount (412, within band) → 18/20 weight
- Recent CHRO hire (38 days ago) → 28/30 weight ← highest contributor
- Industry (B2B SaaS — vertical) → 13/15 weight
- Geographic (San Francisco) → 5/5 weight
- Negative signal penalty: 0 (no existing comp tool detected)

**Total: 86/100, rounded to 87.**

## The trigger that fired

Trigger event row from `signal_events`:
```
trigger_id: tr_2026_04_22_acme_chro
account_id: acme
event_type: chro_hire
event_date: 2026-03-15
discovered_date: 2026-04-22
source: the-org
confidence: high
public_evidence: linkedin.com/in/sarah-k-acme-chro
```

## The pitch we sent (2026-05-08)

From `services/signal-workflow/`:

> Sarah's six weeks in — first comp review is probably 60 days out. Mento is what new-CHROs at Series-C SaaS use to stand up the first board-defensible bands. We helped [comparable comp] do this in 14 days; happy to share the deck. 15 min next Tuesday or Wednesday?

Eval gate score: 0.91 (passed). Reply within 18 hours. Demo booked 2026-05-14.

## Recent activity (last 14 days)

| Date | Activity | Channel | Notes |
|---|---|---|---|
| 2026-05-08 | Cold outbound email sent | SmartLead → Sarah K. | Eval-passed draft, see above |
| 2026-05-09 | Reply received | Sarah K. → Mento | "Tuesday works, what time?" |
| 2026-05-09 | Calendar booked | HubSpot meeting link | 2026-05-14 at 11am PT |
| 2026-05-10 | Discovery prep sent | Internal | See `transcripts/2026-05-10-prep.md` |

## Open questions for the demo

- Is the CFO the signer, or does Sarah have signing authority for tools under $150k?
- Has Pave or Compa been evaluated already?
- When is the next compensation review scheduled?

## Linked
- [Timeline of every signal](./timeline.md)
- [Avoma transcript cuts](./transcripts/)
- [Trigger signals fired on Acme](./signals/)
- [Rep notes](./notes.md)
- ICP scoring function: [`../../sql/icp_v0.sql`](../../sql/icp_v0.sql)
- Priority queue view: [`../../sql/v_priority_queue.sql`](../../sql/v_priority_queue.sql)
