---
name: code-review
description: Orchestrate multi-agent code review with Safety → Performance → DX priority. Use when user asks for a code review, PR review, diff review, or quality gate before merge.
---

# Code Review Orchestrator

Run comprehensive review by delegating to specialized subagents and synthesizing one actionable report.

## Workflow

1. **Scope the review target**
   - If user gave a scope (files, diff, PR context), use it.
   - If scope is unclear, review current staged/working changes and say what you reviewed.

2. **Launch specialized reviewers in parallel**
   Use one `subagent` parallel call with these agents:
   - `code-reviewer-safety`
   - `code-reviewer-performance`
   - `code-reviewer-developer-experience`

   Give each reviewer:
   - exact scope and goal
   - file paths and line ranges when available
   - constraints (latency/SLA/platform/etc.)

3. **Synthesize findings (don’t duplicate)**
   - Merge overlapping findings.
   - Resolve conflicts by priority: **Safety > Performance > DX**.
   - Keep low-value nits brief.

4. **Return one final report**
   Use this format:

   ## Code Review
   ### Critical Issues 🔴 (Must Fix Before Merge)
   ### High Priority 🟡 (Fix Before Release)
   ### Medium Priority 🟠 (Address Soon)
   ### Low Priority 🟢 (Nice to Have)
   ### Quick Wins ⚡
   ### Design Trade-offs 🔄
   ### Excellent Practices ✅
   ### Summary
   - Issues total and severity breakdown
   - Recommendation: Approve / Approve with changes / Needs revision

## Guardrails

- Prefer concrete, verifiable findings over broad commentary.
- Every non-low finding should include location and recommended fix.
- Don’t propose unsafe performance shortcuts.
- If evidence is insufficient, say what additional context is needed.
