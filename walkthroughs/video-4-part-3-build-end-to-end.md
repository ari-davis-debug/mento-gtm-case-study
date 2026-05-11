# Video 4 — The Part 3 Build, End to End

> ~8 minutes · Audience: Alex (technical co-founder shape) · Goal: see how a top-ranked bottleneck becomes a shipped, eval-gated workflow

## What this video shows

Take the #1 bottleneck from video 3 — *no signal coverage on the 200-list* — and ship it inside the OS. **Spec → research → test → ship**, with HITL placement at the right point. By the end, a `trigger_events` table is filling with rows and the Slack-card hook is wired (video 5 is what the rep actually sees).

## Setup before hitting record

- The repo at the end of video 3 — three ranked bottlenecks
- Trigger.dev account already provisioned, but no jobs deployed yet
- BlitzAPI, Crunchbase, Sumble API keys in the Airbyte secrets manager
- Synthetic 200-list with 5 accounts that will fire signals during the recording (Glimmer, Outpost, Lithos, Conduit, Vesta) — pre-staged

## Beat-by-beat

### 0:00–0:45 — What we're shipping and why this build, not another

> *"Top bottleneck from video 3: Mento's 200-account list hasn't been re-scored against signals in 8 months. The shape we want: every account checked daily for funding, exec hires, headcount jumps, and L&D postings — triggers ranked, top-N delivered to the right rep in Slack, with a personalized draft ready to approve."*

> *"This is the build flow — Step 5 of the OS, 'agentic dev to ship solutions.' Three things matter: a one-paragraph spec, an eval gate before anything ships, and HITL at the draft, not the trigger."*

### 0:45–2:00 — The spec: one paragraph, written into the repo

Open Claude Code, type:

> *"Write me a spec for the signal workflow. Inputs: the 200-list + ICP ≥ 70 inbound. Outputs: top-10 priority queue per rep per day, delivered as a Slack card with verified contact and a personalized draft email. Constraints: deterministic scoring SQL, AI only for the draft and a short explanation paragraph, HITL at the draft, never auto-send, eval gate before draft pings the rep."*

Claude writes `specs/signal-workflow.md`. Open it on screen. Key sections it nails:

- **Stages** — Monitor / Enrich / Score / Route / Draft / HITL / Approve→CRM→Sequencer
- **The three lanes** — what runs as enrichment, what runs as SQL, what runs as AI
- **Eval gate** — LLM-as-judge against held-out won emails, threshold 0.85
- **Out-of-scope** — auto-send, multi-step nurture (SmartLead handles that)

> *"One paragraph from me. One spec from Claude. Reviewable, version-controlled, the source of truth for everything we ship in the next hour."*

### 2:00–3:30 — Research: which tools, picked from the lake

Type:

> *"For each signal source — funding, exec hires, headcount growth, L&D postings — propose a primary API and a cross-check. Justify each against the alternatives. No single point of failure."*

Claude pulls from the case study's tool research and returns:

| Signal | Primary | Cross-check |
|---|---|---|
| Series B/C/D | Crunchbase Pro webhook | The Org funding + TechCrunch RSS |
| Headcount ≥ 20% | Sumble | LinkedIn Firecrawl + Crunchbase employee tracking |
| New CHRO/CPO | The Org + Crunchbase people | LinkedIn announcement posts |
| L&D job posting | Sumble | Greenhouse + Lever board APIs |

> *"Notice — no signal rides on a single tool. Sumble could go down tomorrow and the system still fires. That's not paranoia; that's how you build a signal layer that survives a vendor outage."*

### 3:30–5:00 — Test: backtest before deploy

Type:

> *"Before we wire this live, backtest. For each of Mento's last 5 closed-won deals, replay the public signals that fired in the 90 days pre-close. Score them with the V0 weights. Confirm the top decile correlates with closed-won."*

Claude reads `data/hubspot/deals.snapshot.md` and `data/signals/`, runs the SQL:

```
Backtest — V0 trigger weights vs. closed-won
─────────────────────────────────────────────
Glimmer Health     priority=170  ←   won
Outpost AI         priority=145  ←   won
Lithos Bio         priority=128  ←   won
Conduit Labs       priority=118  ←   won
Vesta Robotics     priority= 96  ←   won

Top decile of all triggers in window: 89% closed-won
AUC: 0.83 (target ≥ 0.75)
```

