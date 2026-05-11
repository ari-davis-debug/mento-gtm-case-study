# Part 2 — Data Foundation Plan

> Mento GTM Engineer Take-Home

## How the scenario maps to the macro vision

Mento's scenario — *messy HubSpot, 5K contacts, missing firmographics, no scoring, no lifecycle rules, 200 dormant target accounts, Avoma transcripts, known buying signals* — reads like a build problem. **It isn't.** In Cetner's vision, it's a **substrate problem**: the data and the rules about the data aren't in a place we can work on them. Until that's fixed, every signal workflow (Part 3) lands on sand.

So Part 2 is the substrate. In plain English:

- **The lake** — a Supabase mirror of HubSpot + Avoma + Slack + enrichment, refreshed daily by Airbyte — is where Cetner says all the raw context belongs. *"Context is everything; perfect file systems don't matter as much as having it where Claude can find it."*
- **The rules** — dedupe logic, ICP scoring formula, lifecycle state machine — are what Cetner calls *ops models and playbooks*. Written-down answers to "how do we handle X," living in the repo as code, applied consistently.
- **The agents** that show up here (sanity-check before merges, score-explanation for reps, churn-signal surfacing) are early versions of Cetner's *agentic dev process*. They only make sense because the lake and the rules exist.
- **The closed-loop tuning** — wins and losses re-fit the scoring weights monthly — is the same closed-loop measurement Cetner makes the success metric of the whole pattern: *"you moved the constraint correctly when pipeline & revenue go up."*

### How the brief flows through that, line by line

| What Mento told us in the Slack message | Where it lives in the macro vision |
|---|---|
| *"HubSpot is a mess"* — 5K contacts, dupes, 40% missing firmographics | The **lake** mirrors HubSpot so we fix it without breaking the rep UI. Dedupe + enrichment **rules** sit in the repo as ops models. |
| *"No consistent lifecycle stage logic, no ICP scoring"* | These ARE the missing **playbooks**. Written here as a state machine (Q4) and a SQL scoring function (Q3). |
| *"~200 target accounts we've been meaning to activate"* | They sit in the **lake**, get ranked by the scoring **playbook**, and become the input to Part 3's signal workflow. |
| *"Call recordings in Avoma"* | Into the **lake** (Cetner names transcripts as ingestion content explicitly). Used to validate scoring weights against what reps actually heard on winning calls. |
| *"Coaching demand spikes when companies hit certain inflection points — funding, hiring, CHRO"* | Signals become both **score inputs here** (Q3 Tier 2) and **triggers in Part 3**. Same data, two consumers. |

**The honest read of the brief:** most candidates will skip straight to the signal workflow — that's the flashy Part 3 piece. Cetner's whole point is that skipping the substrate creates a *"house of cards."* That's why Part 2 is heavier than Part 3 in this submission on purpose.

### One-line summary of where each Q lives

- **Q1 (dedupe)** — rule lives in the repo, math runs in the lake, agent guards the writes, rep approves the merge.
- **Q2 (enrichment)** — the lake itself, plus the orchestrator (Trigger.dev / n8n) that fills it.
- **Q3 (ICP scoring)** — the targeting playbook, written in SQL, tuned monthly by win/loss data.
- **Q4 (lifecycle)** — the lifecycle playbook, written as a state machine, with closed-loop disqualification feeding back into Q3's weights.

---
>
> *The rule throughout: **deterministic logic owns the math; agents own interpretation, edge cases, and pattern surfacing.** Reps never see a black-box score. And **the math runs in Supabase, not in HubSpot** — HubSpot is the rep UI; Supabase is the system of record for derived data. That separation is what keeps the cleanup from decaying.*

## What this Part addresses (the dots)

1. **Dedupe rules** — detection, merge precedence, where it runs, write-time prevention
2. **Enrichment stack** — where data lives, which tools fetch it, what orchestrates the runs
3. **ICP scoring** — a transparent SQL function with weights tuned from win data, plus a bespoke / free signal layer
4. **Lifecycle state machine** — explicit transitions with a no-downgrade guarantee and closed-loop disqualification

## Assumptions

