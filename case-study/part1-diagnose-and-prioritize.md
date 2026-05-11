# Part 1 — Diagnose & Prioritize

> Mento GTM Engineer Take-Home · 1-page brief
> *Frame: this is Steps 1–4 of a 7-step GTM Operating System pattern. The repo described below is real — `mento-gtm/` is being built alongside this submission. The submission ships with five written walkthroughs ([`quickstart/`](../quickstart/)) so Alex and the reps can see exactly how to set it up and use it on day 1.*

## The Slack message I got

> **Day one, Slack DM:**
>
> *"Hey — excited to have you here. Here's where things stand: our HubSpot is a mess. We have contacts from events, inbound leads, customer referrals, and past outreach all living in the same place with no real structure. We also have call recordings in Avoma and a list of ~200 target accounts we've been meaning to activate. We know coaching demand spikes when companies hit certain inflection points — new funding, rapid hiring, a new CHRO — but we have no system to catch those signals. I'd love for us to have something working within 60 days. What would you build, and in what order?"*

**The real pain in that message isn't the messy HubSpot.** It's that **Mento has been winning deals through warm intros and exec dinners for two years, and nobody has written down why those deals close** — in a place the team can actually work in.

So my job in week one isn't to clean HubSpot or ship an automation. **It's to stand up the GTM Operating System** — repo, full daily data ingestion, stakeholders inside it — *then* let the bottleneck-capture happen on top of that foundation. Steps 5–7 (ship, roll out, attribute) come after.

---

## Q: What are the first three things you do, in order?

**A:** (1) Stand up the GTM OS — repo + full daily Airbyte ingestion. (2) Get stakeholders into Claude Code, pointed at the repo. (3) Capture and prioritize bottlenecks from what the data is telling us.

Detail on each below.

### Q: First — what does "stand up the GTM OS" actually mean? (Weeks 1–2 → Steps 1 + 2)

**A:** Spin up `mento-gtm/` as the source-of-truth repo. **Airbyte → Supabase pulls everything Mento has, daily** — not just 12 won-deal transcripts, *everything*. Snapshots of accounts, contacts, deals, activities; full Avoma transcript library; Slack threads on deal channels; board decks; the 200-account list with attribution; Apollo/Crunchbase enrichment; L&D job-board feeds. Airbyte's OAuth-based connectors mean we don't need API keys floating around — Alex authorizes HubSpot/Avoma/Slack once via the standard OAuth dance, and the daily sync is live. A small ingest worker auto-front-matters each file (source, date, type, account, deal_id) and routes it into the repo tree:

```
mento-gtm/
├── foundation/                 # who Mento is
│   ├── _synthesis.md           # rolling: "what we currently believe wins deals"
│   ├── icp.md                  # written-down ICP (starts empty, fills from Step 3)
│   └── playbooks/              # rewritten live in Claude Code
├── data/
│   ├── hubspot/                # daily snapshots: accounts, contacts, deals, activities
│   ├── avoma/                  # transcripts + summaries
│   ├── slack/                  # deal-channel threads
│   ├── apollo/                 # enrichment pulls
│   └── signals/                # funding, job postings, headcount deltas
├── accounts/<account-slug>/    # one folder per top account, auto-assembled
│   ├── deal.md                 # cross-cuts of HubSpot + Avoma + Slack
│   └── timeline.md             # 90-day signal trail
├── bottlenecks/                # captured in Step 3
└── ideas/                      # rep-flagged what-ifs
```

**Why "everything, daily" matters:** the OS only earns its keep if **a stakeholder like Alex** can ask *"why did we close [last big logo]?"* and Claude Code can answer it from real data — Avoma quotes, the Slack thread where the intro happened, the funding event 60 days prior, the CHRO hire 30 days before that. Same query for losses. **This is how we surface the top 1–2 GTM bottlenecks** — by letting the data speak when stakeholders query it themselves in Step 2, *not* by running a round of stakeholder interviews. The reps get the *output* of all this — a list of accounts to work, with context. The stakeholders get the *system* — a place to ask "why" and get an answer that isn't vibes.

**Delivery:** a written walkthrough ([`quickstart/1-installation-and-setup.md`](../quickstart/1-installation-and-setup.md)) covers Airbyte OAuth setup, the repo tree, and what each folder is for. Alex runs it once with me; runs it himself the second time.

Output: `mento-gtm/` repo live, Airbyte daily sync running, every artifact above flowing in with front-matter.

