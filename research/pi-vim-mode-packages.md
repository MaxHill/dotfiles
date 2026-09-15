# Research: Pi Vim-mode / Vim-like Prompt Editing Packages (and Neovim-engine feasibility)

Date: 2026-09-07  
Research workspace: `/tmp/pi-vim-research-93217` (all clones kept outside repo as requested)

## Executive summary

- I found **multiple Pi packages that provide Vim-like editing**, but they are almost all implemented as **custom `CustomEditor` logic in TypeScript/Lua-adjacent code**, not by embedding Vim/Neovim itself.  
- I found **three Neovim bridge-style packages** (`pi-nvim-bridge`, `pi-nvim`, `@maxpaulus/pi-nvim`) that integrate with Neovim workflows, but these are **bridge/transport integrations**, not “Pi prompt editor powered by real embedded Neovim engine”.  
- **Clear answer:** as of this investigation, I found **no Pi package that runs a true embedded Vim/Neovim engine underneath Pi’s in-TUI prompt editor**.

---

## Scope and method

I used primary sources only:

1. **Pi official docs and source behavior** (custom editor API, extension/package model, TUI constraints):
   - Pi packages docs (`pi install`, `pi-package`, manifest): https://pi.dev/docs/packages  
   - Pi extensions docs (`ctx.ui.setEditorComponent`, `CustomEditor` patterns): https://pi.dev/docs/extensions  
   - Pi TUI docs (component/input contract): https://pi.dev/docs/tui  
   - Pi keybindings docs (Vim-style remap example): https://pi.dev/docs/keybindings  
   - Installed pi-coding-agent source (v0.85.1):
     - `/opt/homebrew/lib/node_modules/@earendil-works/pi-coding-agent/dist/modes/interactive/interactive-mode.js`
     - `/opt/homebrew/lib/node_modules/@earendil-works/pi-coding-agent/dist/modes/interactive/external-editor.js`
     - `/opt/homebrew/lib/node_modules/@earendil-works/pi-coding-agent/dist/modes/interactive/components/custom-editor.js`

