# 5 — What the End-State Looks Like for Reps

> Audience: Reps (Mento's 2) · Outcome: see what a rep's Monday morning looks like *if* the workflow from walkthrough 4 ever gets operationalized

## What this walkthrough covers

Walkthroughs 1–3 are about looking at your data. Walkthrough 4 is the shape of a workflow built on it. **This walkthrough is the end-state — what reps experience if and when that workflow is actually deployed.** It's here so you can decide *"would I want this?"* before anything gets built.

Reps don't open Claude Code. They don't touch SQL. They don't look at Trigger.dev dashboards. Their entire window into the OS is one Slack card per top-priority account, per day. If that card isn't worth 20 seconds of their time, the system has failed — regardless of how clever the backend is.

This walkthrough is what 20 seconds of value looks like.

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

Verified contacts (ranked by buyer fit):
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

[ ✅ Approve & Send ]
[ ✏️ Edit ]
[ 🚫 Skip… ]
```

## How to read the card (top to bottom)

- **Priority 170** = top 5% of accounts the system has ever scored. *"Go now."*
- **Score breakdown** — three things fired in 90 days. The system tells you *why* this is at the top. Disagree? Audit every number.
- **Four verified contacts.** Not one. The draft is to Marisol because she's the CHRO and the buying signal is hers. Want James instead? One click to swap.
- **Draft preview inline.** No clicking into anything to see what's there.
- **Deep links** — every claim (the funding event, the Avoma quote, the trigger detail) is one click from its source. Nothing is a black box.

## The three buttons

**✅ Approve & Send**

- Sends the email from the rep's connected mailbox. Follow-up sequence (day 3 / 7 / 14 / 21) runs automatically.
- HubSpot upsert happens too: contact, company, activity note, email logged. **No deal created on approve — the deal is created on reply.** Outbound isn't pipeline; engagement is.

**✏️ Edit**

- Opens the full draft + a lake panel (Avoma quotes, prior wins, all four contacts). Edit it, swap the recipient, save. Come back to Slack with the updated preview. Approve.
- The diff between agent draft and rep edit is the highest-quality training signal in the system. The longer reps use it, the better it gets at sounding like them.

**🚫 Skip…**

- Required dropdown: already reached out / wrong contact / not a fit / timing off / other. **No naked skips.** Skip reasons are the second-best training signal — the drafter learns what *not* to send.

## What the rep is *not* doing — the whole point

- Not finding contacts. The enrichment layer did that.
- Not researching the company. The card has funding, headcount, org chart.
- Not writing the email. The drafter wrote it; the eval gate filtered it; the rep taste-tests it.
- Not logging activity in HubSpot. Approve does it.
- Not babysitting follow-ups. The sequencer does that.

**The rep's job is 20 seconds of taste.** Read, swap a word if needed, click. The system handles the rest. That's the trade.

## What happens after

- **After approve:** email sends, follow-up sequence runs. If the prospect replies, a HubSpot deal gets created automatically at Discovery — that's when this becomes pipeline. Until then, it's outbound. No stale deals cluttering the forecast.
- **No reply after 21 days:** sequence ends, trigger archives, system goes looking for the next signal. Nothing rots.
- **The card decays after 7 days** if not acted on. Stale signals are worse than no signals. Decays feed the monthly retrain — the system learns to stop showing what the rep would skip.

## What you've unlocked (after seeing this)

- **A clear picture of what reps would experience** if the workflow from walkthrough 4 gets operationalized.
- **A decision frame**: *would your reps spend 20 seconds on this card every morning?* That's the adoption test, and you can answer it now — before anything's built.
- **Three buttons, three jobs, no menus.** If the card needs a fourth, the design is wrong.
- **No deal on approve, deal on reply.** Pipeline stays clean.

## Common questions

- **Why is this in the walkthroughs if it's not something you'd install yet?** Because deciding whether to *eventually* build it is more important than building it. Reading this card is the simplest test for whether the workflow is worth operationalizing — long before a single API key gets paid for.
- **What if a rep is OOO?** Cards decay after 7 days. Routing handles round-robin to whoever's covering.
- **What if the contact is wrong?** Edit → swap → save → approve. Wrong-contact skips train the contact-ranking model.
- **What if a rep doesn't trust the priority score?** Click *Trigger detail* — full SQL breakdown, every weight visible. Skip with reason "wrong_priority" — that feeds the retrain.
- **Why a hard cap at 10/day?** More than 10 means reps skim. ≤10 means they taste-test. Volume is the enemy of conversion.
- **When would I actually deploy this?** Once moves 1–5 in walkthrough 4 land cleanly *and* you've decided the bottleneck is worth the marginal execution-stack cost. Until both are true, the card shape is the artifact you use to align stakeholders on what "good" looks like.
