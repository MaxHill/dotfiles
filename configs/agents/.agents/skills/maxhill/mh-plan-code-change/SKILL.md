---
name: mh-plan-code-change
description: >
  Use when making a plan for code changes. Remember to cover architecture,
  changed modules, module seams, interfaces, call-stack changes, and
  testing.
---

# MH Plan Code Change

When making an implementation plan, keep it concise and practical. This is
a checklist of things to remember to include.

## Goal

- User-visible outcome.
- Non-goals or boundaries of the change.

## Architecture

- Architectural approach.
- Main design decision and why it fits this codebase.
- Data flow, state ownership, lifecycle, or dependency changes when
  relevant.

## Project design

- Modules/files that will change.
  - Seam: what each module owns and hides.
  - Interface: what callers use or what will change.
  - Example API or call site, if applicable.
- Call-stack outline.
  - Entry points.
  - Internal calls.
  - Side effects or outputs.
- Configuration, migration, or compatibility concerns when relevant.

## Implementation steps

- Ordered, concrete steps.
- Separate refactors from behavior changes.

## Testing and validation

- Unit tests to add or update.
- Integration/end-to-end tests to add or update.
- Regression and edge cases.
- Manual validation or commands to run.

Keep the plan specific enough that another engineer can implement it
without rediscovering the design.