- HubSpot is the rep UI and stays that way. Reps never have to learn a new CRM.
- No objection to standing up Deepline + BlitzAPI + Crunchbase API at the budgets noted below.
- The win-audit from Part 1's Step 4 will produce real weight numbers for Q3 within the first 2 weeks. Until then, the v0 weights below run on the brief's stated ICP plus what's visible on mento.co.
- Mento can run a small VPS (DigitalOcean / Fly.io tier) for the orchestrator + the sanity-check agent. Trigger.dev is the default; n8n is an alternative if a non-coder needs to edit visually.

## A note on SQL — what it is, what it isn't, and what it does in this doc

**SQL = Structured Query Language.** The standard language for reading, writing, and computing on data inside a relational database. **Supabase is Postgres under the hood, and Postgres speaks SQL.** A SQL "job" in this doc is a *function* — math + data organization — running against tables that already live in Supabase. It reads from one or more tables, does its work, and writes the result to a target table or view.

### Two lanes — don't mix them up

| Lane | What it does | Tools | Example |
|---|---|---|---|
| **Enrichment** (pulls data IN) | Goes to an outside source, fetches data, lands it in a Supabase table | BlitzAPI, Crunchbase API, The Org, Sumble, Firecrawl | *"Call BlitzAPI for headcount → insert row into `account_context`"* |
| **SQL** (organizes data we already have) | Reads from Supabase tables, computes / joins / filters / scores, writes back to another Supabase table | Postgres SQL queries living in `mento-gtm/sql/` | *"Read `account_context` + `accounts` → compute `icp_score` → write to `accounts.icp_score`"* |

**SQL never fetches from the outside world.** That's enrichment's job. SQL only plays with rows that are already sitting in our tables. The dividing line is the Supabase boundary — anything crossing it is enrichment; anything staying inside is SQL.

### Why SQL (and not an AI call) for any of the math in this system

- **Deterministic** — same inputs produce the same output every time. An AI scorer drifts between calls.
- **Auditable** — a rep can read the query (or have Claude Code read it to them) and see exactly why a contact was deduped, scored 78, or moved between lifecycle stages. No black box.
- **Cheap + fast** — milliseconds against indexed columns. AI calls cost real time + dollars for arithmetic we don't need probabilistic reasoning on.
- **Versionable** — every query lives in `mento-gtm/sql/`. Weight or rule changes ship as PRs, reviewed before merge.

### How every SQL mention in this doc should read

The shape is always: **reads from `[table]` → does `[the math / organization]` → writes to `[table or view]`.** If a SQL mention isn't shaped that way, it's not SQL — it's enrichment (fetching from outside), an agent call (interpretation), or something else.

**Three lanes, no overlap: enrichment fetches, SQL organizes, AI interprets.** Dedupe, ICP scoring, lifecycle transitions, trigger scoring (Part 3) — all SQL. Pulling external firmographics, contacts, funding, headcount — all enrichment. Pattern recognition on edge-case merges, "why this qualified" summaries, voice matching for drafts (Part 3) — all AI. A rep can always trace any number on screen back to *which lane produced it and from which table*.

---

## Q1: What's the deduplication + merge logic?

**A:** Tiered detection runs as SQL in Supabase (email → LinkedIn URL → domain+name → phone). Merges follow explicit field precedence with a no-downgrade rule on lifecycle. ~95% auto-merge, ~5% pings Alex with context. A sanity-check agent gates every write so one bad merge can't poison the lake. Detail below.

**Plain English:** "Deduping" means collapsing duplicate contacts into one record. Same person ends up in HubSpot 5 times — once from an event, once from a website form, once because a rep added them manually, once from a Clay import, once with a typoed email. That's 5 rows, 1 person. Dedupe = merge them into 1 row that keeps the best data from each.

### Detection (deterministic, runs as SQL in Supabase)

Tiered match — first hit wins. Plain English:

1. **Same email after normalizing** — case-insensitive, plus-strip (`ari+test@gmail.com` and `ari@gmail.com` are the same person)
2. **Same LinkedIn URL after stripping tracking params** — most reliable identity match we have
3. **Same email domain + similar-enough name** — `Ari Davis @ acme.com` and `A. Davis @ acme.com` count as the same person if their names are ≥ 85% character-similar (Levenshtein distance — "how many edits to turn one into the other")
4. **Same phone number in standard international format** (E.164) — last-resort match

### Merge — field precedence (the part most teams skip)

When two records merge, *which field from which record wins?* Without this rule the merged record is garbage:

