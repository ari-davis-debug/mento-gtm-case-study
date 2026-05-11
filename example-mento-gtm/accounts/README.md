# accounts/

> One folder per top account. **The GTM unit of work** — Mento operates on accounts, not on contacts.

## Folder shape

Each account folder follows the same pattern:

```
accounts/<account-slug>/
├── deal.md            # cross-cut of HubSpot + Avoma + Slack + signals
├── timeline.md        # 90-day signal trail
├── transcripts/       # Avoma cuts that matter (curated, not the full dump)
├── signals/           # funding, hires, headcount deltas tied to this account
└── notes.md           # rep / founder freeform
```

## How folders get created

- **The 200-list** drives initial population. Each name on the list = one folder.
- **New triggers** that score Tier-1 or Tier-2 auto-create a folder if one doesn't exist.
- **Manual creation** by a rep is allowed but rare — usually means a warm intro arrived outside the signal flow.

## Naming

`accounts/<lowercase-kebab-slug>/` — e.g., `accounts/example-acme/`, not `accounts/Example_Acme/`. The slug should match the HubSpot account record's primary identifier.

## What never lives here

- Raw HubSpot dumps (those live in Supabase/BigQuery if Step 2b is stood up, or `ingest/raw/` for one-offs)
- Generic playbook content (lives in `foundation/playbooks/`)
- Bottleneck files (live in `bottlenecks/`)

## Why this is the unit of work

Stakeholders ask *"why did we close [account]?"* or *"what's happening with [account]?"* — both questions get answered by Claude reading 4–6 files inside the account folder. No cross-folder archaeology, no SQL required, no Avoma searching. The account folder *is* the answer.

## Example folder

[`accounts/example-acme/`](./example-acme/) — fully-scaffolded illustrative account. Open it to see the pattern.
