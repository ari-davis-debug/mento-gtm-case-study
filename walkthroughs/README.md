# Walkthroughs — a live representation of the 7-step OS, walked one step at a time

> Each walkthrough is one stretch of the 7-step OS, run on Mento's own data. The point isn't to install a production stack — it's to **walk the OS live** and feel what it does for you.

## What this folder is

The case study answers *what* to build. The `gtm-os/` folder answers *why this shape*. **This folder is the OS, walked through one step at a time on real data.** Three walkthroughs, each lining up with the first four steps of the OS — the foundation half. Steps 5–7 are execution work I'd run once embedded, not something Mento needs to set up themselves.

```
Walkthrough           OS step(s) it walks
─────────────────────────────────────────────────────
1. Get your data       ─►  Step 1 (Repo) + Step 2 (Data daily)
   queryable
2. Play with your      ─►  Step 3 (Stakeholders in Claude Code)
   data
3. Let the data tell   ─►  Step 4 (Capture + prioritize
   you what's broken       bottlenecks)
```

## The OAuth unlock — what this whole thing buys you

Once Airbyte mirrors HubSpot, Avoma, and Slack into Supabase via OAuth, **a stakeholder can ask things in plain English that used to take a week of manual work:**

- *"Why did we close [last big logo]?"* — and Claude reads the Avoma quotes, the Slack thread where the intro happened, the funding event 60 days prior, the CHRO hire 30 days before that, and tells you.
- *"What did my last 5 wins have in common?"* — buyer role, trigger event in the 90 days before close, time-to-close.
- *"Which accounts on the 200-list look like my last 3 wins?"* — ranked by trigger + lookalike.
- *"What pain shows up in the Avoma calls of every won deal that ISN'T in the discovery playbook?"* — rewrite the playbook from real evidence.
- *"Which deals have stalled in the same Slack channel for >14 days?"* — the warm intros dying in threads.

**Same query for losses.** Same query for any account, any signal, any time-window. That's the OS earning its keep on day one — *not* by automating anything, but by making everything Mento already has *answerable.*

## The three walkthroughs

| # | Walkthrough | OS step | What it unlocks |
|---|---|---|---|
| 1 | [Get your data queryable](./1-installation-and-setup.md) | Steps 1 + 2 | Foundation stack live: terminal, repo, Airbyte daily sync into Supabase. **The lake is queryable.** |
| 2 | [Play with your data](./2-first-prompts-in-claude-code.md) | Step 3 | Three starter prompts across HubSpot + Avoma + Slack on real Mento data. **Stakeholders are inside the system.** |
| 3 | [Let the data tell you what's broken](./3-bottleneck-capture.md) | Step 4 | Bottlenecks ranked from the lake, not from interviews. **You know what's worth building.** |

After these three, you've walked steps 1–4 of the OS live. **You've seen the foundation work on your own data.** Steps 5–7 — agentic dev to ship, rollout to reps, closed-loop measurement — are execution work I'd run once embedded. Those are sketched in the case study (Parts 2 and 3) and the `gtm-os/` folder, not here.

## Why only the foundation half

Two reasons:

1. **The foundation is the half that's usually skipped.** GTM-engineer hires jump to "build the signal workflow" and skip 1–4. That's the failure mode. These three walkthroughs make sure Mento *sees* the foundation working before anyone commits to building on top of it.
2. **Steps 5–7 require real reps, real deals, real revenue lift.** You can't fake that in a take-home. The shape of them is documented (`gtm-os/step-5`, `step-6`, `step-7`) — the doing of them is what I'd do once hired.

## The foundation stack — two required tools, one optional level-up

**Required:**

| Tool | What it does |
|---|---|
| **Claude Code** | The workbench. Reads the repo, edits playbooks in-context, runs SQL when you wire a data lake. |
| **GitHub** | Version control for the repo. Every playbook, signal rule, bottleneck is a file. |

That's the minimum. Drop CSVs / transcripts / decks into `mento-gtm/data/` and walkthroughs 2 and 3 work fine.

**Optional level-up (when you want a daily data lake instead of manual exports):**

| Tool | What it does |
|---|---|
| **Airbyte** | OAuth-based daily sync of HubSpot, Avoma, Slack. 350+ connectors. |
| **Destination** (Supabase / BigQuery / Postgres / flat files) | Where Airbyte writes. Supabase is fastest to wire up; BigQuery scales better; flat files back into the repo work too. Pick the one closest to how the team already operates. |

**What's NOT in the foundation:** Trigger.dev, SmartLead, BlitzAPI, Crunchbase, Sumble. Those only matter *if* you decide to operationalize one of the bottlenecks walkthrough 3 surfaces — that's an execution decision (OS steps 5–6), not a foundation one.

## How each walkthrough is structured

- **What this walkthrough covers** — one-sentence promise
- **Setup / what you need** — prerequisites
- **Step-by-step** — commands, SQL, prompts, expected output
- **What you've unlocked** — the takeaway
- **Common questions** — the FAQ that means there isn't a fourth walkthrough

## What's NOT in this folder

- Code (would live in `mento-gtm/` once built — this is the case study, not the build)
- Real Mento data (we haven't seen any — examples are synthetic / clearly labeled)
- Walkthroughs for OS steps 5–7 (execution work, not foundation; sketched in case study + `gtm-os/`)