| Field | Wins | Loses |
|---|---|---|
| Email | Most-recent verified > manual entry > scraped |
| Title / role | Enrichment timestamp < 90d > self-reported > inferred |
| Company | HubSpot deal-association > enrichment > form submission |
| Lifecycle stage | **Never downgrades on merge** — highest stage wins |
| Activity history | Union (keep all rows, dedupe by timestamp) |
| Notes | Concatenate with attribution |

### How dedupe actually runs (concretely)

**Reps don't see this.** Dedupe is infrastructure plumbing — it runs in the lake (Supabase), agent-gated. The rep's HubSpot UI only changes when verified clean records get pushed back. The only time a human gets pinged is when a proposed merge touches a Customer or Opportunity — and even then it's Alex / RevOps, not a quota-carrying rep.

```
┌──────────────────────────────────────────────────────────────────┐
│  Step 1 — Supabase SQL job (the math)                             │
│  Runs nightly. Scans the contact mirror, applies tiered match,    │
│  produces a PROPOSED-CHANGES queue (no writes yet):                │
│    • Auto-merge candidates (exact email, no field conflicts)      │
│      → ~70% of dupes                                              │
│    • Review queue (fuzzy matches, conflicting fields)             │
│      → ~30%, written to repo as `dedupe_review/<batch>.md`        │
└──────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────┐
│  Step 2 — Sanity-check agent (the only gate that matters)         │
│  Wraps every proposed change before any DB write. Asks:           │
│    • Does the merge respect field precedence?                     │
│    • Does it violate the no-downgrade rule on lifecycle?          │
│    • Does it merge across companies (different domains)?          │
│    • Does it touch a Customer or Opportunity?                     │
│  Outputs APPROVE / REJECT / ESCALATE.                             │
│    APPROVE → writes to Supabase, then verified record syncs       │
│             back to HubSpot (custom-property update).             │
│    REJECT  → drops the proposal, logs reason.                     │
│    ESCALATE → Customer/Opp touched OR genuinely ambiguous —       │
│              pings Alex in Slack with the diff + suggested action │
│              (this is the ONLY rep/stakeholder touch in dedupe).  │
└──────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────┐
│  Step 3 — Claude Code writes context for escalations              │
│  For the ~5% of cases that escalate, Claude reads the pair and    │
│  writes 2 lines of plain English on the Slack card:               │
│    "Same LinkedIn URL, email variation, title changed —           │
│     looks like a job change. Suggest merge with company=newer."   │
│  Alex clicks ✅ or ✏️ in Slack. Decision logged.                  │
└──────────────────────────────────────────────────────────────────┘
```

**The point:** ~95% of dedupe is automatic and the rep never sees it. The ~5% that touches real money (Customer or Opportunity records) pings Alex with enough context to decide in 30 seconds. The sanity-check agent (small VPS, ~$10/mo) is what makes the automatic 95% safe — one bad auto-merge of a Customer record poisons the whole system, so we gate every write.

**One-time vs. ongoing:**
- **One-time backlog clean** — Layer 1 runs once on the existing 5K (estimated 10–20% dupes based on typical event-list bloat at this size). Backlog cleared in a few days, with the sanity-check agent catching anything weird before any real write happens.
- **Ongoing prevention** — write-time hook on form submissions and CSV imports. A Trigger.dev job receives every new contact, runs the same tiered match against Supabase *before the write hits HubSpot*. Catches dupes at the boundary, not after. **This is the prevent-it-in-the-first-place layer — what stops the entropy from coming back.**

---

## Q2: What enrichment sources + tools, and what orchestrates them?

**A:** Airbyte mirrors HubSpot + Avoma + Slack into Supabase (the lake). Deepline orchestrates an enrichment waterfall across BlitzAPI (contacts + firmographics + email/phone), Crunchbase (funding), The Org (org chart), Sumble (headcount + L&D). Trigger.dev runs the schedule; n8n is the alternative for visual editing. Verified fields push back to HubSpot through the same sanity-check agent. Detail below.

### The lake pattern — non-negotiable

```
HubSpot ────────────┐
Avoma ──────────────┤
Slack ──────────────┼──► Airbyte ──► Supabase (lake) ──► enrichment + scoring jobs (Trigger.dev)
Deepline ───────────┤                       │
BlitzAPI ───────────┤                       │
Crunchbase ─────────┘                       │
                                            ▼
                          verified fields pushed back to HubSpot as custom properties
                                  (gated by the sanity-check agent)
```

