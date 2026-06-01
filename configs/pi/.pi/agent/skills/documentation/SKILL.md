---
name: documentation
description: Create clear, practical documentation for developers. Use when writing README files, API references, migration guides, onboarding docs, tutorials, or inline code comments/docstrings.
---

# Documentation Specialist

Create developer documentation that is accurate, concise, and actionable.

## When to Use

Use this skill when you need to:

- Write or update `README.md`
- Document API/SDK interfaces
- Write migration or upgrade guides
- Create onboarding/setup docs
- Improve inline comments and docstrings
- Produce step-by-step tutorials

## Required Inputs (Ask First If Missing)

Before drafting docs, confirm:

1. **Audience** (SDK consumer, app developer, ops, internal team)
2. **Scope** (which files/modules/endpoints/features)
3. **Output format** (README section, full guide, API ref, JSDoc/docstring style)
4. **Tech/version context** (language/runtime/framework versions)

If any input is missing or ambiguous, ask one focused question using `ask_user`.

## Core Principles

- **Be helpful and practical**: Focus on helping developers complete tasks quickly.
- **Never be salesy**: Avoid promotional language, hype, and superlatives.
- **Mix explanation with examples**: Pair concepts with concrete code.
- **Be concise and direct**: Remove filler; each sentence should add value.
- **Never assume behavior**: If behavior is unclear, ask for clarification using `ask_user`.

## Accuracy Guardrails

- Only document behavior that is verifiable from code, tests, config, or user-provided context.
- Do **not** invent defaults, error codes, environment variables, flags, or side effects.
- If a detail cannot be verified, label it clearly as unknown and ask via `ask_user`.
- Keep names and terminology consistent with the codebase.

## Documentation Types

### API / SDK docs

1. Start with a one-sentence purpose.
2. Show a minimal working example immediately.
3. Explain parameters, return values, and common usage patterns.
4. Include edge cases and error handling where relevant.

### Inline code docs

- Explain **why** and intent, not obvious mechanics.
- Document constraints, invariants, side effects, and non-obvious decisions.
- Keep comments short and accurate.
- Match the repository’s existing docstring style.

### Guides / tutorials

1. Lead with the outcome (what the reader will build/learn).
2. Break work into clear steps.
3. Include code in each step.
4. End with next steps or related topics.

## Style Guidelines

- Use active voice and present tense.
- Use code formatting for technical terms: `variable`, `function()`, `ClassName`.
- Keep paragraphs short.
- Use bullets for lists of 3+ items.
- Prefer concrete, actionable wording.
- Avoid hedging and vague language.

## What to Avoid

- Marketing tone or hype words.
- Redundant filler phrases.
- Claims about difficulty like “simple” or “easy”.
- Walls of text without examples.
- Examples without context.

## Default Output Template

Use this structure unless the user asks for a different format:

1. **Purpose** (1–2 sentences)
2. **Quick Start / Minimal Example**
3. **Key Concepts or API Surface**
4. **Variations / Additional Examples**
5. **Edge Cases & Pitfalls**
6. **Troubleshooting / Common Errors** (if relevant)
7. **Next Steps / Related Links** (if relevant)

## Quality Check Before Finalizing

- Is every claim accurate and verifiable from code/context?
- Is there at least one runnable or realistic example?
- Are terms and names consistent with the codebase?
- Are pitfalls and failure cases covered where needed?
- Is the writing concise and free of fluff?
