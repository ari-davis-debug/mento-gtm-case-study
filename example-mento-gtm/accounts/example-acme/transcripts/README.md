# transcripts/ (Acme)

> Curated Avoma cuts that matter for this account. **Not** the full Avoma dump — that lives in Supabase/BigQuery if Step 2b is stood up, or `ingest/raw/` otherwise.

## What lives here

- `YYYY-MM-DD-<call-type>.md` — markdown extract of the relevant 3–5 quotes from a call
- `YYYY-MM-DD-prep.md` — pre-call brief Claude generates 24 hours before each call

## Why a curated cut, not the full dump

Full Avoma transcripts are 60+ minutes of speech. The cuts that matter are usually 6–10 quotes. Stakeholders read the cuts; Claude reads the cuts; nobody reads the raw transcripts unless they're investigating something specific (in which case they query the lake).

## What "matters" means

A quote earns its way into a cut if it:
- States a decision or commitment ("we'll have a band refresh done by Q3")
- Reveals a constraint ("the CFO has to sign anything over $100k")
- Identifies the actual buyer ("Sarah owns this, not me")
- Surfaces a disqualifier ("we already signed with Pave")
- Shifts the deal stage (objection raised, demo booked, etc.)

## Example files this folder will hold

- `2026-05-10-prep.md` — pre-demo brief for the 2026-05-14 demo
- `2026-05-14-discovery.md` (post-demo) — curated quotes from the call
- `2026-05-21-follow-up.md` (if it happens) — second call cuts
