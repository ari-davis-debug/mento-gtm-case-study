# Walkthroughs — the 5-video adoption series

> The adoption mechanic, applied to Mento. Recorded once. Lives in the repo. Onboards the next stakeholder (or new hire) in a morning.

## Why this folder exists

The case study answers *what* to build. The 7-step OS folder answers *why this shape*. **This folder is what Mento actually presses play on** — the recordings that make sure Alex and the reps don't bounce off the terminal in week one.

The submission also ships a separate **~10-minute evaluator video** that walks the GTM OS framing top-to-bottom (script at [`../README.md`](../README.md) section "On the video walkthrough"). That's for Mento's hiring team. The 5 videos below are for Mento's *users*.

## The series

| # | Video | Length | Audience | What it unlocks |
|---|---|---|---|---|
| 1 | [Setting up the OS — Airbyte OAuth + repo tree](./video-1-setting-up-the-os.md) | ~7 min | Alex (+ RevOps if there is one) | Lake is alive. Daily sync running. Repo cloned. |
| 2 | [First prompts in Claude Code](./video-2-first-prompts-claude-code.md) | ~6 min | Alex (and any opted-in stakeholder) | Stakeholder running 3 starter prompts against their own data. |
| 3 | [Walking the bottleneck capture](./video-3-bottleneck-capture.md) | ~5 min | Alex | Top 1–2 bottlenecks ranked from the lake, not from interviews. |
| 4 | [The Part 3 build, end to end](./video-4-part-3-build-end-to-end.md) | ~8 min | Alex (technical co-founder shape) | Sees how a top-ranked bottleneck becomes a shipped, eval-gated workflow. |
| 5 | [What a rep sees in Slack](./video-5-rep-slack-experience.md) | ~4 min | Reps (Mento's 2) | First time reps see a signal card. Trust-build moment. |

## Reading order

- **Decision-makers** can watch #1 and #5 — those are the bookends. Setup and rep experience.
- **The full series** is the proper sequence; each video assumes the prior one ran.
- **New hires** (post-rollout) watch all 5 in order on day one.

## What each video file contains

Every video script in this folder is structured the same way, so anyone can pick one up and record it:

- **What this video shows** — one-sentence promise to the viewer
- **Setup before hitting record** — what's open, what data is loaded, what windows are arranged
- **Beat-by-beat** — what's on screen, what's said, in order
- **What the viewer walks away knowing** — the takeaway
- **Common questions this video should answer** — the FAQ that means we don't need a sixth video

## The connector that makes this whole series possible

**Airbyte.** It's the OAuth-based ingestion layer that pulls HubSpot, Avoma, Slack, Apollo, Crunchbase, Sumble, Greenhouse / Lever, and TheirStack into Supabase on a daily schedule. **No API keys floating around** — Alex authorizes each source once via the standard OAuth dance, and the daily sync is live. Video 1 is mostly about Airbyte.

Why Airbyte and not a hand-rolled integration: it's the only piece of the stack we get to *not build*. Custom scrapers are where GTM-engineering teams die. Airbyte gives us the data layer for free and lets us spend the time on the playbooks and the build (the parts that are actually Mento's).

## What's NOT in this folder

- The 9:30 evaluator video (that's at the submission level, framing the OS)
- Code (lives in the planned `mento-gtm/` build repo — this is a case study, not the build)
- Real Mento data (we haven't seen any — videos show synthetic / placeholder data, clearly labeled)
