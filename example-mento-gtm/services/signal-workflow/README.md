# signal-workflow/

> Production service. Detects triggers, drafts outbound, gates on eval, ships to rep inbox.

## Status
🟡 In development — target ship 2026-05-22

## Local dev

```bash
cd services/signal-workflow
pnpm install
pnpm dev
```

## Subfolders

| Folder | Purpose |
|---|---|
| `triggers/` | Trigger.dev tasks (the runtime) |
| `prompts/` | Versioned LLM prompts |
| `eval/` | LLM-as-judge eval gates |
| `webhooks/` | Inbound HTTP endpoints |

## See also

- [`spec.md`](./spec.md) — what this service does and why
- [`../../bottlenecks/no-trigger-coverage-on-200-list.md`](../../bottlenecks/no-trigger-coverage-on-200-list.md) — the bottleneck this addresses
