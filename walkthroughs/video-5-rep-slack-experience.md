# Video 5 — What a Rep Sees in Slack

> ~4 minutes · Audience: Reps (Mento's 2) · Goal: first time reps see a signal card — trust-build moment

## What this video shows

A rep opens Slack on Monday morning. There's a card waiting from `@mento-signals`. We walk what's on it, what each button does, and what happens after they click. **Nothing else** — no architecture, no SQL, no Trigger.dev. The rep's window is Slack.

## Setup before hitting record

- A Slack workspace with `#signals-<rep-slug>` DM thread or channel
- Pre-staged trigger fired for Glimmer Health (the synthetic example used through the case study)
- HubSpot test account ready to receive the upsert
- SmartLead sandbox campaign ready to accept the email

## Beat-by-beat

### 0:00–0:20 — Why this video is for reps

> *"This is the only video in the series aimed at the reps directly. You don't need to know how the OS works. You don't need to open Claude Code. You don't need to touch SQL. Your window into this entire system is Slack. Four minutes is everything you need."*

### 0:20–1:30 — The card lands. What you see.

Switch to Slack. Show the DM thread. Show the card arriving as a real Slack message — pinning helps visually.

The card content (this is the actual mock from Part 3):

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

Walk it left-to-right, top-to-bottom:

> *"Priority 170 means top 5% of accounts the system has ever scored. 'Go now.'"*

> *"Score breakdown — three things fired in 90 days. The system explains why this is at the top. If you disagree, you can audit every claim."*

> *"Four verified contacts. Not one. The draft is to Marisol because she's the CHRO and the buying signal is hers. If you'd rather hit James — one click to swap."*

> *"Draft preview. You can read it inline. No clicking into anything to see what's there."*

> *"Deep links. Every claim — the funding event, the Avoma quote, the trigger detail — is one click from the source. Nothing is a black box."*

### 1:30–2:30 — The three buttons, what each one does

> *"Three buttons. They do exactly what they say."*

**Approve & Send →**
- *"Sends the email from your connected mailbox via SmartLead. SmartLead picks up the follow-up sequence — day 3, day 7, day 14, day 21. You don't manage that. It just runs."*
- *"HubSpot upsert happens too: contact, company, activity note, email logged. No deal created — yet. The deal is created on reply, not approve. Outbound isn't pipeline; engagement is."*

**Edit →**
- *"Opens a browser modal with the full draft, the lake panel — Avoma quotes, prior wins, all four contacts. Edit it, swap the recipient if you want, save. You come back to the Slack card with the updated preview. Click Approve."*
- *"Your edits are training data. The diff between what the agent wrote and what you sent retrains the drafter monthly. The longer you use this, the better it gets at sounding like you."*

**Skip…**
- *"Dropdown: already reached out, wrong contact, not a fit, timing off, other. Required field — no naked skips. Why? Because skip reasons are the second-best training signal. The drafter learns what not to send."*

### 2:30–3:15 — What you don't have to do

> *"What you're *not* doing — and this is the whole point."*

- *"You're not finding contacts. BlitzAPI did that. Verified email + phone."*
- *"You're not researching the company. The card has the funding, the headcount, the org chart."*
- *"You're not writing the email. The drafter wrote it; the eval gate filtered it; you taste-test it."*
- *"You're not logging activity in HubSpot. The approve does it."*
- *"You're not babysitting follow-ups. SmartLead does that."*

> *"Your job is 20 seconds of taste. Read the draft, swap a word if you want, approve. The system handles the rest."*

### 3:15–4:00 — What happens after, and how this stays trustworthy

> *"After approve: the email sends. SmartLead runs follow-ups. If they reply, a HubSpot deal record gets created automatically at Discovery stage — that's when this is pipeline. Until reply, this is outbound, not pipeline. You don't have stale deals cluttering your forecast."*

> *"If they don't reply after 21 days, the sequence ends, the trigger event archives, and the system goes looking for the next signal. Nothing rots."*

> *"The card decays after 7 days if you don't act. That's a feature. Stale signals are worse than no signals. Skip reasons feed the monthly retrain — the system gets better at not showing you ones you'd skip."*

> *"That's it. Open Slack tomorrow morning, look for the card, taste-test the draft, click. That's the workflow."*

## What the viewer walks away knowing

- **Slack is your window.** You don't go anywhere else.
- **Priority + score breakdown is the audit.** If you don't trust the number, the system shows you how it got there.
- **Three buttons. Three jobs. No menus.** Approve / Edit / Skip with reason.
- **No deal on approve, deal on reply.** Pipeline stays clean.
- **Your edits and skip reasons train the system.** It gets better at being you.

## Common questions this video should answer

- *"What if I'm OOO?"* → Cards decay after 7 days. If you're out, they expire; if a peer covers your accounts, the routing rule (Part 3 §4) handles round-robin.
- *"What if the contact is wrong?"* → Edit → modal shows all four contacts → pick the right one → save → approve. Wrong-contact skips are tracked and feed the contact-ranking retrain.
- *"What if I want to add my own context to the draft?"* → Edit. Diff is captured. Your version is what sends.
- *"What if I don't trust the priority score?"* → Click *Trigger detail* — full SQL breakdown, every signal listed with its weight. If you disagree, skip with reason "wrong_priority" — that feeds the retrain.
- *"What if SmartLead's follow-up template doesn't fit?"* → Each signal type has its own SmartLead campaign with tuned follow-ups. You can override step 1 (the approved draft); steps 2–5 use the campaign defaults. If the campaign defaults are off, that's a signal to retune — flag it in `#signals-feedback`.
- *"Can I get more than 10 a day?"* → No. The top-10 cap is intentional. More than 10 means you skim; ≤ 10 means you taste-test. Volume is the enemy of conversion.
