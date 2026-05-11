# ingest/raw/

> Manual drop-zone. Where stuff lives when Step 2b (the Supabase/BigQuery lake) hasn't been stood up yet.

## What goes here

- HubSpot CSV exports (`hubspot/`)
- Avoma transcript dumps (`avoma/`)
- Slack channel exports (`slack/`)
- One-off vendor data (`vendor-xyz/`)

## What does NOT go here

- Account-specific signal events (those live in `accounts/<slug>/signals/`)
- Curated Avoma cuts (those live in `accounts/<slug>/transcripts/`)
- Anything that's been promoted into a node, account, or service

## Why this folder exists at all

Until Step 2b, there's no lake. SQL files in `sql/` would need to query *something*, so for early days they query CSVs in this folder (via DuckDB or similar). Once Step 2b is stood up:
- This folder becomes the **drop-zone for stuff in transit to the lake**, not the lake itself
- The SQL files swap their `from raw_xxx.csv` for `from supabase.xxx_table`
- The diff is one PR, reviewed by reps

## Gitignore rules

`raw/` contents are gitignored by default. Only directory READMEs and small sample files are committed. Reason: HubSpot CSVs contain PII (emails, phone numbers) that don't belong in a git history.

To bring data into a session:
1. Export from HubSpot/Avoma manually
2. Drop into `ingest/raw/<source>/`
3. Run the relevant SQL or skill
4. Delete the file after use (cron sweep does this nightly)

## What changes after Step 2b ships

- This folder becomes near-empty (just sample fixtures for local dev)
- The Step 2b decision doc (in `gtm-os/step-2b-context-lake-when-to-add-it.md` of the parent case study) explains when to make the jump

## See also

- [`../../sql/`](../../sql/) — the queries that read from here (until Step 2b)
- The parent case study's `gtm-os/step-2b-context-lake-when-to-add-it.md` for the lake decision