### Q: Second — how do you get stakeholders into Claude Code and pointed at the repo? (Weeks 2–3 → Step 3)

**A: Alex first, then anyone else who wants in as a stakeholder.** 1:1 onboarding session, ~45 min each, paired with the written walkthroughs in [`quickstart/`](../quickstart/) so the next stakeholder (or new hire) onboards themselves:

- Install Claude Code, install GitHub Desktop, clone `mento-gtm/`
- Open 2+ terminals — one for chat, one for repo work
- Show planning mode; show how Claude Code finds context across the repo on its own
- Run their first three starter prompts against *their own data*:
  1. *"Pull my last 5 won deals and tell me what they had in common — buyer role, trigger, time-to-close."*
  2. *"Rewrite my discovery playbook based on what actually shows up in the Avoma transcripts of those 5 wins."*
  3. *"Find every account on the 200-list that's had a CHRO hire or Series B+ funding in the last 90 days, ranked by how close it looks to my last 3 wins."*

Keep it simple at this stage — **no custom commands or skills yet**, just raw prompts. The point isn't tooling; it's the stakeholder getting a live look at their own data, asking questions, and seeing the system surface accounts they'd already flag (and one they wouldn't have). That's the trust-build moment.

**Custom skills and commands come next, *because* of these sessions.** When Alex says *"I want this 200-list signal-check to run every Monday morning"* — that becomes a one-line spec (*"build me X, here's why"*) which graduates into a real Claude Code skill or slash-command living in `mento-gtm/.claude/`. Those skills are the durable output of Step 2: starter prompts in week 1 → repeatable skills/commands by week 3 → spec inputs for Part 3 builds by week 4.

Output: Alex (and any other opted-in stakeholder) running prompts independently. Signal-trust list captured live in those sessions. Written walkthroughs shipped for repeatability. The first ~3 starter prompts that get reused enough get promoted into custom skills.

### Q: Third — how do you capture and prioritize bottlenecks? (Weeks 3–4 → Step 4)

**A:** Bottlenecks get captured **by looking at the data inside the repo** — not by running another round of stakeholder interviews. The work in Steps 1 and 2 already surfaced most of what we need; Step 3 is reading the lake and writing it down. `bottlenecks/` is a directory, not a single file — each bottleneck a node, schema'd the same way: *systems touched, problem, how measured, root cause hypothesis, desired outcome, priority score (impact × buildability × stakeholder-trust)*.

**Phase 0 — data archaeology, before anything else.** *Distrust the CRM labels first.* HubSpot will say a deal was "inbound demo request"; the lake will often show the CHRO was hired 45 days prior. The CHRO hire is the actual signal. Before ranking bottlenecks, cross-reference 8–10 won deals against what was *publicly true* about those accounts 6–18 months before close — funding state, headcount delta, exec turnover, careers-page churn. This is the input that makes the "outcome-backward ICP" in Part 2 honest, and it's the difference between *who is in the room* (filter) and *who is in pain right now* (segment).

What a Mento bottleneck *might* look like — illustrative, not predictive (the actual top 1–2 surface from the data + the people in this step):

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

Ranked. **This is the gate** — Part 3's signal workflow only earns the right to ship if it's the top-ranked bottleneck. If the audit surfaces a different #1 (say, intros dying in Slack threads, or playbook drift between reps), we build that instead.

Output: `bottlenecks/` ranked. The top item drives Part 3.

**Why this order, why we stop at Step 4:** Steps 5–7 (ship, roll out, attribute) only work if 1–4 are real. Most GTM-engineering hires get pulled straight to "build the signal workflow" and skip the foundation — system pumps wrong leads at reps who don't trust it, dies in month two. **Setting up the OS *is* the work of the first month.** That's why the timeline above runs weeks 1–4, not days. The OS earns its keep by being trustworthy before it's productive. Part 2 starts Step 5 (data foundation as the buildable layer); Part 3 ships the top-ranked bottleneck inside it — both happen in weeks 4–8 once the foundation is real.

## Q: What information would you need to gather in the first weeks?

**A:** Every GTM data source Mento touches, plus the context that explains *how* the team works today. **Rule: if Airbyte has a connector for it, it gets ingested.** I'm not asking anyone to *produce* anything new — just give me access. The table below covers the full stack.

