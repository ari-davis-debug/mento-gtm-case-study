# Step 3 — Stakeholders into Claude Code on the Repo

> Foundation · Day 4–7

## What this step is

Get Alex (and any other opted-in stakeholder) onboarded into Claude Code, pointed at the live `mento-gtm/` repo, running their first prompts against their own data. **Stakeholders get the system. Reps get the output.**

## Why this step matters

The lake and the playbooks (Steps 1–2) are dead weight if nobody opens them. Cetner's adoption mechanic is *"a few 1:1 sessions getting them, having >1 terminal open, using planning mode, talking to the data they have in a workflow they run."* This is the trust-build moment — when Alex sees the system surface accounts he'd already flag (plus one he wouldn't have), the OS earns its keep.

## What concrete work happens here

### Per-stakeholder onboarding (~45 min, recorded)
- Install Claude Code, install GitHub Desktop, clone `mento-gtm/`
- Open 2+ terminals — one for chat, one for repo work
- Show planning mode; show how Claude Code finds context across the repo on its own
- Run their first three starter prompts against *their own data*:
  1. *"Pull my last 5 won deals and tell me what they had in common — buyer role, trigger, time-to-close."*
  2. *"Rewrite my discovery playbook based on what actually shows up in the Avoma transcripts of those 5 wins."*
  3. *"Find every account on the 200-list that's had a CHRO hire or Series B+ funding in the last 90 days, ranked by how close it looks to my last 3 wins."*

### Custom skills and commands come from these sessions, not before
When Alex says *"I want this 200-list signal-check to run every Monday morning"* — that becomes a one-line spec (*"build me X, here's why"*) which graduates into a real Claude Code skill or slash-command living in `mento-gtm/.claude/`. **Starter prompts in week 1 → repeatable skills/commands by week 3 → spec inputs for Part 3 builds by week 4.**

### Distinction that matters
- **Stakeholders** (Alex first, then anyone else who wants in) — get the *system*. They can ask "why" and get an answer that isn't vibes.
- **Reps** — get the *output*. A ranked list of accounts to work, with context. They don't open Claude Code in week 1; the system delivers them what they need in Slack (see Step 5).

## Which take-home section lives inside this step

[Part 1 §2 — *"Get stakeholders into Claude Code, pointed at the repo"*](../case-study/part1-diagnose-and-prioritize.md)

The 3 starter prompts above are the same ones in Part 1 §2. The reason they're in the take-home: this is the moment the OS goes from "well-organized files" to "a system Alex actually uses to answer his own questions."

## What's next

[Step 4 — Capture + prioritize bottlenecks](./step-4-capture-prioritize-bottlenecks.md) — having Alex inside the repo querying his own data is what surfaces what to build first. We don't run interviews to find bottlenecks; we let the data speak when stakeholders query it.
