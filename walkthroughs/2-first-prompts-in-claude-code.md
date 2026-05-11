# 2 — First Prompts in Claude Code

> Audience: Alex (and any opted-in stakeholder) · Outcome: stakeholder runs 3 starter prompts against their own data

## What this walkthrough covers

How a stakeholder gets from "Claude Code is installed" to "the OS already knows things I don't" in the span of three prompts. The point isn't to teach Claude Code — the point is to show that the lake answers questions that used to take a week of manual work.

## Setup

- Claude Code installed
- `mento-gtm/` cloned (see walkthrough 1)
- Two terminal panes — one for the Claude Code chat, one for repo work (running SQL, editing files)
- Real Mento data (or a realistic synthetic loadout if you're doing a dry run)

If `/plan` is unfamiliar — it's Claude Code's planning mode. Type it when you want Claude to think before it acts. Used heavily in walkthrough 4.

## Prompt 1 — "What did my last 5 wins have in common?"

In Claude Code, type:

> *"Pull my last 5 closed-won deals and tell me what they had in common — buyer role, trigger event in the 90 days before close, time-to-close."*

Claude reads:

- `data/hubspot/.../deals.snapshot.md` → last 5 closed-won
- `data/avoma/transcripts/...` → discovery transcripts for each
- `data/signals/...` → cross-refs funding / hiring events from the lake

A typical output:

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

Claude read HubSpot, Avoma calls, and enrichment data at the same time and returned a pattern. That's not a feature — that's the OS earning its keep on the first prompt.

## Prompt 2 — "Rewrite my discovery playbook"

> *"Rewrite my discovery playbook based on what actually shows up in the Avoma transcripts of those 5 wins. I want the real questions reps asked — not the ones in the old playbook."*

Claude pulls the transcripts from prompt 1, extracts the discovery questions reps actually asked, and rewrites `foundation/playbooks/discovery.md`. Review the diff side-by-side.

The new discovery playbook isn't what we *thought* worked — it's what *did* work. Claude pulled it from the recordings. Old playbook gets deprecated, new one ships as a PR — reviewable, versionable.

This is the playbooks layer: the rules about your work, written down, updated from real evidence, not vibes.

## Prompt 3 — "Find me accounts on the 200-list that look like my last 3 wins"

> *"Find every account on the 200-list that's had a CHRO hire or Series B+ funding in the last 90 days, ranked by how close they look to my last 3 wins."*

Claude reads:

- `data/200_list.csv` (or the equivalent Supabase table)
- `data/signals/crunchbase_funding_events`, `data/signals/the_org_people`
- Named-customer lookalike cohort vectors

Output:

```
Top 8 of 200 — last-90d signal + lookalike rank
────────────────────────────────────────────────
1. Lithos Bio        priority=78  Series C + new CHRO  · Brex-shaped 0.79
2. Outpost AI        priority=71  CHRO hired Apr 14    · Vercel-shaped 0.76
3. Conduit Labs      priority=68  Series B Mar 22      · Dropbox-shaped 0.71
...
```

The question to ask Alex: which of these would you have flagged on your own? Which wouldn't you have? **The one you wouldn't have — that's the alpha.**

## What you've unlocked

- **You don't have to learn the tool to use the OS.** Ask in plain English; Claude finds the data.
- **Two terminals — one for chat, one for repo work.** Standard setup.
- **The first three prompts are deliberate** — what won, why, and what's about to.
- **The OS knows things you don't.** That's the unlock.

## Common questions

- **Do I need to know SQL?** No, but Claude will write it for you if you ask. The audit answer is always available — say *"show me the SQL you ran"* and you get it.
- **What if Claude gets something wrong?** It will, occasionally. Every answer cites the files it read; you can verify the source in 10 seconds. Same reason scoring stays deterministic in SQL.
- **How is this different from just asking ChatGPT?** ChatGPT doesn't have your HubSpot, your Avoma transcripts, or your 200-list. Claude Code in this repo does. The data is the moat.
- **Do reps use this too?** Not yet. Reps get the *output* in Slack (walkthrough 5). Stakeholders get the *system*.
