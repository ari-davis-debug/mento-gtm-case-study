# Video 2 — First Prompts in Claude Code

> ~6 minutes · Audience: Alex (and any opted-in stakeholder) · Goal: stakeholder runs 3 starter prompts against their own data

## What this video shows

By the end of 6 minutes, Alex has Claude Code installed, the `mento-gtm/` repo open, two terminals running, and three prompts answered against his own data — including one that surfaces an account he wouldn't have flagged on his own.

## Setup before hitting record

- Claude Code installed but not yet opened (will install on camera)
- `mento-gtm/` repo already cloned in `~/code/mento-gtm/`
- GitHub Desktop installed
- Synthetic-but-realistic Mento data loaded (or Alex's real data if he's the recorder)
- Terminal app of choice ready to split into 2 panes

## Beat-by-beat

### 0:00–0:30 — Why we're here

> *"In video 1 we lit up the data. The system is useless until somebody opens it and asks it something. This video is Alex's first 6 minutes inside Claude Code. The goal isn't to teach Claude Code — the goal is to show Alex that the OS already knows things he doesn't."*

### 0:30–1:30 — Setup, fast

Show in one minute:

1. **Install Claude Code** — `curl ... | sh` or the one-line install. Cut to it being done.
2. **Open the repo** — `cd ~/code/mento-gtm/` then `claude` to start a session.
3. **Open a second terminal pane** — one for chat, one for repo work (running SQL, editing files, etc.).
4. **Mention planning mode** — *"if you ever want Claude to think before it acts, type `/plan`. We'll use it in video 4 when we ship something."*

Skip the rest of the Claude Code tour. The point isn't tooling; it's the first prompt.

### 1:30–3:00 — Prompt 1: "What did my last 5 wins have in common?"

Type into Claude Code:

> *"Pull my last 5 closed-won deals and tell me what they had in common — buyer role, trigger event in the 90 days before close, time-to-close."*

Let the screen do the work. Claude reads:

- `data/hubspot/.../deals.snapshot.md` → finds last 5 closed-won
- `data/avoma/transcripts/...` → grabs the discovery transcripts for each
- `data/signals/...` → cross-refs funding / hiring events from the lake

Output (truncated example):

```
Last 5 closed-won deals — what they had in common
─────────────────────────────────────────────────
1. Glimmer Health (closed Mar 2026)
   buyer: CHRO (Marisol Hwang, hired 90d pre-close)
   trigger 90d pre-close: Series C ($80M, lead a16z)
   time-to-close: 47 days

2. Outpost AI (closed Feb 2026)
   buyer: VP People  trigger: 30% headcount growth in 180d
   time-to-close: 62 days
...

PATTERN — 4 of 5 had a CHRO or VP-People hire in the 90 days
before discovery. 3 of 5 had Series B/C/D in the same window.
Mean time-to-close: 54 days.
```

> *"Notice what just happened: Claude read your HubSpot, your Avoma calls, and your enrichment data at the same time and gave you back a pattern. That's not a feature — that's the OS earning its keep on the first prompt."*

### 3:00–4:15 — Prompt 2: "Rewrite my discovery playbook"

> *"Rewrite my discovery playbook based on what actually shows up in the Avoma transcripts of those 5 wins. I want the real questions reps asked — not the ones in the old playbook."*

Claude reads the transcripts from prompt 1, extracts the discovery questions, and rewrites `foundation/playbooks/discovery.md`. Open the diff side-by-side on screen.

> *"The new discovery playbook isn't what we *thought* worked — it's what *did* work. Claude pulled it from the recordings. Old playbook gets deprecated, new one ships as a PR — reviewable, versionable."*

> *"This is what the playbooks layer means: the rules about your work, written down, updated from real evidence, not vibes."*

### 4:15–5:30 — Prompt 3: "Find me accounts on the 200-list that look like my last 3 wins"

> *"Find every account on the 200-list that's had a CHRO hire or Series B+ funding in the last 90 days, ranked by how close they look to my last 3 wins."*

Claude reads:

- `data/200_list.csv` (or the table in Supabase)
- `data/signals/crunchbase_funding_events`, `data/signals/the_org_people`
- The cohort vectors from the named-customer lookalike score

Output:

```
Top 8 of 200 — last-90d signal + lookalike rank
────────────────────────────────────────────────
1. Lithos Bio        priority=78  Series C + new CHRO  · Brex-shaped 0.79
2. Outpost AI        priority=71  CHRO hired Apr 14    · Vercel-shaped 0.76
3. Conduit Labs      priority=68  Series B Mar 22      · Dropbox-shaped 0.71
...
```

> *"Now — Alex — which of these would you have flagged on your own? Which wouldn't you have? That last one — that's the one we couldn't find without this. That's the alpha."*

### 5:30–6:00 — What just happened and what's next

> *"You've been inside the OS for less than 5 minutes and you've asked three questions that would have taken a week of manual work. That's the trust-build moment. Tomorrow's video is the harder question: what's the top problem to actually solve first? That's where bottlenecks get captured."*

## What the viewer walks away knowing

- **You don't have to learn the tool to use the OS.** You ask questions in plain English; Claude finds the data.
- **Two terminals — one for chat, one for repo work.** Standard setup.
- **The first three prompts are deliberately chosen** — what won, why, and what's about to.
- **The OS knows things you don't.** That's the unlock.

## Common questions this video should answer

- *"Do I need to know SQL?"* → No, but Claude will write it for you if you ask. The audit answer is always available — you can ask *"show me the SQL you ran"* and get it.
- *"What if Claude gets something wrong?"* → It will, occasionally. Every answer cites which files it read; you can verify the source in 10 seconds. This is the *audit* feature — same reason we keep scoring deterministic in SQL.
- *"How is this different from just asking ChatGPT?"* → ChatGPT doesn't have your HubSpot, your Avoma transcripts, or your 200-list. Claude Code in this repo does. The data is the moat.
- *"Do reps use this too?"* → Not yet. Reps get the *output* in Slack (video 5). Stakeholders get the *system*.