HubSpot is the rep UI. Supabase is the system of record for derived data. **Math doesn't happen in the CRM** — it happens in Supabase, then verified outputs push back to HubSpot. That separation is what keeps the cleanup clean.

### Tools, named with reasoning for Mento's stage

| Tool | Layer | Why for Mento |
|---|---|---|
| **Deepline** | Waterfall orchestrator (CLI / API across 31+ providers, writes directly to Supabase, runs in cloud) | "Clay in the terminal" — writes directly to *our* Supabase, no export fees, lives next to the repo. Pairs cleanly with the OS shape from Part 1. Confirmed it can deploy to cloud and run automatically. |
| **BlitzAPI** | **Primary contact-finder + email/phone enrichment** (called inside the Deepline waterfall) | Has its own ICP-driven contact-discovery waterfall — *better than Apollo for the 500–5K tech segment Mento sells into*. Flat $499/mo email + $599/mo phone, unlimited. Predictable cost beats credit-burn pricing at this contact volume. Replaces Apollo entirely; no need for a second contact-discovery tool. |
| **Crunchbase API** | Funding events | Webhook gives same-day signals on Series B/C/D announcements — the ICP trigger that matters most for Mento. |
| **LinkedIn Sales Nav** (manual) | CHRO / VP People hires, layer-3 director changes | No clean API; reps verify in-platform until budget for BuiltWith / TheirStack opens. |
| ~~ZoomInfo~~ | — | Skip at this scale. Cost-to-marginal-value is wrong below 50 reps. |
| ~~Apollo~~ | — | Replaced by BlitzAPI's contact-finding waterfall. One tool, predictable pricing, better fit for the segment. |

### What actually runs the enrichment jobs

"Orchestration" just means *the thing that wakes up the enrichment scripts on a schedule, retries them if they fail, and tells us when something breaks.* Two options, pick by audience:

| Option | When to use | Why |
|---|---|---|
| **Trigger.dev** (default) | Anything code-first that lives in the repo | TypeScript jobs deployed from `mento-gtm/`. Version-controlled, code review applies, retries + observability built-in. The right home for production jobs that shouldn't change weekly. |
| **n8n** (alternative) | Anything Alex needs to edit visually without code | Self-hosted on a small VPS (~$12/mo). Drag-and-drop "if-this-then-that" workflows. Use for ops logic that changes weekly and shouldn't require a deploy. |

### How it runs over time

- **Nightly Trigger.dev job:** re-enrich any record where `last_enriched_at > 30d` OR null
- **Real-time Crunchbase webhook:** funding events trigger immediate re-enrichment + ICP-score recompute
- **Sanity-check agent gate:** every enrichment write goes through the same VPS agent introduced in Q1 — same logic, different field set. Stops a bad enrichment run from poisoning the lake.

---

## Q3: How would you define ICP fit in data terms?

**A:** Outcome-backward, in two phases. **V0 (day one)** = one SQL formula with two tiers — firmographic filter + bespoke Mento boost (lookalike, Glassdoor, exec posts), threshold ≥ 70 routes to a rep. **V1 (month 6)** = per-archetype scoring (Hypergrowth-Promotion-Lag, New-CHRO-Mandate, Manager-Density-Break), each archetype gets its own SQL function, highest match wins. V1 only ships if it beats V0 on a held-out 20% of won deals. Detail below.

### What "outcome-backward" actually means, in plain English

Most ICPs work *forward*: pick traits (headcount 500–5K, software, recent funding), filter for them, call it your ICP. That's an Apollo search, not an ICP. It tells a rep *who's in the room* — not *who's about to buy*.

**Outcome-backward flips the direction.** Take the deals Mento has *already closed* — Brex, Vercel, SoFi, Anthropic, Gusto. For each one, go back to their *public footprint 6–18 months before they signed*:

- What was their headcount then?
- What had just happened? New CHRO? Series C? Big org restructure?
- What were their job postings hinting at? *"Build out manager training"?*
- What was their Glassdoor saying? *"Promotions are slow, no career growth path"?*
- What had execs been posting about on LinkedIn?

Cluster those *prior states* into 2–3 patterns. **Those patterns are the real ICP.** Today's lookalikes — accounts that match one of those prior states *right now* — are who's about to buy. Same logic the win-audit in Part 1 Step 4 sets up; this is where it lands as math.