2. **Registry + package catalog discovery**:
   - npm registry search endpoint (`/-/v1/search`) and package metadata (`registry.npmjs.org/<pkg>`)
   - npm download stats endpoint (`api.npmjs.org/downloads/point/last-month/<pkg>`)
   - Pi package pages for discovered packages (e.g. https://pi.dev/packages/pi-vim)

3. **Repository source inspections** (cloned to `/tmp` only):
   - `lajarre/pi-vim` @ `e55b07c05b648f3bbccf656c2b0c6ec63f1a91d1`
   - `burneikis/pi-vim` @ `0d0fd9d823f29bfa421d877def5cb5c7cf7e36a0`
   - `kungfusaini/pi-vim-flash` @ `1a2fe12669824a17d76347cf83765ac44bdccc55`
   - `0xKahi/pi-vim-keys` @ `ef4afe19136130c8ce55ce0810df47b6b304cf0c`
   - `thazhemadam/vim-state` @ `f95221a18e803aeca84b9666fb25056c330f16fd` (package `packages/integrations/pi-vim`)
   - `pekochan069/pi-vimmode` @ `60747b994fc48f691a83c5280f769cc58aed438d`
   - `kepatrick/vim-motions-pi` @ `efbb0161ebf9857ba9aa121e2e118aed9db9cd31`
   - `r3b1s/pi-vim-stash` @ `138b5fd75e370e48e19f0898e0865df389e7de10`
   - `leohenon/pi-vim` @ `819a8b0f0a1ec2171dffd9528636dcae7ce35e70`
   - `dabstractor/pi-nvim-bridge` @ `5dd7e4d7c5546458bbb79a4c5ec34e70c568fe99`
   - `carderne/pi-nvim` @ `3efbe679fdcaac1d643d465eea56826ce335dc4a`
   - `maxpaulus43/pi-nvim` @ `210803537dd5447f663a04b4cafab453ef0db367`
   - adjacent: `JohnFodero/pi-diff-review`, `inobit/pi-packages` (`pi-reader`)

4. **Neovim primary docs/API**:
   - `--embed` startup behavior: https://neovim.io/doc/user/starting/#--embed  
   - msgpack-rpc / API and `nvim --embed` examples: https://neovim.io/doc/user/api/  
   - UI protocol (`nvim_ui_attach`, redraw events): https://neovim.io/doc/user/api-ui-events/  
   - Official Node Neovim client (`attach`, `spawn ... --embed` examples): https://github.com/neovim/node-client

---

## Candidate inventory

### A) Prompt-editor Vim-mode packages (direct)

| Package | Latest | npm last-month | Core approach | Real nvim engine under Pi prompt? |
|---|---:|---:|---|---|
| `pi-vim` | 0.14.2 | 2672 | Replaces editor via `CustomEditor`; large Vim subset + parity testing against headless nvim | **No** |
| `pi-vimmode` | 0.9.0 | 598 | `CustomEditor` modal engine; practical prompt editing (explicitly not full parity) | **No** |
| `@0xkahi/pi-vim-keys` | 1.0.6 | 346 | `CustomEditor` + configurable leader mappings and visual modes | **No** |
| `@thazhemadam/pi-vim` | 0.1.2 | 418 | Pi adapter over host-neutral `@thazhemadam/vim-state` engine | **No** |
| `@burneikis/pi-vim` | 1.7.0 | 436 | `CustomEditor` Vim editor + optional fzfp integration | **No** |
| `vim-motions-pi` | 0.1.4 | 199 | Focused subset in one extension (`CustomEditor`) | **No** |
| `@r3b1s/pi-vim-stash` | 0.2.6 | 108 | Combined modal editor + stash feature | **No** |
| `@leohenon/pi-vim` | 0.1.4 | 103 | Single-file `CustomEditor` implementation | **No** |
| `pi-vim-flash` | 0.1.5 | 431 | Prompt Vim + transcript flash-style navigation overlay | **No** |

Primary sources: npm metadata endpoints for each package, pi.dev package pages (example: `pi-vim`, `pi-vimmode`, `pi-vim-flash`), and cloned source listed above.

### B) Neovim bridge/integration packages (not prompt-editor engine replacements)

| Package | Latest | npm last-month | What it does | Real nvim engine inside Pi prompt editor? |
|---|---:|---:|---|---|
| `pi-nvim-bridge` | 0.1.3 | 176 | Exposes Pi autocomplete to Neovim external editor via Unix socket + plugin | **No** |
| `pi-nvim` | 0.2.5 | 567 | Sends prompts/context from Neovim to active Pi session via socket | **No** |
| `@maxpaulus/pi-nvim` | 0.1.1 | 335 | Similar bidirectional Neovim↔Pi prompt/context bridge | **No** |

### C) Adjacent Vim-like UX packages (not prompt-Vim engine)

- `@johnfodero/pi-diff-review` (vim keybindings in diff review UI)  
- `@inobit/pi-reader` (vim-like fullscreen reading/navigation mode)

---

## Deep findings by package family

## 1) `pi-vim` (lajarre) — strongest current prompt-Vim implementation

- Package page states it is Vim-style modal editing for Pi, install via `pi install npm:pi-vim`: https://pi.dev/packages/pi-vim  
- Source uses Pi `CustomEditor` replacement (`ctx.ui.setEditorComponent(...)`) and a large TS modal editor (`index.ts`):  
  https://github.com/lajarre/pi-vim/blob/e55b07c05b648f3bbccf656c2b0c6ec63f1a91d1/index.ts
- It includes dedicated parity infrastructure that **spawns headless nvim as oracle** in tests (`test/nvim-oracle.ts`) rather than embedding nvim in runtime path:  
  https://github.com/lajarre/pi-vim/blob/e55b07c05b648f3bbccf656c2b0c6ec63f1a91d1/test/nvim-oracle.ts
- README explicitly documents Vim differences/limits (not full Vim runtime):  
  https://github.com/lajarre/pi-vim/blob/e55b07c05b648f3bbccf656c2b0c6ec63f1a91d1/README.md

Quality signals:
- Active repo (recent push), high stars for niche package, robust test harness, explicit divergence docs.

Conclusion:
- Best-engineered pure-reimplementation option today; still **not** actual embedded nvim engine.

## 2) `pi-vimmode` (pekochan069) and peers (`pi-vim-keys`, `vim-motions-pi`, etc.)

Common architecture pattern:
- Replace Pi editor through `ctx.ui.setEditorComponent(...)` and extend Pi `CustomEditor`.
- Keep Pi app-level keybindings by delegating unknown keys to base editor.

Evidence:
- `pi-vimmode` explicitly says it is `CustomEditor`-based and not full parity; also calls out editor-composability limitations:  
  https://pi.dev/packages/pi-vimmode
- `pi-vim-keys` package page and source show the same replacement strategy:  
  https://pi.dev/packages/%400xkahi/pi-vim-keys  
  https://github.com/0xKahi/pi-vim-keys/blob/ef4afe19136130c8ce55ce0810df47b6b304cf0c/src/index.ts
- `@thazhemadam/pi-vim` explicitly says “subset, not Vim runtime” in limitations:  
  https://github.com/thazhemadam/vim-state/blob/f95221a18e803aeca84b9666fb25056c330f16fd/packages/integrations/pi-vim/README.md

Conclusion:
- Broad ecosystem exists, but these are all **reimplementations/subsets** on top of Pi’s editor API.

## 3) `pi-vim-flash` — notable transcript-level innovation, still not nvim-engine

- Adds Flash.nvim-inspired transcript navigation plus prompt Vim flow: https://pi.dev/packages/pi-vim-flash  
- Source is still a `CustomEditor` approach (`src/index.ts`) and README documents intentional Vim differences and internal Pi API coupling risks:  
  https://github.com/kungfusaini/pi-vim-flash/blob/1a2fe12669824a17d76347cf83765ac44bdccc55/README.md

Conclusion:
- Innovative UX, but still non-engine reimplementation.

## 4) Neovim bridges (`pi-nvim-bridge`, `pi-nvim`, `@maxpaulus/pi-nvim`)

### `pi-nvim-bridge`

What it is:
- Explicitly positions itself as bridge of Pi autocomplete into external Neovim editor, with companion Neovim plugin: https://pi.dev/packages/pi-nvim-bridge
- Uses local socket + env descriptor `PI_NVIM_BRIDGE` + RPC methods; no embedded Neovim engine inside Pi prompt runtime:
  - https://github.com/dabstractor/pi-nvim-bridge/blob/5dd7e4d7c5546458bbb79a4c5ec34e70c568fe99/extension/pi-nvim-bridge.ts
  - https://github.com/dabstractor/pi-nvim-bridge/blob/5dd7e4d7c5546458bbb79a4c5ec34e70c568fe99/README.md

Quality:
- Very extensive tests (both TS and Lua test suites), detailed protocol docs, clear security notes.

### `pi-nvim` (carderne)

What it is:
- Socket bridge for Neovim plugin to send prompt/context into Pi: https://pi.dev/packages/pi-nvim
- Pi extension code confirms newline-delimited JSON socket transport and `pi.sendUserMessage(...)` behavior:  
  https://github.com/carderne/pi-nvim/blob/3efbe679fdcaac1d643d465eea56826ce335dc4a/index.ts

### `@maxpaulus/pi-nvim`

What it is:
- Similar bridge behavior plus file-change notifications from Pi tool results (`edit`/`write`):  
  https://github.com/maxpaulus43/pi-nvim/blob/210803537dd5447f663a04b4cafab453ef0db367/pi-extension/index.ts

Conclusion across Neovim bridges:
- Useful integration packages, but **not** “Pi prompt editor powered by embedded Neovim engine”. They connect separate processes.

---

## Pi architecture constraints relevant to “real Neovim-under-the-hood”

1. Pi editor extension model is replacement/decorator around a single custom editor factory (`ctx.ui.setEditorComponent`) per session; custom Vim modes are expected to extend `CustomEditor` and handle key routing there (Pi docs):
   - https://pi.dev/docs/extensions
   - https://pi.dev/docs/tui

2. Installed source confirms **single editor factory replacement semantics** (set/restore custom editor in `interactive-mode.js`), meaning extension composition is not native multi-editor stacking:
   - `/opt/homebrew/lib/node_modules/@earendil-works/pi-coding-agent/dist/modes/interactive/interactive-mode.js`

3. Pi external-editor flow (`Ctrl+G`) writes temp file, spawns `$EDITOR`, reads file back on exit (`external-editor.js`). This is process handoff, not embedded editor rendering:
   - `/opt/homebrew/lib/node_modules/@earendil-works/pi-coding-agent/dist/modes/interactive/external-editor.js`

---

## Neovim embed facts relevant to feasibility

- Neovim supports embedding via `--embed` and msgpack-rpc control channel:  
  https://neovim.io/doc/user/starting/#--embed  
  https://neovim.io/doc/user/api/
- Full UI embedding requires `nvim_ui_attach()` and redraw event handling (`redraw` batches, linegrid/multigrid, etc.):  
  https://neovim.io/doc/user/api-ui-events/
- Official Node client demonstrates spawning `nvim --embed` and controlling buffer/window APIs from JS:  
  https://github.com/neovim/node-client

Implication:
- A true Neovim-engine Pi prompt editor is technically possible, but it is a substantial systems project:
  1) run/manage embedded nvim process lifecycle per Pi session,  
  2) map Pi key/input model to nvim input semantics,  
  3) render nvim state into Pi TUI component model (or keep nvim headless and translate buffer/cursor state manually),  
  4) preserve Pi-specific app keybindings and extension behaviors,  
  5) handle clipboard, autocomplete, prompt submission, and failure modes safely.

