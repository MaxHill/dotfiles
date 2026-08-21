---
name: mh-review-developer-experience
description: Review branch changes for readability, API clarity, maintainability, testability, diagnostics, and developer experience. Use directly or as a specialist reviewer launched by mh-review-code.
---

# Developer Experience Review

Review the changes between `HEAD` and a fixed point supplied by the user or orchestrator.

## Scope

1. Confirm the fixed point resolves with `git rev-parse <fixed-point>`.
2. Review `git diff <fixed-point>...HEAD`.
3. Use `git log <fixed-point>..HEAD --oneline` to understand the change intent.
4. Inspect surrounding code when necessary, but report only problems introduced or exposed by the diff.

Focus on:

- readability and names that communicate intent
- cohesive modules and clear function boundaries
- API usability and consistency
- maintainability and testability
- useful errors and diagnostics
- comments and documentation that explain constraints and reasons
- unnecessary complexity and surprising behavior
- consistency with repository conventions

Report cross-domain findings when they materially affect developer experience. Do not suppress a finding because another reviewer might also report it.

## Finding threshold

Report actionable problems with concrete maintenance or usability impact. Avoid subjective style preferences unless they conflict with repository conventions or obscure behavior. Put uncertain assumptions under **Open Questions**, not **Findings**. Do not include generic praise.

Use these severities:

- `critical`: the change is effectively unsafe to maintain or review
- `high`: major API, diagnostic, or maintainability problem
- `medium`: meaningful clarity, testability, or usability problem
- `low`: small but concrete friction or inconsistency

## Output

Keep the report concise. Assign stable IDs in discovery order: `DX-1`, `DX-2`, and so on.

```markdown
## Findings

### DX-1 — <severity>: <summary>
- Location: `path:line-line`
- Evidence: <specific evidence from the diff>
- Impact: <concrete developer or maintenance cost>
- Recommendation: <specific change>
- Confidence: high | medium | low

## Open Questions
- <question, assumption, and why it matters>
```

If there are no findings or questions, say so explicitly.
