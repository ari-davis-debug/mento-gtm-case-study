# webhooks/

> Inbound HTTP endpoints. How the world tells us things happened.

## Endpoints

| Path | Source | Purpose |
|---|---|---|
| `POST /webhooks/clay` | Clay enrichment | New trigger event detected (CHRO hire, headcount delta, funding round) |
| `POST /webhooks/hubspot` | HubSpot | Reply received, deal stage changed, account updated |
| `POST /webhooks/slack` | Slack slash command | Rep-issued commands (`/skip-acme`, `/pause-queue`, `/score-account`) |

## Auth

- Clay: shared secret in header (`X-Clay-Secret`)
- HubSpot: signed payload (HMAC, key in Trigger.dev env)
- Slack: signing secret verification (standard Slack pattern)

## Why webhooks here, not in `triggers/`

`triggers/` is the runtime that does work. `webhooks/` is the doorway. Separating them means:
- A webhook handler is dumb — it validates auth, writes a row, returns 200
- The expensive work (LLM calls, SQL joins) happens in Trigger.dev tasks downstream
- We can rate-limit / queue / retry at the task layer without touching webhook code

## Validation discipline

Every webhook handler:
1. Validates the auth signature
2. Validates the payload schema (zod)
3. Writes a row to a raw_events table (idempotent insert)
4. Emits a Trigger.dev event
5. Returns 200

If steps 1–4 fail, we return 4xx and log. We do NOT return 500 unless the database is actually down. (Returning 500 makes Clay/HubSpot retry, creating dupes.)