| Need | Where it lives | Maps to step | What it unlocks |
|---|---|---|---|
| **Core CRM & comms** | | | |
| HubSpot full export + property audit | HubSpot | Step 2 ingest | Airbyte OAuth source #1 — accounts, contacts, deals, activities, properties, lifecycle stages |
| Avoma full library + API access | Avoma | Step 2 ingest | All-call transcript ingestion — the largest single source of buyer-voice data |
| Slack workspace access (deal channels, signals, customer threads) | Slack | Step 2 ingest | Captures the warm-intro mechanic that's closing deals today; flags rep coordination breakdowns |
| Email mailboxes (Alex + reps) | Gmail / O365 | Step 2 ingest | Outbound + inbound thread context; voice-of-rep samples for the drafter in Part 3 |
| Calendar | Google / O365 | Step 2 ingest | Meeting cadence, no-shows, account-touch frequency |
| **Outbound / pipeline gen stack** | | | |
| Sequencer (if one is in use) | SmartLead / Apollo / Outreach / Salesloft | Step 2 ingest | Step + reply data, sequence performance, bounce rates |
| Enrichment + signal tools | Clay, Crunchbase, Sumble, BlitzAPI, etc. | Step 2 ingest | What's already paid for; what we can reuse vs. need to add |
| 200-account list with attribution | Spreadsheet/HubSpot | Step 2 ingest | Reveals current ICP guess; reconciles against win patterns |
| **Marketing & web** | | | |
| Marketing automation (if any) | HubSpot Marketing / Mailchimp / Customer.io | Step 2 ingest | Lifecycle email touches, form fills, MQL definitions |
| Web analytics + page-level intent | GA4 / Plausible / Segment | Step 2 ingest | High-intent page hits per account (pricing, demo, integrations) |
| Ad platforms (if running paid) | LinkedIn Ads / Google / Meta | Step 2 ingest | Cost-per-meeting truth check; retargeting audiences |
| **Customer & post-sale** | | | |
| Customer success / coaching delivery platform | Mento's own product DB | Step 2 ingest | Usage signals, expansion triggers, churn-risk patterns (lookalikes feed ICP) |
| Support tickets / NPS | Intercom / Zendesk | Step 2 ingest | Customer-voice data for messaging; objection patterns |
| **Org & context** | | | |
| Tool subscriptions + seat counts | Alex / billing | Step 2 ingest | Defines budget + reuse for Step 5; flags overlap |
| Org chart + comp plan structure | Alex | Step 3 onboarding | How reps are measured today; what "pipeline" means to comp |
| Marketing/outbound's current motion + last 6 months of campaigns | Alex / Slack history | Step 4 capture | Determines whether we're displacing or augmenting |
| Reps' signal-trust list (warm-intro patterns, what they trust today) | Live in Step 3 onboarding | Step 3 | Gate for what's allowed to ship in Part 3 |
| Board decks + last 4 QBR slides | Alex / Drive | Step 2 ingest | Tells me what the company believes about itself — useful to reconcile against the lake |

**Why "everything Airbyte can pull"**: the OS is only as good as the substrate. If we miss the marketing automation, we can't tell whether a hand-raise was inbound or warmed by a campaign. If we miss the product DB, we can't build the lookalike-on-active-customers signal that's probably Mento's highest-conversion play. Cost is negligible (Airbyte's open-source connectors + Supabase). The constraint is access, not capacity.

## Q: What's the biggest risk to "something working in 60 days"?

**A: Not data quality. Adoption — getting stakeholders into the GTM OS and trusting it.**

Two compounding failure modes, both about humans:

1. **OS adoption** — if Alex and the reps don't actually open Claude Code and run prompts, the OS is a graveyard of well-organized files. Same risk as a Notion workspace nobody opens.
2. **Signal distrust** — even if the OS is alive, a two-rep team that has closed deals on instinct for two years will reject any system producing leads they don't recognize as "ours."

**Mitigation, embedded in the plan:**
- The written walkthroughs lower the terminal learning curve — that's the actual unlock.
- Step 2 (1:1 onboarding) gets each stakeholder running prompts against *their* data in their first session.
- Step 3 (bottleneck capture) makes reps co-authors of what gets built, not recipients.
- First ship in Part 3 is a bottleneck *they* ranked highest.
- HITL placement (rep approves draft, never auto-send) is a trust-earning mechanic.

**Stated assumption:** "Something working in 60 days" means *the OS is in active use by reps + Alex, and producing signal-driven meetings the team trusts*, not *a script runs on a cron*. The first interpretation requires this sequence. The second can be done in two weeks but won't survive month three.
