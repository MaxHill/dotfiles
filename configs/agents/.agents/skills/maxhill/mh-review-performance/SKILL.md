---
name: mh-review-performance
description: Review branch changes for measurable performance, scalability, latency, memory, I/O, and contention problems. Use directly or as a specialist reviewer launched by mh-review-code.
---

# Performance Review

Review the changes between `HEAD` and a fixed point supplied by the user or orchestrator.

## Scope

1. Confirm the fixed point resolves with `git rev-parse <fixed-point>`.
2. Review `git diff <fixed-point>...HEAD`.
3. Use `git log <fixed-point>..HEAD --oneline` to understand the change intent.
4. Inspect surrounding code when necessary, but report only problems introduced or exposed by the diff.

Focus on:

- algorithmic complexity and behavior as inputs grow
- latency and throughput on important paths
- allocations, copying, retention, and memory pressure
- I/O, network calls, syscalls, batching, and caching
- lock contention and concurrency bottlenecks
- repeated work and avoidable computation
- regressions that need benchmarks or profiling

Report cross-domain findings when they materially affect performance. Do not suppress a finding because another reviewer might also report it.

## Finding threshold

Every finding must have either clear complexity or scalability evidence, or a concrete measurement plan that can validate the concern. Do not report unsupported claims that code "might be slow." Put uncertain assumptions under **Open Questions**, not **Findings**. Do not include generic praise.

Use these severities:

- `critical`: pathological behavior or a regression that makes an important workload unusable
- `high`: substantial production impact on an important path
- `medium`: meaningful impact under realistic workloads
- `low`: small but measurable inefficiency worth correcting

## Output

Keep the report concise. Assign stable IDs in discovery order: `PERF-1`, `PERF-2`, and so on.

```markdown
## Findings

### PERF-1 — <severity>: <summary>
- Location: `path:line-line`
- Evidence: <specific evidence from the diff>
- Impact: <concrete performance effect>
- Recommendation: <specific change>
- Measurement: <benchmark, profile, trace, or metric>
- Confidence: high | medium | low

## Open Questions
- <question, assumption, and why it matters>
```

If there are no findings or questions, say so explicitly.