---

## Feasibility assessment: practical integration options

### Option A (today’s ecosystem standard): Reimplementation on `CustomEditor`

- Pros: native Pi integration, simple deploy, no subprocess protocol complexity.
- Cons: perpetual parity maintenance burden; incomplete Vim semantics likely.

### Option B (already real and useful): External-editor Neovim + bridge

- Use Pi external editor and packages like `pi-nvim-bridge` for Pi-faithful completion in Neovim.
- Pros: gets real Neovim UX with lower risk to Pi core prompt pipeline.
- Cons: not inline/in-prompt modal editing in Pi TUI itself.

### Option C (future “true engine under the hood”): embedded nvim backend for prompt

- Feasible with Neovim `--embed` + RPC APIs, but high complexity and maintenance cost.
- No package currently appears to deliver this end-to-end in Pi prompt editor path.

---

## Recommendation

If you want the best current **in-Pi Vim-like prompt editing**, choose one of the mature `CustomEditor` implementations (most complete appears to be `pi-vim`; `pi-vimmode`/`pi-vim-flash` offer different tradeoffs).  

If your goal is **actual Neovim semantics**, prefer the **external-editor + bridge** model (`pi-nvim-bridge` specifically for completion fidelity), because it uses real Neovim directly and is already productionized.  

If your goal is **true embedded Neovim under Pi’s inline prompt editor**, this appears to be a greenfield implementation opportunity; I found **no existing package that already does this**.

