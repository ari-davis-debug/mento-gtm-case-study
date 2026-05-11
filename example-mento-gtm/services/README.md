# services/

> Shipped automations. Each subfolder is one production service with a `spec.md` and runnable code.

## What earns a folder here

A bottleneck has been re-scored to #1 long enough to commit a build. The build has a spec, an eval gate, and a deployment plan. Once those exist, a `services/<service-name>/` folder gets created.

Promotion path:
```
bottlenecks/<name>.md  (score it)
        ↓ (top-1 + buildable)
services/<name>/spec.md  (commit the build)
        ↓ (built + eval passing)
services/<name>/  (production, with deployment notes)
```

## Anatomy

```
services/<service-name>/
├── spec.md           # WHY this exists, what success looks like
├── triggers/         # Trigger.dev tasks (the runtime)
├── prompts/          # LLM prompts as versioned files
├── eval/             # The judges that gate output before send
├── webhooks/         # Inbound from Clay, HubSpot, Slack
└── README.md         # How to run it locally + production status
```

## Current services

| Service | Status | Bottleneck addressed |
|---|---|---|
| `signal-workflow/` | in-development | [no-trigger-coverage-on-200-list](../bottlenecks/no-trigger-coverage-on-200-list.md) |

## Why only one in flight

2-rep team rule from [`../foundation/_synthesis.md`](../foundation/_synthesis.md): one build at a time. The cost of context-switching across services exceeds the benefit of parallel builds.

When `signal-workflow/` ships and `actioned_at` rows are flowing, bottleneck #2 (playbook drift) becomes the next build.
