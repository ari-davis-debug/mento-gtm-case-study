# 5 — Rep Experience in Slack

> Audience: Reps (Mento's 2) · Outcome: see what a rep actually does with this thing on a Monday morning

## What this walkthrough covers

A rep opens Slack on Monday morning. There's a card waiting from `@mento-signals`. What's on it, what each button does, what happens after they click. **Nothing else** — no architecture, no SQL, no Trigger.dev. The rep's window is Slack.

This is the only walkthrough aimed at reps directly. You don't need to know how the OS works. You don't need to open Claude Code. You don't need to touch SQL. Your window into this entire system is Slack.

## The card that lands

```
@mento-signals  ·  09:21
─────────────────────────────────────────────────
🔥  PRIORITY 170  ·  Glimmer Health  (alex_owner)

Triple-event fired in 90d:
 • Series C (Apr 14, $80M, lead: a16z)
 • +220 headcount (180d, +23%)
 • New CHRO Mar 2 (Marisol Hwang, ex-Brex)
Lookalike 0.81 → Brex

Verified contacts (BlitzAPI ✓ — ranked by buyer fit):
 1. Marisol Hwang · CHRO  (primary)
    marisol@glimmer.health  ·  +1-415-555-0144 (mobile)
 2. James Okafor · VP People
    james@glimmer.health  ·  +1-415-555-0188
 3. Priya Shah · Head of L&D
    priya@glimmer.health
 4. Daniel Kim · CFO (budget owner — fallback)

Draft preview (to Marisol):
 ┌─────────────────────────────────────────────┐
 │ Subject: Quick note — saw your team grew    │
 │   by ~220 this year                          │
 │                                              │
 │ Marisol — congrats on Glimmer's Series C    │
 │ and the CHRO seat. When Brex grew through   │
 │ a similar inflection in '23, their VP       │
 │ People told us on a discovery call that     │
 │ their biggest blocker was "we promoted 40   │
 │ ICs into managers in 9 months and most of   │
 │ them have never had a manager who coached   │
 │ them." That's the exact gap we close in     │
 │ the first 30 days...                        │
 │  [+ 60 more words]                          │
 └─────────────────────────────────────────────┘
evidence_used: brex_2024_q3_call,
               series_c_apr14, chro_hire_mar02
voice_match: 0.94  ·  eval_score: 0.91

Open in: [HubSpot] [Lead profile]
         [Trigger detail] [Avoma] [Sequence]

[ ✅ Approve & Send → SmartLead seq ]
[ ✏️ Edit ]
[ 🚫 Skip… ]
```

## How to read the card (top to bottom)

- **Priority 170** means top 5% of accounts the system has ever scored. *"Go now."*
- **Score breakdown** — three things fired in 90 days. The system explains why this is at the top. Disagree? Audit every claim.
- **Four verified contacts.** Not one. The draft is to Marisol because she's the CHRO and the buying signal is hers. Want to hit James instead — one click to swap.
- **Draft preview** — read it inline. No clicking into anything to see what's there.
- **Deep links** — every claim (funding event, Avoma quote, trigger detail) is one click from the source. Nothing is a black box.

## The three buttons

**Approve & Send →**

- Sends the email from your connected mailbox via SmartLead. SmartLead picks up the follow-up sequence — day 3, day 7, day 14, day 21. You don't manage that. It just runs.
- HubSpot upsert happens too: contact, company, activity note, email logged. No deal created — yet. **The deal is created on reply, not approve.** Outbound isn't pipeline; engagement is.

**Edit →**

- Opens a browser modal with the full draft, the lake panel (Avoma quotes, prior wins, all four contacts). Edit it, swap the recipient if you want, save. Come back to the Slack card with the updated preview. Click Approve.
- Your edits are training data. The diff between what the agent wrote and what you sent retrains the drafter monthly. **The longer you use this, the better it gets at sounding like you.**

**Skip…**

- Dropdown: already reached out, wrong contact, not a fit, timing off, other. Required field — no naked skips. Why? Skip reasons are the second-best training signal. The drafter learns what *not* to send.

## What you're *not* doing — the whole point

- Not finding contacts. BlitzAPI did that. Verified email + phone.
- Not researching the company. The card has the funding, the headcount, the org chart.
- Not writing the email. The drafter wrote it; the eval gate filtered it; you taste-test it.
- Not logging activity in HubSpot. The approve does it.
- Not babysitting follow-ups. SmartLead does that.

Your job is **20 seconds of taste**. Read the draft, swap a word if you want, approve. The system handles the rest.

## What happens after

- After approve: the email sends. SmartLead runs follow-ups. If they reply, a HubSpot deal record gets created automatically at Discovery stage — that's when this is pipeline. Until reply, this is outbound, not pipeline. No stale deals cluttering your forecast.
- If they don't reply after 21 days, the sequence ends, the trigger event archives, the system goes looking for the next signal. Nothing rots.
- The card decays after 7 days if you don't act. That's a feature. Stale signals are worse than no signals. Skip reasons feed the monthly retrain — the system gets better at not showing you ones you'd skip.

Open Slack tomorrow morning, look for the card, taste-test the draft, click. That's the workflow.

## What you've unlocked

- **Slack is your window.** You don't go anywhere else.
- **Priority + score breakdown is the audit.** If you don't trust the number, the system shows you how it got there.
- **Three buttons. Three jobs. No menus.** Approve / Edit / Skip with reason.
- **No deal on approve, deal on reply.** Pipeline stays clean.
- **Your edits and skip reasons train the system.** It gets better at being you.

## Common questions

- **What if I'm OOO?** Cards decay after 7 days. If you're out, they expire; if a peer covers your accounts, the routing rule (Part 3 §4) handles round-robin.
- **What if the contact is wrong?** Edit → modal shows all four contacts → pick the right one → save → approve. Wrong-contact skips are tracked and feed the contact-ranking retrain.
- **What if I want to add my own context to the draft?** Edit. Diff is captured. Your version is what sends.
- **What if I don't trust the priority score?** Click *Trigger detail* — full SQL breakdown, every signal listed with its weight. If you disagree, skip with reason "wrong_priority" — that feeds the retrain.
- **What if SmartLead's follow-up template doesn't fit?** Each signal type has its own SmartLead campaign with tuned follow-ups. You can override step 1 (the approved draft); steps 2–5 use the campaign defaults. If the defaults are off, flag in `#signals-feedback` — that's a signal to retune.
- **Can I get more than 10 a day?** No. The top-10 cap is intentional. More than 10 means you skim; ≤ 10 means you taste-test. Volume is the enemy of conversion.
