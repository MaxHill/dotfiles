---
name: mh-review-safety
description: Review branch changes for correctness, security, validation, failure behavior, dependency risk, and concurrency safety. Use directly or as a specialist reviewer launched by mh-review-code.
---

# Safety Review

Review the changes between `HEAD` and a fixed point supplied by the user or orchestrator.

## Scope

1. Confirm the fixed point resolves with `git rev-parse <fixed-point>`.
2. Review `git diff <fixed-point>...HEAD`.
3. Use `git log <fixed-point>..HEAD --oneline` to understand the change intent.
4. Inspect surrounding code when necessary, but report only problems introduced or exposed by the diff.

Focus on:

- correctness and preservation of invariants
- input validation and trust boundaries
- authentication, authorization, secrets, and injection risks
- explicit error handling and safe failure behavior
- memory, resource, and concurrency safety
- dependency and supply-chain risk
- tests needed to establish safe behavior

Report cross-domain findings when they materially affect safety. Do not suppress a finding because another reviewer might also report it.

## Finding threshold

Report actionable defects and risks supported by evidence. Put uncertain assumptions under **Open Questions**, not **Findings**. Do not include generic praise.

Use these severities:

- `critical`: likely security compromise, data loss, corruption, or broadly incorrect behavior
- `high`: serious defect likely to affect users or production
- `medium`: meaningful defect with limited impact or likelihood
- `low`: small but concrete robustness problem

## Output

Keep the report concise. Assign stable IDs in discovery order: `SAF-1`, `SAF-2`, and so on.

```markdown
## Findings

### SAF-1 — <severity>: <summary>
- Location: `path:line-line`
- Evidence: <specific evidence from the diff>
- Impact: <concrete failure or risk>
- Recommendation: <specific change>
- Confidence: high | medium | low

## Open Questions
- <question, assumption, and why it matters>
```

If there are no findings or questions, say so explicitly.
