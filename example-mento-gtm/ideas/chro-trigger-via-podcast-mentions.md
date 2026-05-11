---
title: CHRO trigger via podcast mentions
type: idea
status: draft
captured: 2026-05-11
related: [[knowledge-base/business/chro-hire-as-compelling-event]]
---

# CHRO trigger via podcast mentions

## The spark

Sarah K. (Acme CHRO) appeared on the "People Strategy Pod" 4 weeks *before* her hire was announced on LinkedIn. The episode talked about her "next move." If we'd indexed that, we'd have had a 4-week head start.

## The hypothesis

People-ops podcasts interview about-to-be-hired CHROs more often than we realize. If we transcribe ~20 podcasts/week with Whisper + extract guest names + cross-reference against open CHRO roles on LinkedIn, we might get a 2–6 week lead on the trigger.

## What we'd test

- Pull 12 weeks of episodes from the top 20 people-ops podcasts
- Diff guest list against LinkedIn role changes 2026-Q1
- Measure: how many guests changed roles to CHRO within 90 days post-episode?

## Cost to validate

- ~$50 in Whisper API
- 2 hours to wire the pipeline
- Verdict by end of weekend

## Decision criteria for promotion

- If >25% of guests change roles within 90 days → promote to `bottlenecks/` (a real signal)
- If <10% → demote (noise)
- If 10–25% → run for another quarter before deciding

## Not yet promoted because

We have bottleneck #1 in flight. This is a "weekend exploration" that costs almost nothing but isn't urgent.
