---
name: mh-review-code
description: Orchestrate a review of branch changes from safety, performance, and developer-experience perspectives, using parallel sub-agents when the harness supports them. Use when reviewing changes since a commit, branch, tag, or merge-base.
---

# Code Review Orchestrator

Coordinate three specialist reviews and synthesize their findings. The user must supply a fixed point: a commit SHA, branch, tag, or other revision.

## 1. Pin the review scope

If the user did not supply a fixed point, ask for one before continuing.

Confirm it resolves:

```bash
git rev-parse <fixed-point>
```

Use this exact review range throughout:

```bash
git diff <fixed-point>...HEAD
git log <fixed-point>..HEAD --oneline
```

Stop with a clear explanation if the ref is invalid or the diff is empty. Gather relevant repository instructions and enough surrounding context for the reviewers to understand the change. The diff remains the reporting boundary: do not report unrelated pre-existing problems.

## 2. Launch specialist reviewers

Use the harness's available sub-agent mechanism to launch all three reviewers concurrently and in isolated contexts:

- `mh-review-safety`
- `mh-review-performance`
- `mh-review-developer-experience`

Tell each sub-agent to load and follow its named skill. Give each one:

- the fixed point and exact diff command
- the commit list
- the user's stated purpose and constraints
- relevant repository instructions
- permission to inspect the repository for surrounding context

Do not prescribe harness-specific tool syntax. Adapt to the sub-agent facility that is available.

If the harness has no sub-agent capability, do not silently simulate parallel or isolated reviews. Ask the user whether to run the three reviews sequentially in the current context. Continue sequentially only with explicit approval.

## 3. Synthesize

Combine the reports without losing evidence or attribution.

- Merge findings that describe the same underlying problem, even when severity or framing differs.
- Cite every contributing specialist ID on a merged finding.
- Resolve severity disagreements using the highest well-supported severity; explain material disagreements.
- Preserve distinct findings that happen to share a location.
- Order findings by `critical`, `high`, `medium`, then `low`.
- Keep uncertain items under **Open Questions**.
- Do not add a new defect unless it follows directly from the supplied evidence.

Choose the recommendation as follows:

- `Request changes`: any well-supported critical or high finding
- `Approve with changes`: only medium or low findings remain
- `Approve`: no actionable findings

## Output

```markdown
## Code Review

Fixed point: `<fixed-point>`
Range: `<fixed-point>...HEAD`

### Findings
| ID | Severity | Location | Summary | Sources |
|---|---|---|---|---|
| REV-1 | high | `path:line-line` | ... | SAF-1, DX-2 |

### Details

#### REV-1 — high: <summary>
- Location: `path:line-line`
- Evidence: <specific evidence>
- Impact: <concrete impact>
- Recommendation: <specific change>
- Sources: SAF-1, DX-2
- Confidence: high | medium | low

### Open Questions
- <deduplicated question and why it matters>

### Recommendation
Approve | Approve with changes | Request changes

<one-sentence rationale>
```

Omit empty finding rows and detail sections, but explicitly state when no findings or open questions exist.
