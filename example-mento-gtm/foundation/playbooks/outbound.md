---
title: Outbound Playbook
type: playbook
domain: foundation
status: validated
updated: 2026-05-11
---

# Outbound Playbook

> Mento outbound is trigger-led, not template-led. One trigger per email. One ask per email.

## The shape of every outbound email

```
Subject: [trigger-specific, 3–5 words, no clickbait]

[1 sentence: the trigger, named]
[1 sentence: the specific implication for them]
[1 sentence: a stat or comparable-company anchor]
[1 sentence: the ask — small, time-boxed]

— [rep first name]
```

That's it. 4 sentences. No "I hope this finds you well." No "I noticed you...."

## Worked examples by trigger

**CHRO hire trigger** (highest-converting)

> Subject: [Company] + [CHRO name]
>
> [CHRO name] is six weeks in — first comp review is probably 60 days out.
> Mento is what new-CHROs at Series-B-to-D SaaS use to stand up the first board-defensible bands.
> We helped [comparable company] do this in 14 days; happy to share the deck.
> 15 min next Tuesday or Wednesday?
>
> — [rep]

**Series-C/D close trigger**

> Subject: [Company] Series [round]
>
> Congrats on the close — pre-this-round bands are about to feel small.
> Mento gives your CHRO a defensible refresh in two weeks, not two quarters.
> [Comparable company] ran their post-Series-C refresh on us in March.
> Worth 20 minutes to walk through what that looked like?
>
> — [rep]

**Headcount delta ≥10% trigger**

> Subject: [Company] +[delta] in [N] days
>
> Adding [delta] people in [N] days means the bands set 9 months ago are wrong on the top and the bottom.
> Mento closes the offer-to-band drift problem in the first refresh cycle.
> [Comparable company] surfaced 23% of their ICs out-of-band the week we turned on.
> Open to a 15-minute walkthrough this week?
>
> — [rep]

## What the eval gate checks

Every Mento outbound email passes through an LLM-as-judge gate before a rep sees the draft. Threshold: **≥ 0.85 on all four dimensions.**

| Dimension | What it checks |
|---|---|
| **Voice match** | Sounds like Alex wrote it, not a marketing email |
| **Trigger specificity** | Names a public-data trigger, not a generic pain |
| **Comparable-company anchoring** | References a real, public comparable company |
| **Ask sizing** | One ask, time-boxed, low-friction |

Drafts that fail the gate land in `services/signal-workflow/eval/failed-drafts/` for a weekly human-review batch. Rep never sees a sub-0.85 draft.

## Sequencer placement

- **Email 1** lands within 24 hours of trigger fire
- **Email 2** (if no reply): 4 business days later, different angle, references a different comparable company
- **Email 3** (if no reply): LinkedIn DM via SmartLead's LI integration — different angle again
- **After email 3**: stop. Re-enter sequencer only on a new trigger fire.

## What never goes in an outbound email

- "I hope this finds you well"
- "Just following up"
- Any sentence that could be in any other vendor's email
- Comp data without a comparable-company name attached
- A long pitch — if they want long, they'll book a demo

## How this playbook gets updated

Same as discovery — quarterly Claude pass over the last 90 days of outbound results. Drafts that closed get studied. Drafts that didn't get a reply get studied harder.