The Avoma calls feed this too: what reps heard on winning discovery calls (*"our directors are drowning,"* *"the new CHRO wants something running by Q3"*) becomes the qualitative validation for the quantitative signals we reconstruct from public data.

### Two versions of the ICP, sequenced — ship V0 today, replace it with V1 after the win-audit

(V0 / V1 = *version 0 / version 1*. Same scoring function, same SQL, just upgraded once we have real won-deal data to learn from. We ship in two phases because Mento doesn't yet have the volume to do the better thing on day one.)

- **V0 — Version 0, day one — the firmographic filter.** One SQL formula. Run nightly in Supabase. Checks the obvious boxes: headcount 500–5K, fast-growing tech, recent funding, growing director layer, open L&D role. Admittedly an Apollo-style filter. We ship it because *a filter that's 70% right beats no scoring at all in week one.* **It's the floor, not the answer.**
- **V1 — Version 1, month 6 — outcome-backward archetypes.** Same Supabase, but now *multiple* SQL functions — one per archetype. Once the win-audit produces real cohorts (~30 wins + ~60 losses, realistic by month 6), cluster the wins into 2–3 **archetypes**. Each archetype gets its own scoring rubric. An account is scored against all three and the **highest match wins**. Mento's likely candidates:
  - **Hypergrowth-promotion-lag** (Vercel-shaped) — headcount doubled, director layer flat, manager span > 8.
  - **New-CHRO-mandate** (post-Series-C-shaped) — CHRO/VP People hired in last 90d *and* L&D req opened within 60d after.
  - **Manager-density-break** (Brex '23-shaped) — 20%+ headcount growth + Glassdoor "career growth" sub-3.0 + open L&D role.
- **The handoff rule — 20% holdout.** When we build V1, we hold out 20% of the won/lost deals from training. The held-out set must show *measurable lift over V0* before V1 ships. This is what kills the *"company-name-starts-with-vowel"* failure mode (over-fitting to wins you already have so the model looks great until it meets new accounts). The day V1 beats V0 on held-out wins, V0 dies and V1 takes over.

**The short version:** V0 = one rough formula we ship Monday. V1 = three sharper formulas we ship after we've seen enough closed deals to know what actually correlates with winning. Same plumbing, smarter rules.

### V0 scoring as a deterministic SQL function — two tiers, one number

V0 has two parts that both run as SQL in Supabase. Tier 1 = standard firmographic signals from the brief. Tier 2 = bespoke Mento signals (lookalikes, Glassdoor, exec posts) — these *contribute points*, they don't just live as agent flags. Total `icp_score = tier_1 + tier_2`. Threshold ≥ 70 routes to a rep.

> *Read this SQL as V0 scaffolding, not the destination.* It is the explicit filter — what we run on day one. V1 replaces it with per-archetype discriminators tuned against held-out wins.

```sql
-- runs nightly across the lake; result lands as `icp_score` on each account

-- ───── Tier 1 — firmographic (standard signals from the brief) ─────
icp_score_firmographic =
    CASE WHEN headcount BETWEEN 500 AND 5000 THEN 25 ELSE 0 END
  + CASE WHEN industry IN ('software','fintech','infra','security','dev-tools') THEN 15 ELSE 0 END
  + CASE WHEN last_funding_round IN ('B','C','D')
         AND last_funding_date > NOW() - INTERVAL '180 days' THEN 30 ELSE 0 END
  + CASE WHEN headcount_growth_180d_pct >= 20 THEN 20 ELSE 0 END
  + CASE WHEN chro_or_vp_people_or_l_and_d_hired_last_90d THEN 40 ELSE 0 END
  + CASE WHEN open_l_and_d_roles > 0 THEN 20 ELSE 0 END
  + CASE WHEN new_director_layer_last_90d THEN 15 ELSE 0 END;     -- manager-density signal

-- ───── Tier 2 — bespoke Mento signal boost (free / public sources) ─────
icp_score_boost =
    CASE WHEN lookalike_score_to_named_customers >= 0.7 THEN 10 ELSE 0 END
  + CASE WHEN glassdoor_career_growth <= 3.0
         AND headcount_growth_180d_pct >= 20 THEN 8 ELSE 0 END
  + CASE WHEN exec_post_about_manager_dev_last_30d THEN 5 ELSE 0 END
  + CASE WHEN portfolio_in IN ('YC','a16z','Tiger')
         AND last_funding_date > NOW() - INTERVAL '180 days' THEN 10 ELSE 0 END
  + CASE WHEN conference_attendee_last_12mo THEN 5 ELSE 0 END;

-- ───── Total ─────
icp_score = icp_score_firmographic + icp_score_boost;
-- threshold: >= 70 = ICP, route to rep; 40-69 = nurture; <40 = drop
```

### What the SQL actually says, in plain English

Read it as a list of *"if this is true, add N points"* checks:

| Check | Points | Why this weight |
|---|---|---|
| Headcount between 500 and 5,000 | **+25** | Mento's stated sweet spot. The brief's first sentence. |
| Industry is software / fintech / infra / security / dev-tools | **+15** | Mento's named customers (Brex, Vercel, Anthropic) all live here. |
| Just raised Series B / C / D in last 180 days | **+30** | Biggest single trigger — fresh money = new headcount = new manager problems |
| Headcount grew ≥ 20% in the last 6 months | **+20** | Growth that outpaces leadership development = the wedge |
| CHRO / VP People / L&D head hired in the last 90 days | **+40** | The most predictive single signal — new exec = new mandate to spend |
| Has open "L&D" / "Leadership Development" job postings | **+20** | They've already admitted they need help — in public |
| Layer-3 director count grew in the last 90 days | **+15** | Manager-density signal — they're stretching their org chart |
| **+ Tier 2 boost** (lookalike, Glassdoor, exec posts, portfolio, conferences) | +0 to +38 | Bespoke Mento signals, see table below |

Total can go from 0 to ~200. **≥ 70 = route to a rep**, 40–69 = nurture, < 40 = drop.

**Why two tiers, not one big formula:** keeps the bespoke Mento signals visible. When a stakeholder asks *"this account scored 78 — what got it there?"* the answer is `Tier 1 = 65 (Series B + headcount growth + 1 open L&D role) + Tier 2 = 13 (Vercel-shaped lookalike + Glassdoor signal)`. Transparent, audited, tunable.

**Why deterministic, not agentic:** the rep *must* be able to ask "why did this account score 85?" and see the contributing fields. Black-box LLM scoring destroys trust the moment a rep disagrees with a result they can't audit. Same logic as why we don't auto-send: transparency is a feature.

### Where the bespoke signals come from

| Signal | Source | Field name in Supabase |
|---|---|---|
| Lookalike to named Mento customers (Dropbox / Brex / Vercel / Anthropic / SoFi / DoorDash / Gusto / Intercom) | Cohort similarity (firmographics + tech stack) computed in Supabase against named-customer feature vectors | `lookalike_score_to_named_customers` |
| Glassdoor "career growth" rating | Free public scrape | `glassdoor_career_growth` |
| New layer-3 director hires (manager density) | LinkedIn Sales Nav delta tracking | `new_director_layer_last_90d` |
| Exec posting about manager development on LinkedIn | LinkedIn org content scrape (last 30 days) | `exec_post_about_manager_dev_last_30d` |
| YC / a16z / Tiger portfolio company with recent funding | Crunchbase Pro filters | `portfolio_in`, `last_funding_date` |
| Conference attendee (HR Tech, ATD, LearningSpark) | Public attendee lists, last 12 months | `conference_attendee_last_12mo` |

### Where the agent layer sits — explanation, not point-adding

The agent doesn't add points. The math is SQL. The agent does two things SQL can't:

1. **Plain-English score explanation** — when a rep opens an account, an agent reads the contributing fields and writes a 1-paragraph explainer: *"Scored 78. Driving factors: Series B 6 weeks ago (+30), L&D role open (+20), CHRO hired in March (+40 *not* triggered — hire was 110 days ago), Vercel-shaped fintech (+10 lookalike), Glassdoor 2.8 + 30% headcount growth (+8). One miss: no exec posts about manager dev in last 30d."*
2. **Edge-case escalation** — surfaces accounts scoring 45–69 with strong qualitative signals — *"this account scores 52 but their VP of Eng just posted about manager-development on LinkedIn this week"* — into a separate rep queue. Pattern recognition is what agents are good at; scoring math isn't.

### How V0 turns into V1 — outcome-backward, with a holdout

Every time a deal closes-won or closes-lost, the row goes into a `deal_outcomes` table with the full lake snapshot at *T-180d, T-90d, T-30d, T=close*. Once we have ~30 wins + ~60 losses (realistic by month 6 given Mento's deal velocity):

1. **Reconstruct ground truth.** For each won account, what was true in their *public* data 6–18 months before close? Funding state, headcount delta, exec turnover, careers-page churn, Glassdoor inflection, exec posts. Distrust the CRM labels — Phase 0 of the win-audit is *data archaeology*, not model fitting. (CRM says "inbound demo request"; the lake often shows a CHRO hire 45 days prior. The CHRO hire is the actual signal.)
2. **Cluster the wins into archetypes.** Not one ICP — 2 or 3, each with its own discriminator. Use the archetype hypotheses above as priors; let the data confirm or kill them.
3. **Per-archetype scoring rubric.** Each archetype gets its own SQL function. An account can match more than one archetype; the highest match wins the routing decision.
4. **Hold out 20%.** Train on 80%, score the held-out 20%. If lift on held-out wins isn't materially better than V0's filter, the model isn't real yet — keep V0 running. **No model ships without held-out lift.**
5. **V0's tier weights get re-fit monthly** in the meantime (logistic regression in Supabase against the wins/losses cohort) — the function stays SQL, the weights become data-driven instead of vibes-driven, and the V0 score keeps reps moving until V1 earns the handoff.

The mechanic that matters: **filter says "who's in the room," archetype says "who's in pain right now."** V0 is the filter. V1 is the archetype. Part 3's signal workflow is the *operational* version of those archetypes — funding + headcount + exec-hire correlation in 90d isn't a generic trigger, it's the new-CHRO-mandate archetype catching fire in real time.

---

## Q4: How should we define lifecycle stages going forward?

**A:** Borrow the SiriusDecisions Demand Waterfall pattern: each stage has a single, machine-checkable entry condition. Lead → MQL auto (icp_score ≥ 70). MQL → SQL HITL (rep accepts). SQL → Opp auto (deal record created). Opp → Customer auto (closed-won). Any state → Disqualified with structured reason that feeds back into ICP weight retuning. **No-downgrade rule** — lifecycle is forward-only; exits go through Disqualified. Agents sit on top of the state machine for interpretation (MQL→SQL helper, churn-risk surfacer, re-evaluation surfacer, drift detector). Detail below.

### Plain English first

A "lifecycle stage" in HubSpot is the journey state of a contact:

| Stage | What it means | Example |
|---|---|---|
| **Lead** | Just exists in the system | Someone who downloaded a whitepaper or attended an event |
| **MQL** (Marketing Qualified Lead) | Did something interesting + fits ICP | Score crossed your ICP threshold OR replied to a nurture email |
| **SQL** (Sales Qualified Lead) | A rep has talked to them and thinks they're real | Discovery call booked, real fit confirmed |
| **Opportunity** | A deal record exists ($ + close date in HubSpot) | Pricing conversation started |
| **Customer** | Closed-won, paying | Contract signed |
| **Evangelist** | Customer who refers others | Mento has lots of these from the warm-intro motion |

**Why it matters:** without rules, the field is decorative — you can't filter "show me all SQLs from last quarter" because nobody agrees what makes one. With rules, the pipeline becomes measurable.

### This is a common B2B problem — here's the canonical fix

What Mento has is the **canonical B2B CRM hygiene problem.** Every B2B company that grew fast without a RevOps function ends up here: one rep marks "MQL" after a meeting books, another marks it on whitepaper download, a 2-year-old HubSpot workflow auto-sets it on form submit. The field becomes decorative — you can't trust "show me all SQLs from last quarter" because nobody agrees what makes one.

The standard fix is borrowed from the **SiriusDecisions Demand Waterfall** (the RevOps-canonical playbook used at most B2B companies): each stage has a single, explicit, machine-checkable entry condition. Either the system can prove a contact meets it (auto-transition) or a human says yes once (HITL transition). No vibes-based setting. Transitions are one-way except through an explicit Disqualified exit.

For Mento, the entry conditions look like this:

### State machine + transitions

```
                           [auto / agent flag]
   ┌─────┐  icp_score≥70 +  ┌─────┐  rep accepts  ┌─────┐
   │Lead │ ───────────────► │ MQL │ ────────────► │ SQL │
   └─────┘                  └─────┘    [HITL]     └─────┘
                                                      │
                                              deal record created
                                                      ▼
                                                ┌──────────┐
                                                │   Opp    │
                                                └──────────┘
                                                      │
                                                 closed-won
                                                      ▼
                                                ┌──────────┐
                                                │ Customer │
                                                └──────────┘

  ┌────────────────┐   any state, with reason field (rep-set)
  │ Disqualified   │ ◄────────────────────────────────────────
  └────────────────┘   (reason feeds back into scoring weights)
```

### Rules

| Transition | Trigger | Owner |
|---|---|---|
| Lead → MQL | `icp_score ≥ 70` AND has email | Auto (deterministic) |
| MQL → SQL | Rep accepts in HubSpot | Rep (HITL — never auto) |
| SQL → Opportunity | Deal record created | Auto |
| Opportunity → Customer | `closed-won` | Auto |
| Any → Disqualified | Rep marks with `disqualification_reason` | Rep |
| Customer → at-risk flag | Score drops below 70 → **doesn't downgrade lifecycle**, flags for CS | Auto (signal, not state change) |

### No-downgrade rule

Lifecycle doesn't ricochet. A Customer whose score drops doesn't go back to MQL — they get a churn-risk *signal*. A merge between a Lead and a Customer keeps the Customer state. **Lifecycle is forward-only; exits go through Disqualified.** This is what "no clear rules" actually breaks; the fix is "the state only goes forward."

### Closed-loop learning

`disqualification_reason` is structured (dropdown: *not-ICP-fit*, *not-now*, *competitor*, *no-budget*, *bad-data*). Monthly Trigger.dev job correlates dq reasons with `icp_score` components — finds where the scoring is over- or under-weighting. Feeds back into Q3.

### Where the AI-native layer sits — agents on top of the state machine

The state machine itself is deterministic (a Customer can't accidentally become an MQL). The agents sit on top of it, doing the things SQL is bad at — reading context, summarizing reasons, surfacing patterns. None of them *move* a contact across stages without a human approving; they make the human's decision a 30-second click instead of a 10-minute investigation.

| Agent job | What it does | Where it sits in the lifecycle |
|---|---|---|
| **MQL → SQL helper** | When a Lead crosses `icp_score ≥ 70`, an agent reads the contact's activity, fit signals, and Avoma transcripts (if any), and writes a 2-line brief: *"This is a real SQL because Series C 6 weeks ago + L&D role open. Suggested talk track: their CHRO posted about manager development on Tuesday."* | Sits on the Lead → MQL → SQL transition. Rep clicks ✅ in HubSpot or Slack. |
| **Disqualification-reason drafter** | When a rep marks Disqualified, an agent reads the latest email reply or Avoma snippet and proposes a structured reason + 1-line justification. Rep edits in place. Stops the *"no-reason / bad-data"* default that ruins the closed-loop. | Sits on the Any → Disqualified transition. |
| **Churn-risk surfacer** | Daily job re-scores Customers. Agent flags: *"these 12 Customers' scores dropped below 70 in last 30d — funding round + headcount stall on each. Possible churn signal."* Routes to CS, not sales. | Sits on Customer (no state change — produces a churn-risk *signal*). |
| **Re-evaluation surfacer** | Daily job scans Disqualified contacts. Agent flags: *"these 8 Disqualified contacts now have a new CHRO — worth re-evaluating."* Routes back to the rep that DQ'd them. | Sits on Disqualified (no automatic re-activation — rep decides). |
| **Drift detector** | Monthly job. Correlates `disqualification_reason` distributions with `icp_score` components. Agent writes: *"Of the last 30 DQs, 14 cited 'not-now' but had score ≥ 70 and headcount growth — the score may be under-weighting timing signals."* | Sits across the whole pipeline. Output feeds Q3's weight retuning. |

**The pattern across all five:** deterministic rules own the state machine; agents own the interpretation and the routing. Same shape as Q1 (sanity-check agent gates writes) and Q3 (agent explains scores, doesn't add points).

---

## Bridge to Part 3

This is the substrate. Inside the OS from Part 1, with the bottlenecks captured in Step 4, a rep flags one as the highest priority — say, *"we're missing CHRO hires on the 200-list because nobody's checking weekly."* Part 3 ships exactly that, on top of this foundation: the scoring function from Q3 ranks the alerts, the lake from Q2 stores the signals, the dedupe logic from Q1 keeps the alerts clean, the lifecycle from Q4 determines who gets pinged. Trigger.dev runs the schedule; Deepline + BlitzAPI + Crunchbase fill in the data; Claude Code drafts the outreach inside the OS for rep approval.

Now to Part 3.