---

## Final explicit answer to the core question

> **Do any existing Pi Vim-related packages embed/run actual Neovim/Vim engine for the in-TUI prompt editor, instead of reimplementing a subset?**

**No, none found in this research.** Existing packages are either:
1) `CustomEditor` Vim-like reimplementations/subsets, or  
2) Neovim bridge integrations that connect to external Neovim processes.

---

## Appendix: install/use quick refs (from package docs)

- `pi-vim`: `pi install npm:pi-vim` — https://pi.dev/packages/pi-vim  
- `pi-vimmode`: `pi install npm:pi-vimmode` — https://pi.dev/packages/pi-vimmode  
- `pi-vim-flash`: `pi install npm:pi-vim-flash` — https://pi.dev/packages/pi-vim-flash  
- `@0xkahi/pi-vim-keys`: `pi install npm:@0xkahi/pi-vim-keys` — https://pi.dev/packages/%400xkahi/pi-vim-keys  
- `pi-nvim-bridge`: `pi install npm:pi-nvim-bridge` — https://pi.dev/packages/pi-nvim-bridge  
- `pi-nvim`: `pi install npm:pi-nvim` — https://pi.dev/packages/pi-nvim  
- `@maxpaulus/pi-nvim`: `pi install npm:@maxpaulus/pi-nvim` (npm page) — https://www.npmjs.com/package/@maxpaulus/pi-nvim
