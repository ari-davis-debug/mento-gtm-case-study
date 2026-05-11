---
title: Discovery Playbook
type: playbook
domain: foundation
status: validated
updated: 2026-05-11
related:
  - [[supports:../_synthesis]]
  - [[implements:../positioning]]
---

# Discovery Playbook

> What a discovery call looks like at Mento. Rewritten quarterly from Avoma evidence on won-deal discovery calls.

## Opening (first 4 minutes)

**The setup.** Don't start with "tell me about your comp problem." Start with the *trigger*:

> *"Saw [trigger event — usually CHRO hire or Series C/D close]. Curious — has the comp conversation come up yet for [name], or is it still on the runway?"*

**What you're listening for** in the first 4 minutes:
- Did they confirm the trigger is salient? (Strong signal)
- Did they pivot to a different pain? (Could be a wedge or a disqualifier)
- Did they mention the board? (Tier-1 buying signal — board pressure)

## The 4 questions that always come up

**1. "Tell me about your current comp process."**
- Listen for: spreadsheets, Radford, "we don't really have one," "we use Pave but..."
- Each answer maps to a different positioning angle

**2. "Who owns comp decisions today?"**
- Listen for: "the founder," "our HR person plus the founder," "we just hired a CHRO"
- New-CHRO = highest-fit. Founder-owned = need to map decision tree.

**3. "What does the next comp review look like?"**
- Listen for: defensibility language ("the board will ask," "investors expect"), or compliance language
- Defensibility = warm. Compliance = cooler — pivot to a different pitch.

**4. "What would good look like in 90 days?"**
- Closing the discovery: get them to articulate the desired end-state in their words
- This is what you'll write back in the recap

## Disqualifiers to surface early

If you hear these, slow down (don't push):
- *"We just signed with Pave/Compa/Carta Total Comp."* → 6-month revisit, not now
- *"We're going through a layoff."* → Wrong moment, set a 90-day follow-up
- *"PE just bought us, they're standardizing on X."* → Disqualify, document the X for future research

## The recap (sent within 2 hours)

The recap is the deliverable. Structure:

```
Hi [name] —

Quick recap of what we covered:

What's true today:
- [bullet 1 from their words]
- [bullet 2 from their words]
- [bullet 3 from their words]

What good looks like in 90 days (your words):
- [the answer to question 4, verbatim]

Where I think Mento can help:
- [1–2 specific places, tied to their words]

What I'd want from you before our next conversation:
- [one ask — e.g., "introduce me to your CFO"]

— [rep]
```

**The recap is the close of discovery.** If it sounds like a forwarded brochure, you've lost the deal.

## What to log in the repo

After every discovery call:
1. Avoma transcript auto-lands in `accounts/<slug>/transcripts/`
2. Manually write a 5-line summary to `accounts/<slug>/notes.md` with date + key quotes
3. If the call surfaces a new pattern, propose an update to [`../_synthesis.md`](../_synthesis.md) via PR

## How this playbook gets updated

- Every quarter: Claude reads 8–10 won-deal discovery transcripts in `data/avoma/` (or via SQL if Step 2b is stood up) and proposes diffs to this file
- Diffs land as PRs with the Avoma quotes that justify them
- Alex reviews and merges
