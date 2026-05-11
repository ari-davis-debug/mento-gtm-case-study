# 2 — Play With Your Data

> Audience: Alex (and any opted-in stakeholder) · Outcome: you ask three questions against your *own* HubSpot + Avoma + Slack and see what the data already knows

## What this walkthrough covers

The lake is alive (walkthrough 1). Now you actually look at it. **The goal isn't to ship anything — it's to feel what it's like to ask questions across HubSpot, Avoma, and Slack at the same time and get one answer back.**

Three prompts. Plain English. No SQL required (Claude writes it for you and shows its work).

## Setup

- Claude Code installed and open in `mento-gtm/` (walkthrough 1)
- First Airbyte sync has run — Supabase has rows in `hubspot_*`, `avoma_*`, `slack_*`
- Two terminal panes — one for the Claude Code chat, one for repo work (handy when you want to peek at the SQL it ran or the file it edited)

A few Claude Code things worth knowing as you start playing:

- **Planning mode** — type `/plan` (or press `Shift+Tab` twice) when you want Claude to *think* before it acts. Useful for any prompt where you want it to lay out the SQL it's about to run before it runs it. [docs.claude.com/claude-code](https://docs.claude.com/en/docs/claude-code)
- **`CLAUDE.md`** — a file at the root of the repo that Claude reads on every prompt. This is where Mento-specific context lives ("we sell to CHROs", "200-list is in `data/200_list.csv`", "ICP includes Series B+"). The more this file knows, the less you re-explain every prompt.
- **`.claude/commands/`** — shortcuts you'll graduate to once you find prompts you keep re-typing. `/last-wins`, `/lookalikes`, `/discovery-rewrite` become one-keystroke versions of the prompts below.
- **`.claude/skills/`** — SOPs Claude follows automatically. *"Always check existing playbooks before rewriting one"* lives here, not in your head.

You won't need any of those today. They graduate from this session, organically.

## Prompt 1 — "What did my last 5 wins have in common?"

In Claude Code, type:

> *"Pull my last 5 closed-won deals and tell me what they had in common — buyer role, trigger event in the 90 days before close, time-to-close. Show me the SQL you ran."*

Claude reads across:

- `hubspot_deals` → last 5 closed-won
- `avoma_transcripts` → discovery calls for each deal
- `hubspot_contacts` + `hubspot_activities` → who was on the calls, when meetings happened

A typical output:

```
Last 5 closed-won — what they had in common
─────────────────────────────────────────────────
1. Glimmer Health    buyer: CHRO (hired 90d pre-close)
                     trigger 90d pre-close: Series C
                     time-to-close: 47 days

2. Outpost AI        buyer: VP People
                     trigger: 30% headcount growth in 180d
                     time-to-close: 62 days
...

PATTERN — 4 of 5 had a CHRO/VP-People hire in the 90 days
before discovery. 3 of 5 had Series B/C/D in the same window.
Mean time-to-close: 54 days.
```

Claude just read HubSpot, Avoma, and (where available) Slack at the same time and returned a pattern. **That's the unlock — one question, three sources, one answer.** Ask Alex: *did you know that?* Sometimes yes. Sometimes no. Either way, the system just said it out loud.

## Prompt 2 — "Rewrite my discovery playbook from what reps actually said"

> *"Read the Avoma transcripts of the 5 wins above. Pull out the discovery questions reps actually asked — verbatim. Then draft a new `foundation/playbooks/discovery.md` that's grounded in those, not in the old playbook."*

Claude opens the transcripts, extracts the questions, and writes a new playbook file. Review the diff side-by-side in the second terminal pane.

The new playbook isn't what we *thought* worked — it's what *did* work. Old playbook deprecated, new one PR-reviewable, versioned in git.

**This is the playbooks layer working live: rules about your work, updated from real evidence, not vibes.**

## Prompt 3 — "Find accounts on the 200-list that look like my last 3 wins"

> *"For every account on the 200-list, check if they've had a CHRO hire or a Series B+ funding event in the last 90 days. Rank them by how closely they look like my last 3 won deals. Show me the top 10."*

Claude reads `data/200_list.csv` (or wherever the 200-list lives), cross-refs against whatever signal data has been synced, and ranks.

Output:

```
Top 10 of 200 — recent signal + lookalike rank
────────────────────────────────────────────────
1. Lithos Bio        Series C + new CHRO     · Glimmer-shaped 0.79
2. Outpost AI        CHRO hired Apr 14       · Vercel-shaped 0.76
3. Conduit Labs      Series B Mar 22         · Dropbox-shaped 0.71
...
```

The question to ask Alex: **which of these would you have flagged on your own? Which wouldn't you have?** The one you wouldn't have is the alpha. That gap — between founder intuition and what the lake surfaces — is the seed for walkthrough 3.

*Note: if you haven't wired any external signal source yet, this prompt runs on what's already in HubSpot/Avoma (e.g., "accounts that had a contact-title change to CHRO in the last 90d, with engagement activity"). The point of this walkthrough is to play with what you have, not to enrich.*

## What you've unlocked

- You can ask anything across HubSpot + Avoma + Slack in one breath.
- Claude shows you the SQL it ran on every answer — no black box.
- The new discovery playbook is grounded in real transcripts, not memory.
- You've seen at least one account the lake flagged that you wouldn't have — that's the seed for walkthrough 3.

## Common questions

- **Do I need to know SQL?** No. Claude writes it, and you can ask *"show me the SQL you ran"* on any answer. The audit trail is one prompt away.
- **What if Claude gets something wrong?** It will, occasionally. Every answer cites which files/tables it read — you can verify the source in 10 seconds. This is also why scoring (later) stays deterministic in SQL, not in the LLM.
- **How is this different from just asking ChatGPT?** ChatGPT doesn't have *your* HubSpot, *your* Avoma transcripts, or *your* 200-list. Claude Code in this repo does. The data is the moat.
- **Should I be writing my own prompts beyond these three?** Yes — this walkthrough is a starting kit, not a syllabus. The whole point is to play. The prompts you find yourself re-typing become `.claude/commands/` in walkthrough 3.
- **Do reps use this too?** Not in this phase. Stakeholders get the *system*. Reps get the *output* in Slack — but only once a workflow is actually operationalized (walkthrough 4 sketches that).