> *"This is the test gate. If the SQL weights don't separate won and lost deals cleanly, the weights are wrong and we tune them before any rep sees a result. AUC of 0.83 clears the floor. Ship."*

> *"And before we deploy — the second eval. The LLM-as-judge against held-out won emails. 'Voice match, trigger specificity, lake-evidence grounded, length under 120 words, no AI tells.' Drafts under 0.85 retry with feedback before they leave the system."*

### 5:00–6:30 — Ship: Trigger.dev deploys the jobs

Switch to the Trigger.dev dashboard.

Show the four jobs that ship as one PR:

1. `monitor-crunchbase-webhook` — funding events
2. `monitor-the-org-daily` — exec hires
3. `monitor-sumble-daily` — headcount + L&D postings
4. `score-and-route` — runs after every `trigger_events` insert

Deploy with one command from the terminal:

```bash
cd mento-gtm/trigger
npx trigger.dev deploy
```

> *"Production deploy. The jobs run on Trigger.dev's infrastructure. We don't run a VPS. We don't monitor a cron. We don't host scrapers. Trigger.dev runs the schedule, retries on failure, and gives us observability for free."*

### 6:30–7:30 — HITL placement: why the draft, not the trigger

> *"Most signal-workflow builds put the rep in the loop at the wrong place — they want the rep to approve every trigger. That's approval fatigue. Reps will start ignoring it in week three. Then the system is dead."*

> *"We put the human in the loop at the *draft* — because reading a good draft is trust-building, but approving a trigger is chore-checking. Same hands-on, different feel."*

Show the Slack-card mock (video 5 shows the live thing):

- Priority + score breakdown
- Verified contact (BlitzAPI)
- Draft email preview
- Three buttons: Approve & Send / Edit / Skip

> *"The eval gate already filtered drafts under 0.85 — by the time the rep sees one, it's good. The rep's job is taste, not quality control. Taste is what reps are uniquely good at."*

### 7:30–8:00 — What just shipped, what's next

> *"In 8 minutes: spec written, tools picked with cross-checks, weights backtested against 5 won deals, eval gate locked at 0.85, Trigger.dev jobs deployed, Slack hook wired. The 200-list is being checked daily as of right now."*

> *"Video 5 is the moment a rep opens Slack and sees the first card. That's where this whole series earns its keep."*

## What the viewer walks away knowing

- **Spec, research, test, ship — four stages, one repo.** Every artifact lives in `mento-gtm/`.
- **Backtest before deploy.** AUC ≥ 0.75 against won deals or the weights are wrong.
- **Eval gate before HITL.** Drafts under 0.85 retry; the rep never sees a bad one.
- **HITL at the draft, not the trigger.** Trust comes from good drafts, not gated triggers.
- **Trigger.dev does the orchestration.** We don't run infrastructure for a 2-rep team.

## Common questions this video should answer

- *"Why Trigger.dev and not n8n?"* → Code-first. Version-controlled. Code review applies. n8n is the alternative for ops logic that needs to change weekly without a deploy — and we say so in Part 2 Q2.
- *"What if the AUC is below 0.75?"* → We don't ship. We tune the weights by hand against the won-deal cohort, re-test, and re-ship. The closed-loop monthly retrain (Step 7) is the long-term answer; weight bootstrapping is the short-term answer.
- *"What if a rep doesn't like the draft?"* → Edit button. The diff between the agent draft and the rep edit is the highest-quality training signal we get. Captured to `outcomes` and fed into the next eval-gate calibration.
- *"How do we know we're not over-fitting the backtest?"* → 20% holdout. Train weights on 80%, test on 20%. Detailed in Part 2 Q3. The video skips it for brevity; the math is in the doc.
- *"What's the cost of all this?"* → Trigger.dev free tier covers the deployment. BlitzAPI is the largest single cost ($499 email + $599 phone, unlimited). Crunchbase API and Sumble are seat-based — under $1K/mo combined. Detailed in Part 2 Q2.
