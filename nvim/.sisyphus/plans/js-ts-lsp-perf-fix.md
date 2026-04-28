# Fix JS/TS LSP, Formatting & ESLint Performance Issues

## TL;DR

> **Quick Summary**: Eliminate triple-execution of ESLint (LSP + nvim-lint + conform-as-formatter) that causes eslint_d timeouts and slow saves; switch JS/TS formatting to `oxfmt`-only; lighten heavy `before_init` in eslint LSP that slows attach; add mason-tool-installer for portability.
>
> **Deliverables**:
> - eslint LSP is the only ESLint runner (live diagnostics + code actions preserved)
> - `oxfmt` is the only formatter for JS/TS/JSX/TSX (sub-100ms typical)
> - Format-on-save: synchronous, ≤500ms timeout, with `:FormatDisable`/`:FormatEnable` escape hatch
> - eslint LSP attach time reduced (drop `globpath`-based flat-config detection)
> - `:EslintFixAll` keybind added (replaces eslint_d-as-formatter auto-fix)
> - mason-tool-installer auto-installs `vscode-eslint-language-server`, `typescript-language-server`, `oxfmt`, `prettierd`, `stylua`, `djlint`, `ember-template-lint`
> - Vue/Svelte removed from `ts_ls` AND `eslint_ls` filetypes
> - nvim-lint kept for `djlint` (handlebars) + `ember` (glimmer); eslint_d stripped from it
> - Git checkpoint at start; baseline + post-change measurement for objective comparison
>
> **Estimated Effort**: Medium
> **Parallel Execution**: YES — 5 waves
> **Critical Path**: T0 → T1 → T2 → T4 → T6/T7/T8/T9 (parallel) → T10 → T11 → F1-F4 → user okay

---

## Context

### Original Request
User reports issues in nvim config when editing JS/TS/JSX/TSX:
1. LSP and formatting issues
2. eslint_d times out
3. File formatting loading is super slow

### Interview Summary

**Key Discussions**:
- Wants live ESLint diagnostics as they type (keep LSP, drop other eslint runners)
- Format-on-save sync but FAST — short timeout, single fast formatter
- Uses `oxfmt` as primary JS/TS formatter (already in config as fallback)
- Does NOT edit Vue/Svelte
- Works in pnpm monorepos with workspaces (`@repo/*` scope)
- Wants mason-tool-installer for self-bootstrapping config
- Wants `update_in_insert = true` (live diagnostic display)
- Specific LSP symptom observed: slow LSP attach to new buffers
- Verification: Agent-Executed QA only (interactive_bash + nvim --headless)

**Research Findings**:
- This is **Neovim 0.11+ native LSP config** (`vim.lsp.enable()` + `lsp/*.lua`), NOT lspconfig
- `mason-lspconfig.nvim` is NOT needed (lspconfig bridge); use `mason-tool-installer.nvim` directly
- ESLint runs via THREE channels concurrently: LSP `run="onType"`, nvim-lint on `BufEnter`/`BufReadPost`/`InsertLeave`, conform `eslint_d --fix-to-stdout` on save
- `eslint_ls.lua:100-120` uses `vim.fn.globpath()` recursively scanning workspace for flat-config files — slowest call in attach path
- `eslint_ls.lua:35` sets `client.server_capabilities.document_formatting = true` (conflicts with conform-only design)
- `conform.lua:50` `:Format` command uses `lsp_fallback = true`, but `format_on_save` (line 22) uses `lsp_fallback = false` — inconsistent
- `nvim-lint.lua` ALSO handles `djlint` for handlebars and `ember-template-lint` for `.gjs/.gts` — removing the plugin entirely would break those
- Vue/Svelte filetypes appear in BOTH `ts_ls.lua:9-10` AND `eslint_ls.lua:24-25` (dead attaches without proper Vue/Svelte LSPs)
- vscode-eslint-language-server v3+ auto-detects flat config — manual flat-config detection block likely obsolete

### Metis Review

**Identified Gaps** (addressed in this plan):
- nvim-lint also handles djlint + ember-template-lint → strip eslint_d only, preserve plugin
- Vue/Svelte cleanup must happen in BOTH `ts_ls.lua` AND `eslint_ls.lua`
- Losing `eslint_d --fix-to-stdout` = losing eslint auto-fix on save → add `:EslintFixAll` keybind as escape hatch
- `eslint_ls.lua:35` `document_formatting = true` conflicts with conform-only design → flip to false
- `:Format` command `lsp_fallback` inconsistency → align to false
- Missing baseline measurement → add as Task 1 (before any change)
- Missing git checkpoint → add as Task 0
- 500ms timeout may be too tight for cold oxfmt start → empirical validation in QA, fallback 1000ms
- Disposable test fixture at `/tmp/lsp-perf-fixture/` — never mutate user's real project
- mason-tool-installer requires direct package names (not lspconfig names)
- ts_ls lag in JSX is a separate concern (typescript-language-server itself), out of scope — known limitation surfaced
- `update_in_insert = true` × `run = "onType"` flickers virtual_text per keystroke — known tradeoff per user choice

---

## Work Objectives

### Core Objective
Reduce eslint_d timeouts and slow JS/TS save latency by eliminating triple ESLint execution; lighten eslint LSP attach; standardize on `oxfmt` as JS/TS formatter; preserve all current linting/formatting coverage for non-JS filetypes (handlebars, glimmer, lua, css, etc.).

### Concrete Deliverables
- `lua/plugins/code/mason.lua` modified to load `mason-tool-installer.nvim` with explicit tool list
- `lsp/ts_ls.lua` filetypes reduced to JS/TS/JSX/TSX only
- `lsp/eslint_ls.lua` filetypes mirrored, `before_init` flat-config block removed, `document_formatting = false`
- `lua/plugins/code/conform.lua` rewritten: `oxfmt`-only for JS/TS/JSX/TSX, function-form `format_on_save` with `vim.g.disable_autoformat` toggle, `:FormatDisable`/`:FormatEnable` user commands, `:Format` `lsp_fallback = false`
- `lua/plugins/code/nvim-lint.lua` stripped of all `eslint_d` references, autocmd simplified to `BufWritePost` only for handlebars/glimmer
- `lua/config/lsp.lua` adds `<leader>cf` keybind for `:EslintFixAll` (replacement for lost eslint_d auto-fix)
- `.sisyphus/evidence/baseline-*.log` and `.sisyphus/evidence/post-change-*.log` measurement files
- All QA scenarios pass agent-executed verification

### Definition of Done
- [ ] `nvim --headless -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' -c 'lua vim.defer_fn(function() print(#vim.lsp.get_clients()); vim.cmd("qa!") end, 3000)'` shows ts_ls + eslint_ls only (no eslint_d as separate process)
- [ ] Format-on-save measured at < 500ms p50 in QA fixture
- [ ] LSP attach time reduced ≥ 30% vs baseline
- [ ] `nvim_lint.linters_by_ft.typescript` is `nil` (or absent), `conform.list_formatters_to_run(0)` shows `oxfmt` only on `.tsx`
- [ ] `:checkhealth` shows no errors related to mason/lsp/conform/nvim-lint
- [ ] All AC-1 through AC-8 (defined in Verification Strategy) pass

### Must Have
- Live ESLint diagnostics in JS/TS/JSX/TSX (provided by `eslint_ls`)
- ESLint code actions still available (e.g. `vim.lsp.buf.code_action()` exposes `source.fixAll.eslint`)
- TypeScript diagnostics + completion + go-to-definition still work via `ts_ls`
- Format-on-save still triggers automatically for js/ts/jsx/tsx/lua/css/html/markdown/json
- Handlebars `djlint` linting + Glimmer `ember-template-lint` still work via nvim-lint
- pnpm monorepo workspace root detection works correctly
- Existing keybinds in `lsp.lua` (gd, grr, grh, grv) still work
- Mason auto-installs all required tools on first launch (idempotent on re-launch)
- Git history reflects atomic, revertable commits (one per task)

### Must NOT Have (Guardrails)
- ❌ NO use of `mason-lspconfig.nvim` (this config uses native 0.11 LSP discovery)
- ❌ NO calls to `vim.fn.globpath()` in `eslint_ls.lua` `before_init` (slow recursive scan)
- ❌ NO `eslint_d` references anywhere in `conform.lua` or `nvim-lint.lua`
- ❌ NO `vue` or `svelte` in any LSP `filetypes` list (removed from ts_ls AND eslint_ls)
- ❌ NO `lsp_fallback = true` in any conform configuration (conform handles all formatting; LSP formatting disabled)
- ❌ NO `client.server_capabilities.document_formatting = true` in `eslint_ls.lua` `on_attach`
- ❌ NO modifications to user's actual project files during QA (use `/tmp/lsp-perf-fixture/` only)
- ❌ NO new test framework (plenary etc.) — Agent-Executed QA only
- ❌ NO scope creep into other LSPs (lua_ls, css_ls, json_ls, etc.)
- ❌ NO modifications to `vim.opt.updatetime` or other unrelated settings
- ❌ NO `format_after_save` (user explicitly chose sync)
- ❌ NO removal of `nvim-lint` plugin (only strip eslint_d entries — preserve djlint/ember)
- ❌ NO bumping `format_on_save.timeout_ms` above 1000ms (defeats the perf goal)
- ❌ NO direct `nvim-lspconfig` usage anywhere
- ❌ NO premature abstraction (extract-to-utility) — keep changes inline and obvious

---

## Verification Strategy (MANDATORY)

> **ZERO HUMAN INTERVENTION** — ALL verification is agent-executed.

### Test Decision
- **Infrastructure exists**: NO (nvim config has no test framework)
- **Automated tests**: NONE (would require plenary.nvim setup, out of scope per user)
- **Framework**: N/A
- **All verification**: Agent-Executed QA via `interactive_bash` (tmux + nvim) and `nvim --headless`

### QA Policy
Every implementation task MUST include agent-executed QA scenarios. Evidence saved to `.sisyphus/evidence/task-{N}-{scenario-slug}.{ext}`. Tools used:

- **TUI/CLI verification**: `interactive_bash` (tmux session running nvim)
- **Headless measurement**: Bash with `nvim --headless --startuptime ... -c 'lua ...' -c 'qa!'`
- **File state assertions**: `Bash` with `cat`/`diff`/`grep` on fixture files
- **Process inspection**: `Bash` with `ps aux | grep eslint_d` to verify no zombie daemons

### Test Fixture
Disposable fixture created at `/tmp/lsp-perf-fixture/` containing:
- `package.json` with `eslint`, `typescript`, `@types/react` deps
- `tsconfig.json` with JSX support
- `eslint.config.js` (flat config) with `no-var`, `no-unused-vars` rules
- `pnpm-workspace.yaml` (simulates monorepo)
- `src/sample.tsx` with intentional violations (e.g. `var x = 1; const unused = 'foo'`)

User's actual repos are NEVER modified during QA.

### Acceptance Criteria Library (referenced by tasks)

- **AC-1**: Single eslint execution path — only eslint_ls + ts_ls attached, conform lists oxfmt only
- **AC-2**: Format-on-save uses oxfmt only, < 500ms — measured via tmux + `:lua hrtime()` diff
- **AC-3**: eslint_ls live diagnostics on type — diagnostic count ≥ 1 after typing eslint violation
- **AC-4**: No vue/svelte LSP attach attempts — `#vim.lsp.get_clients({bufnr=vue_buf})` is 0
- **AC-5**: mason-tool-installer ensures all required tools — `mason-registry.is_installed()` returns true for each
- **AC-6**: Startup time regression check — `nvim --startuptime` after ≤ before + 50ms tolerance
- **AC-7**: eslint_ls before_init no longer scans node_modules — no `globpath` in startup profile
- **AC-8**: Plugin removal hygiene — git diff shows expected file modifications only

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Pre-flight, parallel — 4 tasks):
├── Task 0: Git checkpoint + Neovim version assertion [quick]
├── Task 1: Create disposable test fixture at /tmp/lsp-perf-fixture/ [quick]
├── Task 2: Capture baseline measurements (LSP attach + format latency + startup) [quick]
└── Task 3: Verify oxfmt is in mason-registry; document fallback [quick]

Wave 2 (depends Wave 1):
└── Task 4: Add mason-tool-installer plugin to mason.lua, configure required tool list [quick]

Wave 3 (Gate — depends Task 4):
└── Task 5: Run mason install + verify all tools present (AC-5) [quick]

Wave 4 (File edits, parallel — 4 tasks, each touches different file):
├── Task 6: Rewrite ts_ls.lua (remove vue/svelte filetypes, fix capabilities API names) [quick]
├── Task 7: Rewrite eslint_ls.lua (filetypes, before_init reduction, document_formatting=false) [unspecified-high]
├── Task 8: Rewrite conform.lua (oxfmt-only for JS/TS, FormatDisable/Enable, function-form, :Format consistency) [unspecified-high]
└── Task 9: Strip eslint_d from nvim-lint.lua (preserve djlint/ember, simplify autocmd) [quick]

Wave 5 (depends Wave 4):
└── Task 10: Add :EslintFixAll keybind in lsp.lua (escape hatch for losing eslint --fix on save) [quick]

Wave 6 (Verification, depends Task 10):
└── Task 11: Run AC-1 through AC-8 sequentially, capture evidence; final measurement diff vs baseline [unspecified-high]

Wave FINAL (parallel reviews — 4 agents):
├── Task F1: Plan compliance audit (oracle)
├── Task F2: Code quality review (unspecified-high)
├── Task F3: Real manual QA (unspecified-high)
└── Task F4: Scope fidelity check (deep)
-> Present results -> Get explicit user okay

Critical Path: T0 → T2 → T4 → T5 → T7/T8 (parallel max) → T10 → T11 → F1-F4 → user okay
Parallel Speedup: ~50% over sequential (file edits in Wave 4 parallelize)
Max Concurrent: 4 (Waves 1 & 4)
```

### Dependency Matrix

- **0**: blocks 4, 6-9 / blocked by — none
- **1**: blocks 2, 11 / blocked by — none
- **2**: blocks 11 / blocked by 1
- **3**: blocks 4 / blocked by — none
- **4**: blocks 5 / blocked by 0, 3
- **5**: blocks 6-9 / blocked by 4
- **6**: blocks 11 / blocked by 0, 5
- **7**: blocks 11 / blocked by 0, 5
- **8**: blocks 10, 11 / blocked by 0, 5
- **9**: blocks 11 / blocked by 0, 5
- **10**: blocks 11 / blocked by 8
- **11**: blocks F1-F4 / blocked by 6, 7, 8, 9, 10
- **F1-F4**: block user okay / blocked by 11

### Agent Dispatch Summary

- **Wave 1**: 4 — T0 → `quick`, T1 → `quick`, T2 → `quick`, T3 → `quick`
- **Wave 2**: 1 — T4 → `quick`
- **Wave 3**: 1 — T5 → `quick`
- **Wave 4**: 4 — T6 → `quick`, T7 → `unspecified-high`, T8 → `unspecified-high`, T9 → `quick`
- **Wave 5**: 1 — T10 → `quick`
- **Wave 6**: 1 — T11 → `unspecified-high`
- **Wave FINAL**: 4 — F1 → `oracle`, F2 → `unspecified-high`, F3 → `unspecified-high`, F4 → `deep`

---

## TODOs

> Each task = atomic, single-file scope (except T0/T11 which span). Each task has agent profile + parallelization + QA.

- [ ] 0. **Git checkpoint + Neovim version assertion**

  **What to do**:
  - Run `git -C /Users/nicola.bertelloni/.config/nvim status` to confirm working tree state
  - Run `git -C /Users/nicola.bertelloni/.config/nvim add -A && git -C /Users/nicola.bertelloni/.config/nvim commit -m 'chore(nvim): checkpoint before LSP perf fix'`
  - Capture commit SHA → save to `.sisyphus/evidence/checkpoint-sha.txt`
  - Run `nvim --version | head -1` and assert version ≥ 0.11 — fail task if lower

  **Must NOT do**:
  - Do NOT modify any config files in this task
  - Do NOT run `:Lazy sync` or any plugin operations
  - Do NOT push to remote

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Pure shell + git operation, no decision-making required
  - **Skills**: `[]`
    - None needed; trivial git commands

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 2, 3)
  - **Blocks**: Tasks 4, 6, 7, 8, 9 (file modifications need a checkpoint to revert to)
  - **Blocked By**: None (start immediately)

  **References**:
  - **Pattern References**: None — standard git workflow
  - **External References**: None
  - **WHY Each Reference Matters**: N/A — trivial task

  **Acceptance Criteria**:
  - [ ] `git -C ~/.config/nvim log -1 --format=%s` outputs `chore(nvim): checkpoint before LSP perf fix`
  - [ ] `.sisyphus/evidence/checkpoint-sha.txt` exists and contains a valid 7+ char SHA
  - [ ] `nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+'` outputs version ≥ 0.11

  **QA Scenarios**:
  ```
  Scenario: Checkpoint commit created
    Tool: Bash
    Preconditions: Working tree may have uncommitted changes (we commit them all)
    Steps:
      1. cd ~/.config/nvim && git log -1 --format='%H %s'
      2. Assert: output matches /^[a-f0-9]{40} chore\(nvim\): checkpoint before LSP perf fix$/
      3. cat .sisyphus/evidence/checkpoint-sha.txt
      4. Assert: contents match the SHA from step 1 (first 7+ chars)
    Expected Result: Both git log and checkpoint-sha.txt agree on the SHA
    Failure Indicators: git log shows different commit; checkpoint file missing
    Evidence: .sisyphus/evidence/task-0-checkpoint-sha.txt

  Scenario: Neovim version is sufficient
    Tool: Bash
    Preconditions: nvim binary on PATH
    Steps:
      1. nvim --version | head -1 > .sisyphus/evidence/task-0-nvim-version.txt
      2. version=$(grep -oE '[0-9]+\.[0-9]+' .sisyphus/evidence/task-0-nvim-version.txt | head -1)
      3. Assert: version is ≥ 0.11 (compare major.minor)
    Expected Result: 'NVIM v0.11.x' or higher recorded
    Failure Indicators: nvim missing; version < 0.11
    Evidence: .sisyphus/evidence/task-0-nvim-version.txt
  ```

  **Commit**: YES
  - Message: `chore(nvim): checkpoint before LSP perf fix`
  - Files: All currently modified files in `~/.config/nvim/`
  - Pre-commit: `nvim --headless -c 'qa!' 2>&1` exits 0 (smoke test config still loads)

- [ ] 1. **Create disposable test fixture at /tmp/lsp-perf-fixture/**

  **What to do**:
  - `mkdir -p /tmp/lsp-perf-fixture/src` and `/tmp/lsp-perf-fixture/templates`
  - Write `package.json` with `{ "name": "lsp-perf-fixture", "private": true, "devDependencies": { "eslint": "^9.0.0", "typescript": "^5.4.0", "@types/react": "^18.0.0" } }`
  - Write `tsconfig.json` with `{ "compilerOptions": { "target": "ES2022", "module": "ESNext", "jsx": "preserve", "strict": true, "esModuleInterop": true, "skipLibCheck": true } }`
  - Write `eslint.config.js` (flat config) with rules `no-var: error`, `no-unused-vars: warn`
  - Write `pnpm-workspace.yaml` with `packages: ['packages/*']` (simulates monorepo)
  - Write `src/sample.tsx`: `var x: number = 1; const unused = 'foo'; export const Hello = () => <div>{x}</div>;`
  - Write `templates/test.hbs`: `<div>{{name}}</div>` (for djlint coverage testing)
  - Run `cd /tmp/lsp-perf-fixture && pnpm install --ignore-scripts` (best-effort; OK if fails — LSP doesn't strictly need node_modules for the fixture eslint server tests if eslint binary on PATH)

  **Must NOT do**:
  - Do NOT use ANY path inside the user's actual projects (only `/tmp/lsp-perf-fixture/`)
  - Do NOT install global packages or modify system state
  - Do NOT add the fixture path to user's nvim config

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Pure file scaffolding from a known template
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 0, 2, 3)
  - **Blocks**: Tasks 2, 11 (need fixture to measure / verify)
  - **Blocked By**: None

  **References**:
  - **Pattern References**: None — fresh fixture
  - **External References**:
    - eslint flat config: `https://eslint.org/docs/latest/use/configure/configuration-files`
    - tsconfig.json reference: `https://www.typescriptlang.org/tsconfig`
  - **WHY Each Reference Matters**: Fixture must use modern flat-config (eslint 9+) to validate that our `before_init` flat-config block REMOVAL doesn't break attachment.

  **Acceptance Criteria**:
  - [ ] `/tmp/lsp-perf-fixture/{package.json,tsconfig.json,eslint.config.js,pnpm-workspace.yaml,src/sample.tsx,templates/test.hbs}` all exist
  - [ ] `cat /tmp/lsp-perf-fixture/eslint.config.js | head -1` shows valid JS (no syntax error)
  - [ ] `cat /tmp/lsp-perf-fixture/src/sample.tsx | grep -c 'var '` returns 1 (intentional violation present)

  **QA Scenarios**:
  ```
  Scenario: All fixture files exist with expected content
    Tool: Bash
    Preconditions: /tmp writable
    Steps:
      1. ls -la /tmp/lsp-perf-fixture/
      2. for f in package.json tsconfig.json eslint.config.js pnpm-workspace.yaml src/sample.tsx templates/test.hbs; do test -f /tmp/lsp-perf-fixture/$f || echo MISSING:$f; done
      3. node -e 'JSON.parse(require("fs").readFileSync("/tmp/lsp-perf-fixture/package.json"))' (validates package.json)
    Expected Result: All files present, no MISSING output, package.json parses as valid JSON
    Failure Indicators: Any MISSING:* line; node parse error
    Evidence: .sisyphus/evidence/task-1-fixture-tree.txt (output of `find /tmp/lsp-perf-fixture -type f`)
  ```

  **Commit**: NO (fixture is outside repo)

- [ ] 2. **Capture baseline measurements (LSP attach + format latency + startup)**

  **What to do**:
  - Capture nvim startup time: `nvim --headless --startuptime .sisyphus/evidence/baseline-startup.log -c 'qa!'`
  - Capture LSP attach time on the fixture (run after Task 1 completes):
    ```bash
    nvim --headless -u ~/.config/nvim/init.lua \
      -c 'lua local s=vim.uv.hrtime(); vim.api.nvim_create_autocmd("LspAttach", { callback = function(args) local elapsed=(vim.uv.hrtime()-s)/1e6; local f=io.open(".sisyphus/evidence/baseline-attach.log","a"); f:write(string.format("%s %.2fms\n", vim.lsp.get_client_by_id(args.data.client_id).name, elapsed)); f:close() end });vim.cmd.edit("/tmp/lsp-perf-fixture/src/sample.tsx")' \
      -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 6000)'
    ```
  - Capture format-on-save latency on the fixture: open `sample.tsx`, time `:w` 5 times, log to `.sisyphus/evidence/baseline-save.log`
  - Count active eslint processes: `ps aux | grep -E 'eslint_d|vscode-eslint' | grep -v grep | tee .sisyphus/evidence/baseline-eslint-procs.log | wc -l`

  **Must NOT do**:
  - Do NOT modify any nvim config files in this task
  - Do NOT delete prior evidence files
  - Do NOT measure user's actual project (only fixture)

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Mechanical capture of measurements; no decision-making
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: NO (depends on Task 1 fixture existing)
  - **Parallel Group**: Wave 1 (after Task 1)
  - **Blocks**: Task 11 (final comparison)
  - **Blocked By**: Task 1

  **References**:
  - **Pattern References**:
    - `lua/config/lsp.lua:35-67` — LspAttach autocmd pattern (mirror this for measurement)
  - **WHY Each Reference Matters**: Use the same LspAttach hook the user's config uses to time when LSPs attach. This gives an apples-to-apples baseline.

  **Acceptance Criteria**:
  - [ ] `.sisyphus/evidence/baseline-startup.log` exists, last line shows total startup ms
  - [ ] `.sisyphus/evidence/baseline-attach.log` exists, contains ≥1 LSP name + elapsed ms
  - [ ] `.sisyphus/evidence/baseline-save.log` exists, contains 5 timestamps
  - [ ] `.sisyphus/evidence/baseline-eslint-procs.log` exists — documents current zombie process count (we expect this to be > 0 right now due to triple execution)

  **QA Scenarios**:
  ```
  Scenario: All baseline files captured
    Tool: Bash
    Preconditions: Task 1 complete (fixture exists)
    Steps:
      1. ls .sisyphus/evidence/baseline-*.log | wc -l
      2. Assert: count >= 4
      3. tail -1 .sisyphus/evidence/baseline-startup.log | grep -oE '[0-9]+\.[0-9]+'
      4. Assert: a numeric ms value is present
    Expected Result: 4 baseline log files, startup log has timing data
    Failure Indicators: Any log file missing or empty
    Evidence: .sisyphus/evidence/task-2-baseline-summary.txt (output of `wc -l .sisyphus/evidence/baseline-*.log`)
  ```

  **Commit**: NO (evidence only; commit at end of Task 11 if `.sisyphus/evidence/` is tracked)

- [ ] 3. **Verify oxfmt + required tools are in mason-registry**

  **What to do**:
  - Run `nvim --headless -c 'lua vim.defer_fn(function() local r=require("mason-registry"); for _,t in ipairs({"vscode-eslint-language-server","typescript-language-server","oxfmt","prettierd","stylua","djlint","ember-template-lint"}) do print(t..":", pcall(r.get_package, t)) end; vim.cmd("qa!") end, 3000)' 2>&1 | tee .sisyphus/evidence/task-3-mason-availability.log`
  - Inspect output: each tool should print `<name>: true` (package exists in registry)
  - For any package showing `false`, document a fallback in `.sisyphus/evidence/task-3-fallbacks.md`:
    - `oxfmt` fallback: `cargo install oxc-fmt` OR `npm install -g oxfmt` (verify which exists)
    - Other tools should all be present in registry

  **Must NOT do**:
  - Do NOT actually install anything in this task (Task 5 does that via mason-tool-installer)
  - Do NOT modify mason.lua in this task

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Read-only registry check + decision tree for fallback
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 0, 1, 2)
  - **Blocks**: Task 4 (mason-tool-installer config needs to know which packages are valid registry names)
  - **Blocked By**: None

  **References**:
  - **External References**:
    - mason-registry: `https://github.com/mason-org/mason-registry`
    - mason-tool-installer docs: `https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim`
  - **WHY Each Reference Matters**: mason-tool-installer requires exact registry package names. If `oxfmt` is missing, we need an alternative install path before Task 4.

  **Acceptance Criteria**:
  - [ ] `.sisyphus/evidence/task-3-mason-availability.log` lists all 7 tools with `true`/`false`
  - [ ] If any tool is `false`, `.sisyphus/evidence/task-3-fallbacks.md` documents the fallback install command

  **QA Scenarios**:
  ```
  Scenario: All required tools resolvable in mason-registry
    Tool: Bash
    Preconditions: nvim with mason.nvim plugin already installed
    Steps:
      1. cat .sisyphus/evidence/task-3-mason-availability.log
      2. for tool in vscode-eslint-language-server typescript-language-server oxfmt prettierd stylua djlint ember-template-lint; do grep -q "$tool: true" .sisyphus/evidence/task-3-mason-availability.log || echo MISSING_OR_FALSE:$tool; done
    Expected Result: No MISSING_OR_FALSE lines; if any exist, .sisyphus/evidence/task-3-fallbacks.md documents fallback for each
    Failure Indicators: A tool printed false AND no fallback documented
    Evidence: .sisyphus/evidence/task-3-mason-availability.log + (optional) task-3-fallbacks.md
  ```

  **Commit**: NO (evidence only)

- [ ] 4. **Add mason-tool-installer plugin and configure required tool list**

  **What to do**:
  - Replace `lua/plugins/code/mason.lua` to load mason.nvim AND `WhoIsSethDaniel/mason-tool-installer.nvim`
  - mason-tool-installer config:
    ```lua
    require("mason-tool-installer").setup({
      ensure_installed = {
        "vscode-eslint-language-server",
        "typescript-language-server",
        "oxfmt",
        "prettierd",
        "stylua",
        "djlint",
        "ember-template-lint",
        "lua-language-server",
        "json-lsp",
        "yaml-language-server",
        "html-lsp",
        "css-lsp",
        "emmet-language-server",
        "marksman",
        "graphql-language-service-cli",
        "pyright",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000, -- avoid blocking startup
    })
    ```
  - mason.lua structure: return a table that lazy.nvim treats as a plugin spec list (mason as primary, mason-tool-installer as dependency)
  - Use lazy `event = "VeryLazy"` for mason-tool-installer to defer install scan past startup-critical path
  - For any tool missing from mason-registry per Task 3, follow the documented fallback BEFORE this task

  **Must NOT do**:
  - Do NOT add `mason-lspconfig.nvim` (this config uses native LSP discovery)
  - Do NOT use `automatic_installation` (deprecated; use `ensure_installed`)
  - Do NOT include `eslint_d` in the tools list (we are removing all eslint_d usage)
  - Do NOT change `lazy = false` for mason itself (must be eager so registry is ready when LSPs need it)

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Single file rewrite from a known template; no architectural decisions left
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: NO (single Wave 2 task, gates Wave 3-4)
  - **Parallel Group**: Wave 2
  - **Blocks**: Task 5 (verification of installation)
  - **Blocked By**: Tasks 0, 3

  **References**:
  - **Pattern References**:
    - `lua/plugins/code/mason.lua` — current minimal setup; replace it
    - `lua/plugins/code/conform.lua:1-5` — plugin spec table return shape (follow same pattern)
  - **External References**:
    - mason-tool-installer README: `https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim#configuration`
  - **WHY Each Reference Matters**: We need to keep mason eager-loaded (registry available for LSP discovery) but add a deferred installer that doesn't block startup. The conform.lua plugin pattern shows how this repo structures lazy specs.

  **Acceptance Criteria**:
  - [ ] `lua/plugins/code/mason.lua` syntactically valid (`luac -p` if available, or `nvim --headless -c 'luafile lua/plugins/code/mason.lua' -c 'qa!'`)
  - [ ] File contains `mason-tool-installer.nvim` and `ensure_installed` table with all 16 tools listed
  - [ ] File does NOT contain `mason-lspconfig`, `eslint_d`, or `automatic_installation`
  - [ ] `nvim --headless -c 'qa!'` exits 0 (no Lua errors at load)

  **QA Scenarios**:
  ```
  Scenario: mason.lua loads without errors
    Tool: Bash
    Preconditions: Task 4 file write complete
    Steps:
      1. nvim --headless -u ~/.config/nvim/init.lua -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 1000)' 2>&1 > .sisyphus/evidence/task-4-load.log
      2. test ! -s .sisyphus/evidence/task-4-load.log (empty = no errors) OR grep -v -E '^$' .sisyphus/evidence/task-4-load.log | wc -l (only acceptable warnings)
    Expected Result: Empty error output OR only mason install messages
    Failure Indicators: Any `Error:` or `E5108:` line
    Evidence: .sisyphus/evidence/task-4-load.log

  Scenario: Forbidden patterns absent
    Tool: Bash
    Steps:
      1. grep -E 'mason-lspconfig|eslint_d|automatic_installation' lua/plugins/code/mason.lua
      2. Assert: exit code 1 (no matches)
    Expected Result: No forbidden patterns in mason.lua
    Failure Indicators: grep prints any line
    Evidence: .sisyphus/evidence/task-4-forbidden-grep.txt
  ```

  **Commit**: YES
  - Message: `feat(nvim): add mason-tool-installer for self-bootstrap`
  - Files: `lua/plugins/code/mason.lua`, `lazy-lock.json` (auto-updated by lazy)
  - Pre-commit: `nvim --headless -c 'qa!'` exits 0

- [ ] 5. **Run mason install + verify all tools present (AC-5 gate)**

  **What to do**:
  - Trigger mason-tool-installer install: `nvim --headless -c 'lua vim.defer_fn(function() vim.cmd("MasonToolsInstallSync") end, 2000)' -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 120000)' 2>&1 | tee .sisyphus/evidence/task-5-install.log` (timeout 120s for cold install)
  - Verify install via mason-registry:
    ```bash
    nvim --headless -c 'lua vim.defer_fn(function() local r=require("mason-registry"); for _,t in ipairs({"vscode-eslint-language-server","typescript-language-server","oxfmt","prettierd","stylua","djlint","ember-template-lint"}) do print(t..":", r.is_installed(t)) end; vim.cmd("qa!") end, 5000)' 2>&1 | tee .sisyphus/evidence/task-5-verify.log
    ```
  - All required tools must report `true`. If any false: re-run install, then if still false, fail this task and document in `.sisyphus/evidence/task-5-failures.md`

  **Must NOT do**:
  - Do NOT proceed to Wave 4 (Tasks 6-9) until all required JS/TS tools (vscode-eslint-language-server, typescript-language-server, oxfmt) report installed
  - Do NOT use `MasonInstall` (single tool); use `MasonToolsInstallSync` (batch)

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Triggering an installer + reading its output
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: NO (gate task)
  - **Parallel Group**: Wave 3 (sole task)
  - **Blocks**: Tasks 6, 7, 8, 9
  - **Blocked By**: Task 4

  **References**:
  - **External References**:
    - mason-tool-installer commands: `:MasonToolsInstall`, `:MasonToolsInstallSync`, `:MasonToolsUpdate`
  - **WHY Each Reference Matters**: `:MasonToolsInstallSync` blocks until all tools install, which is what we need for headless verification.

  **Acceptance Criteria**:
  - [ ] `.sisyphus/evidence/task-5-verify.log` shows all 7 critical tools with `: true`
  - [ ] No tool reports `: false`

  **QA Scenarios**:
  ```
  Scenario: All critical tools installed
    Tool: Bash
    Preconditions: Task 4 complete
    Steps:
      1. cat .sisyphus/evidence/task-5-verify.log
      2. for t in vscode-eslint-language-server typescript-language-server oxfmt prettierd stylua djlint ember-template-lint; do grep -q "$t: true" .sisyphus/evidence/task-5-verify.log || echo NOT_INSTALLED:$t; done
    Expected Result: No NOT_INSTALLED:* lines
    Failure Indicators: Any tool missing
    Evidence: .sisyphus/evidence/task-5-verify.log

  Scenario: Eslint and TS binaries on PATH (sanity)
    Tool: Bash
    Steps:
      1. PATH="$HOME/.local/share/nvim/mason/bin:$PATH" which vscode-eslint-language-server typescript-language-server oxfmt > .sisyphus/evidence/task-5-which.log 2>&1
      2. test $(wc -l < .sisyphus/evidence/task-5-which.log) -ge 3
    Expected Result: All three binaries resolve
    Failure Indicators: which prints 'no X in PATH'
    Evidence: .sisyphus/evidence/task-5-which.log
  ```

  **Commit**: NO (no source changes)

- [ ] 6. **Rewrite ts_ls.lua: drop vue/svelte filetypes, fix capabilities API names**

  **What to do**:
  - Read `lsp/ts_ls.lua` current content (26 lines)
  - Reduce `filetypes` array (lines 4-11) to: `"javascript", "javascriptreact", "typescript", "typescriptreact"` (4 entries)
  - Update `on_attach` (lines 13-17): replace legacy `document_formatting`/`document_range_formatting` with modern `documentFormattingProvider`/`documentRangeFormattingProvider` (or use `vim.lsp.handlers.disable_formatting()` pattern). Final form:
    ```lua
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    ```
  - Keep `cmd`, `root_markers`, `root_dir` unchanged (they work)

  **Must NOT do**:
  - Do NOT add `vue` or `svelte` back
  - Do NOT remove `root_dir` function (pnpm monorepo support relies on it)
  - Do NOT touch `cmd = { "typescript-language-server", "--stdio" }`
  - Do NOT add `single_file_support = false` (out of scope)

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Targeted file edit with clear, small surface area
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: YES (different file from Tasks 7, 8, 9)
  - **Parallel Group**: Wave 4
  - **Blocks**: Task 11
  - **Blocked By**: Tasks 0, 5

  **References**:
  - **Pattern References**:
    - `lsp/ts_ls.lua:13-17` (current `on_attach` using legacy API names)
    - `lsp/ts_ls.lua:18-25` (root_dir using `vim.fs.root`) — keep as-is
    - `lsp/eslint_ls.lua:34-50` for an `on_attach` example with `vim.api.nvim_create_autocmd` (we don't need autocmd here, just capabilities tweak)
  - **API/Type References**:
    - Neovim 0.11 LSP capabilities: `documentFormattingProvider` is the LSP spec name; `document_formatting` was nvim's internal alias. Both work but spec name is canonical.
  - **External References**:
    - LSP spec ServerCapabilities: `https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities`
  - **WHY Each Reference Matters**: Use spec-correct property names so the disable actually takes effect across all client/server versions.

  **Acceptance Criteria**:
  - [ ] `grep -E 'vue|svelte' lsp/ts_ls.lua` exits 1 (no matches)
  - [ ] `grep -c '"javascript"\|"typescript"' lsp/ts_ls.lua` returns 4 (the 4 expected filetypes)
  - [ ] `grep 'documentFormattingProvider' lsp/ts_ls.lua` returns 1+ matches
  - [ ] File parses: `nvim --headless -c 'luafile lsp/ts_ls.lua' -c 'qa!' 2>&1` exits 0
  - [ ] Total line count change is small: `git diff --stat lsp/ts_ls.lua` shows ≤5 insertions, ≤8 deletions

  **QA Scenarios**:
  ```
  Scenario: ts_ls attaches to .tsx but not .vue
    Tool: Bash
    Preconditions: Task 5 done; fixture exists
    Steps:
      1. echo '<template>foo</template>' > /tmp/test.vue
      2. nvim --headless -u ~/.config/nvim/init.lua -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' -c 'lua vim.defer_fn(function() local clients=vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({bufnr=0})); print("tsx:"..vim.inspect(clients)); vim.cmd.edit("/tmp/test.vue"); vim.defer_fn(function() local c2=vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({bufnr=0})); print("vue:"..vim.inspect(c2)); vim.cmd("qa!") end, 2000) end, 3000)' 2>&1 > .sisyphus/evidence/task-6-attach.log
      3. grep -q 'tsx:.*ts_ls' .sisyphus/evidence/task-6-attach.log
      4. ! grep 'vue:.*ts_ls' .sisyphus/evidence/task-6-attach.log (assertion: ts_ls NOT in vue clients)
    Expected Result: ts_ls in tsx clients, ts_ls absent from vue clients
    Failure Indicators: ts_ls attached to .vue (failure); ts_ls missing from .tsx (regression)
    Evidence: .sisyphus/evidence/task-6-attach.log

  Scenario: ts_ls formatting is disabled (so conform owns it)
    Tool: Bash
    Steps:
      1. nvim --headless -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' -c 'lua vim.defer_fn(function() local cl=vim.lsp.get_clients({bufnr=0,name="ts_ls"})[1]; if cl then print("docFmtProvider="..tostring(cl.server_capabilities.documentFormattingProvider)) else print("NO_TS_LS") end; vim.cmd("qa!") end, 3000)' 2>&1 > .sisyphus/evidence/task-6-fmt.log
      2. grep -q 'docFmtProvider=false' .sisyphus/evidence/task-6-fmt.log
    Expected Result: documentFormattingProvider=false reported
    Failure Indicators: =true OR NO_TS_LS
    Evidence: .sisyphus/evidence/task-6-fmt.log
  ```

  **Commit**: YES
  - Message: `fix(nvim/lsp): drop vue/svelte filetypes from ts_ls`
  - Files: `lsp/ts_ls.lua`
  - Pre-commit: `nvim --headless -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 2000)' 2>&1` shows no errors


- [ ] 7. **Rewrite eslint_ls.lua: filetypes mirror, drop globpath, fix document_formatting**

  **What to do**:
  - Read current `lsp/eslint_ls.lua` (153 lines)
  - Update `filetypes` (lines 19-26): reduce to `"javascript", "javascriptreact", "typescript", "typescriptreact"` (mirror Task 6)
  - Fix `on_attach` (line 35): change `client.server_capabilities.document_formatting = true` → `client.server_capabilities.documentFormattingProvider = false`. Remove the commented-out `BufWritePre` autocmd block (lines 36-49) entirely (dead code).
  - Update `settings` (around line 51-84):
    - Change `run = "onType"` (line 66) to `run = "onType"` — keep per user choice (live diagnostics). Document this in a code comment: `-- run='onType' per user; diagnostics live as you type. update_in_insert=true in lsp.lua makes them visible immediately.`
    - REMOVE the `experimental = { useFlatConfig = false }` block (lines 55-57) — let modern eslint server auto-detect
  - REPLACE the `before_init` function (lines 85-130) with a slim version:
    ```lua
    before_init = function(_, config)
      local root_dir = config.root_dir
      if not root_dir then return end
      config.settings = config.settings or {}
      config.settings.workspaceFolder = {
        uri = root_dir,
        name = vim.fn.fnamemodify(root_dir, ":t"),
      }
      -- Yarn PnP support (cheap fs_stat checks; preserved)
      local pnp_cjs = root_dir .. "/.pnp.cjs"
      local pnp_js = root_dir .. "/.pnp.js"
      if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
        config.cmd = vim.list_extend({ "yarn", "exec" }, config.cmd)
      end
    end,
    ```
  - Keep `cmd`, `root_dir`, `workspace_required`, `handlers` block UNCHANGED
  - Remove the now-unused `eslint_config_files` local table (lines 2-15)

  **Must NOT do**:
  - Do NOT remove the `handlers` block (eslint/openDoc, eslint/confirmESLintExecution, eslint/probeFailed, eslint/noLibrary)
  - Do NOT remove PnP detection (cheap, valuable for Yarn2 users)
  - Do NOT change `workspace_required = true`
  - Do NOT add filesystem caching (vim.fs.root + fs_stat are already O(1))
  - Do NOT touch `vue` or `svelte` removal beyond filetypes (no other references)
  - Do NOT add `single_file_support = false` or other unrelated flags
  - Do NOT change `run = "onType"` to `"onSave"` (user wants live)
  - Do NOT remove `useESLintClass = false` or other settings the user didn't ask about

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Single file, but with multiple coordinated edits + need to preserve correct flat-config auto-detect behavior; risk of breaking eslint server protocol if structure changes
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: YES (different file from Tasks 6, 8, 9)
  - **Parallel Group**: Wave 4
  - **Blocks**: Task 11
  - **Blocked By**: Tasks 0, 5

  **References**:
  - **Pattern References**:
    - `lsp/eslint_ls.lua:85-130` (current heavy `before_init`) — the slow path to remove
    - `lsp/eslint_ls.lua:122-128` (PnP detection) — keep as-is, integrate into new before_init
    - `lsp/eslint_ls.lua:131-152` (handlers) — untouched
  - **API/Type References**:
    - vscode-eslint-language-server settings: `https://github.com/microsoft/vscode-eslint/blob/main/server/src/eslintServer.ts` (server reads `experimental.useFlatConfig` setting; auto-detects when omitted in v3+)
  - **External References**:
    - vscode-eslint flat config support: `https://github.com/microsoft/vscode-eslint/blob/main/CHANGELOG.md` (v3.0+ auto-detects)
  - **WHY Each Reference Matters**: We are removing globpath + manual flat-config detection on the assumption that the server itself does this in v3+. The QA scenario validates this against an actual eslint 9 flat-config fixture.

  **Acceptance Criteria**:
  - [ ] `grep -E 'vue|svelte' lsp/eslint_ls.lua` exits 1
  - [ ] `grep -c 'globpath\|eslint_config_files' lsp/eslint_ls.lua` returns 0
  - [ ] `grep 'documentFormattingProvider = false' lsp/eslint_ls.lua` returns 1
  - [ ] `grep 'document_formatting' lsp/eslint_ls.lua | grep -v '#'` returns 0 (legacy alias gone)
  - [ ] `grep 'pnp_cjs\|fs_stat' lsp/eslint_ls.lua` returns ≥2 (PnP detection preserved)
  - [ ] File parses: `nvim --headless -c 'luafile lsp/eslint_ls.lua' -c 'qa!'` exits 0
  - [ ] `wc -l lsp/eslint_ls.lua` shows < 100 lines (was 153 — we removed ~55 lines net)

  **QA Scenarios**:
  ```
  Scenario: eslint_ls attaches to flat-config fixture and produces diagnostics
    Tool: interactive_bash (tmux + nvim)
    Preconditions: Tasks 1, 5 done; fixture has eslint.config.js (flat) + sample.tsx with `var x`
    Steps:
      1. tmux new-session -d -s qa-eslint
      2. tmux send-keys -t qa-eslint 'cd /tmp/lsp-perf-fixture && nvim src/sample.tsx' Enter
      3. Wait 4s (LSP attach)
      4. tmux send-keys -t qa-eslint ':lua local d=vim.diagnostic.get(0); print("diag_count="..#d); for _,x in ipairs(d) do print("  "..(x.source or "?")..":"..x.message) end' Enter
      5. Wait 1s
      6. tmux capture-pane -t qa-eslint -p > .sisyphus/evidence/task-7-diagnostics.log
      7. tmux kill-session -t qa-eslint
    Expected Result: diag_count >= 1 AND at least one diagnostic source contains 'eslint'
    Failure Indicators: diag_count=0 (eslint not running) OR only ts_ls diagnostics (eslint silently failed)
    Evidence: .sisyphus/evidence/task-7-diagnostics.log

  Scenario: eslint_ls attach time improved
    Tool: Bash + nvim --headless
    Steps:
      1. nvim --headless -u ~/.config/nvim/init.lua -c 'lua local s=vim.uv.hrtime(); vim.api.nvim_create_autocmd("LspAttach", {callback=function(args) local cl=vim.lsp.get_client_by_id(args.data.client_id); if cl.name=="eslint_ls" then print(string.format("eslint_attach=%.2fms", (vim.uv.hrtime()-s)/1e6)) end end}); vim.cmd.edit("/tmp/lsp-perf-fixture/src/sample.tsx")' -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 6000)' 2>&1 > .sisyphus/evidence/task-7-attach-time.log
      2. attach_ms=$(grep -oE 'eslint_attach=[0-9.]+ms' .sisyphus/evidence/task-7-attach-time.log | head -1 | grep -oE '[0-9.]+')
      3. baseline_ms=$(grep -oE '[0-9.]+ms' .sisyphus/evidence/baseline-attach.log | head -1 | grep -oE '[0-9.]+')
      4. echo "attach=$attach_ms baseline=$baseline_ms" > .sisyphus/evidence/task-7-comparison.txt
      5. Assert: $attach_ms is at least 30% lower than $baseline_ms (use awk for arithmetic)
    Expected Result: attach_ms < 0.7 * baseline_ms
    Failure Indicators: attach_ms >= baseline_ms (no improvement)
    Evidence: .sisyphus/evidence/task-7-attach-time.log + task-7-comparison.txt

  Scenario: No globpath calls during eslint_ls init
    Tool: nvim --headless with profiling
    Steps:
      1. nvim --headless --startuptime /tmp/profile-eslint.log -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 4000)' 2>&1
      2. grep -i 'globpath' /tmp/profile-eslint.log > .sisyphus/evidence/task-7-globpath-grep.log || true
      3. test ! -s .sisyphus/evidence/task-7-globpath-grep.log (file is empty)
    Expected Result: empty grep result (no globpath in startup profile)
    Failure Indicators: any globpath line
    Evidence: .sisyphus/evidence/task-7-globpath-grep.log
  ```

  **Commit**: YES
  - Message: `perf(nvim/lsp): drop globpath flat-config detection in eslint_ls`
  - Files: `lsp/eslint_ls.lua`
  - Pre-commit: `nvim --headless -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 3000)' 2>&1` exits 0

- [ ] 8. **Rewrite conform.lua: oxfmt-only for JS/TS, FormatDisable/Enable, function-form, :Format consistency**

  **What to do**:
  - Replace `formatters_by_ft` for JS/TS variants (lines 6-9):
    ```lua
    javascript = { "oxfmt" },
    typescript = { "oxfmt" },
    javascriptreact = { "oxfmt" },
    typescriptreact = { "oxfmt" },
    ```
    (No more `eslint_d`, no `stop_after_first` since single-formatter list)
  - Keep css/scss/html/svg/handlebars/markdown using `prettierd`, json using `oxfmt`, lua using `stylua` (UNCHANGED)
  - Replace `format_on_save` (lines 20-23) with function form for the escape hatch:
    ```lua
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
      return { timeout_ms = 500, lsp_fallback = false }
    end,
    ```
  - REMOVE the `eslint_d = { ... }` formatter definition entirely (lines 26-30)
  - Keep `oxfmt` and `prettierd` formatter definitions (lines 32-41) UNCHANGED
  - In `config = function(_, opts)` (line 46+), update `:Format` user command (line 49-51): change `lsp_fallback = true` → `lsp_fallback = false` for consistency with format_on_save
  - ADD two new user commands inside `config`:
    ```lua
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
    end, { desc = "Disable autoformat-on-save", bang = true })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Re-enable autoformat-on-save" })
    ```

  **Must NOT do**:
  - Do NOT add `eslint_d` ANYWHERE in this file
  - Do NOT use `format_after_save` (user wants sync)
  - Do NOT change `event = "BufWritePre"` lazy load (it's correct)
  - Do NOT add new formatters not previously present (no biome, no prettier-non-d, etc.)
  - Do NOT bump `timeout_ms` above 1000 (defeats perf goal); 500 is target, 1000 is max fallback
  - Do NOT remove the prettierd formatter definitions or its filetype assignments
  - Do NOT introduce `lsp_fallback = true` (eslint_ls would otherwise hijack formatting)

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Multi-edit single file with critical correctness on format_on_save function; mistakes silently break autoformat
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: YES (different file)
  - **Parallel Group**: Wave 4
  - **Blocks**: Tasks 10, 11
  - **Blocked By**: Tasks 0, 5

  **References**:
  - **Pattern References**:
    - `lua/plugins/code/conform.lua:6-9` (current eslint_d-first pattern — the slow path to remove)
    - `lua/plugins/code/conform.lua:20-23` (current static format_on_save)
    - `lua/plugins/code/conform.lua:46-52` (current `:Format` command pattern — use as template for FormatDisable/Enable)
  - **API/Type References**:
    - conform.nvim format_on_save function signature: `function(bufnr): table | nil`
  - **External References**:
    - conform.nvim FormatDisable/Enable recipe: `https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#autoformat-with-extra-features`
  - **WHY Each Reference Matters**: The recipe docs show the exact pattern (`vim.g.disable_autoformat`, `vim.b[bufnr].disable_autoformat`) that conform's design expects — use the canonical names so future debugging matches docs.

  **Acceptance Criteria**:
  - [ ] `grep -c 'eslint_d' lua/plugins/code/conform.lua` returns 0
  - [ ] `grep -c 'oxfmt' lua/plugins/code/conform.lua` returns ≥5 (4 filetypes + 1 formatter def + json)
  - [ ] `grep -c 'lsp_fallback = true' lua/plugins/code/conform.lua` returns 0
  - [ ] `grep -c 'FormatDisable\|FormatEnable' lua/plugins/code/conform.lua` returns 2+
  - [ ] `grep 'format_on_save = function' lua/plugins/code/conform.lua` returns 1 (function form)
  - [ ] `grep 'timeout_ms = 500' lua/plugins/code/conform.lua` returns 1
  - [ ] File parses: `nvim --headless -c 'luafile lua/plugins/code/conform.lua' -c 'qa!'` exits 0

  **QA Scenarios**:
  ```
  Scenario: Format-on-save uses oxfmt only and completes < 500ms
    Tool: interactive_bash (tmux + nvim)
    Preconditions: Task 5 done (oxfmt installed); fixture exists
    Steps:
      1. cp /tmp/lsp-perf-fixture/src/sample.tsx /tmp/lsp-perf-fixture/src/sample.tsx.bak
      2. tmux new-session -d -s qa-fmt
      3. tmux send-keys -t qa-fmt 'cd /tmp/lsp-perf-fixture && nvim src/sample.tsx' Enter
      4. Wait 3s (lazy load conform on first BufWritePre)
      5. tmux send-keys -t qa-fmt ':lua local s=vim.uv.hrtime(); vim.cmd.write(); print(string.format("save_ms=%.2f", (vim.uv.hrtime()-s)/1e6))' Enter
      6. Wait 2s
      7. tmux capture-pane -t qa-fmt -p > .sisyphus/evidence/task-8-save-time.log
      8. tmux kill-session -t qa-fmt
      9. save_ms=$(grep -oE 'save_ms=[0-9.]+' .sisyphus/evidence/task-8-save-time.log | grep -oE '[0-9.]+')
      10. Assert: save_ms < 500
      11. diff /tmp/lsp-perf-fixture/src/sample.tsx /tmp/lsp-perf-fixture/src/sample.tsx.bak > .sisyphus/evidence/task-8-fmt-diff.txt || true
      12. Assert: diff is non-empty (file was formatted) AND does NOT contain 'unused' removal (eslint --fix did NOT run)
    Expected Result: save_ms < 500, oxfmt formatting applied, eslint auto-fix NOT applied
    Failure Indicators: save_ms >= 500; no formatting applied; unused var was removed (means eslint --fix still running somewhere)
    Evidence: .sisyphus/evidence/task-8-save-time.log + task-8-fmt-diff.txt

  Scenario: FormatDisable user command works
    Tool: interactive_bash (tmux + nvim)
    Steps:
      1. cp /tmp/lsp-perf-fixture/src/sample.tsx.bak /tmp/lsp-perf-fixture/src/sample.tsx (restore)
      2. tmux new-session -d -s qa-fmt-disable
      3. tmux send-keys -t qa-fmt-disable 'cd /tmp/lsp-perf-fixture && nvim src/sample.tsx' Enter
      4. Wait 2s
      5. tmux send-keys -t qa-fmt-disable ':FormatDisable' Enter
      6. tmux send-keys -t qa-fmt-disable 'oxxx' Escape ':w' Enter
      7. Wait 1s
      8. tmux send-keys -t qa-fmt-disable ':qa!' Enter
      9. tmux kill-session -t qa-fmt-disable 2>/dev/null || true
      10. grep -q 'xxx' /tmp/lsp-perf-fixture/src/sample.tsx (raw text preserved, not formatted)
    Expected Result: 'xxx' present in saved file (formatter did not run because disabled)
    Failure Indicators: file is formatted despite FormatDisable
    Evidence: .sisyphus/evidence/task-8-disable-test.txt (cat of saved file)
  ```

  **Commit**: YES
  - Message: `perf(nvim/format): use oxfmt-only for JS/TS, drop eslint_d formatter`
  - Files: `lua/plugins/code/conform.lua`
  - Pre-commit: `nvim --headless -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 2000)' 2>&1` exits 0


- [ ] 9. **Strip eslint_d from nvim-lint.lua: preserve djlint+ember, simplify autocmd**

  **What to do**:
  - Read current `lua/plugins/code/nvim-lint.lua` (53 lines)
  - REMOVE lines 7-15 (`eslint_d.args` override block) entirely
  - REMOVE lines 17-32 (`eslint_d.cwd` workspace walker) entirely
  - In `linters_by_ft` (lines 34-41):
    - DELETE the 4 JS/TS entries (`javascript`, `javascriptreact`, `typescript`, `typescriptreact`)
    - KEEP `handlebars = { "djlint" }` and `["javascript.glimmer"] = { "ember", "djlint" }`
  - SIMPLIFY the autocmd (lines 43-51): change events from `{ "BufEnter", "BufReadPost", "InsertLeave" }` to `{ "BufWritePost", "BufReadPost" }` (lint on save + initial read — sufficient for non-JS langs which don't need keystroke linting)
  - Final file should be ~25 lines

  **Must NOT do**:
  - Do NOT delete the plugin (we need it for djlint and ember-template-lint)
  - Do NOT remove `handlebars` or `javascript.glimmer` entries
  - Do NOT add eslint or eslint_d back in any form
  - Do NOT keep the workspace-walker function (it was only for the eslint_d cwd override)
  - Do NOT change `event = "BufReadPre"` lazy load (still needed for djlint files)

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Mostly deletion + small autocmd tweak
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: YES (different file from Tasks 6, 7, 8)
  - **Parallel Group**: Wave 4
  - **Blocks**: Task 11
  - **Blocked By**: Tasks 0, 5

  **References**:
  - **Pattern References**:
    - `lua/plugins/code/nvim-lint.lua:34-41` (current linters_by_ft — trim JS/TS, keep rest)
    - `lua/plugins/code/nvim-lint.lua:43-51` (current autocmd — simplify trigger events)
  - **External References**:
    - nvim-lint events: `https://github.com/mfussenegger/nvim-lint#usage` (BufWritePost is the canonical save-time trigger)
  - **WHY Each Reference Matters**: BufEnter triggers on every buffer/tab switch — unnecessary for save-time linters like djlint. Reducing to BufWritePost+BufReadPost gives initial-read + save coverage without per-switch overhead.

  **Acceptance Criteria**:
  - [ ] `grep -c 'eslint_d\|eslint' lua/plugins/code/nvim-lint.lua` returns 0
  - [ ] `grep 'handlebars' lua/plugins/code/nvim-lint.lua` returns 1
  - [ ] `grep 'javascript.glimmer' lua/plugins/code/nvim-lint.lua` returns 1
  - [ ] `grep -c 'BufEnter\|InsertLeave' lua/plugins/code/nvim-lint.lua` returns 0
  - [ ] `wc -l lua/plugins/code/nvim-lint.lua` shows < 30 lines
  - [ ] File parses: `nvim --headless -c 'luafile lua/plugins/code/nvim-lint.lua' -c 'qa!'` exits 0

  **QA Scenarios**:
  ```
  Scenario: nvim-lint does NOT lint JS/TS files anymore
    Tool: nvim --headless
    Preconditions: Tasks 0, 5 done; fixture exists
    Steps:
      1. nvim --headless -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' -c 'lua vim.defer_fn(function() local lint=require("lint"); local ft=vim.bo.filetype; print("ft="..ft); print("linters="..vim.inspect(lint.linters_by_ft[ft] or {})); vim.cmd("qa!") end, 2000)' 2>&1 > .sisyphus/evidence/task-9-jsts.log
      2. grep -q 'linters={}' .sisyphus/evidence/task-9-jsts.log OR grep -q 'linters=nil' .sisyphus/evidence/task-9-jsts.log
    Expected Result: linters table for typescriptreact is empty/nil
    Failure Indicators: any linter listed for typescriptreact
    Evidence: .sisyphus/evidence/task-9-jsts.log

  Scenario: nvim-lint STILL lints handlebars via djlint (regression check)
    Tool: nvim --headless
    Steps:
      1. nvim --headless -c 'edit /tmp/lsp-perf-fixture/templates/test.hbs' -c 'lua vim.defer_fn(function() local lint=require("lint"); local ft=vim.bo.filetype; print("ft="..ft); print("linters="..vim.inspect(lint.linters_by_ft[ft] or {})); vim.cmd("qa!") end, 2000)' 2>&1 > .sisyphus/evidence/task-9-hbs.log
      2. grep -q 'djlint' .sisyphus/evidence/task-9-hbs.log
    Expected Result: linters list for handlebars contains djlint
    Failure Indicators: empty linters list for handlebars (regression — user lost djlint coverage)
    Evidence: .sisyphus/evidence/task-9-hbs.log
  ```

  **Commit**: YES
  - Message: `refactor(nvim/lint): strip eslint_d, preserve djlint+ember coverage`
  - Files: `lua/plugins/code/nvim-lint.lua`
  - Pre-commit: `nvim --headless -c 'qa!'` exits 0

- [ ] 10. **Add :EslintFixAll keybind in lsp.lua (escape hatch for losing eslint --fix on save)**

  **What to do**:
  - In `lua/config/lsp.lua`, inside the `LspAttach` autocmd callback (after line 65), append a buffer-local keybind for triggering eslint's source.fixAll code action:
    ```lua
    -- Manual eslint --fix (replaces eslint_d formatter that ran on save before)
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
        apply = true,
      })
    end, { desc = "LSP: ESLint Fix All (manual)" })
    
    -- User command alias
    vim.api.nvim_buf_create_user_command(0, "EslintFixAll", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
        apply = true,
      })
    end, { desc = "Run ESLint source.fixAll on current buffer" })
    ```
  - Place AFTER existing `gd`/`grr`/`grh`/`grv` keybinds, BEFORE the autocmd callback's closing `end`

  **Must NOT do**:
  - Do NOT change global `<leader>cf` if already bound elsewhere (check `lua/config/keymaps.lua` first; if collision, document and ask user)
  - Do NOT modify the existing keybinds (gd, grr, grh, grv)
  - Do NOT modify `vim.diagnostic.config` block
  - Do NOT modify `vim.lsp.enable` list
  - Do NOT touch `capabilities_configured` logic

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Targeted single-file insertion; small surface
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: NO (sole Wave 5 task; depends on Task 8 changes being committed since this references the new conform-only design)
  - **Parallel Group**: Wave 5
  - **Blocks**: Task 11
  - **Blocked By**: Task 8

  **References**:
  - **Pattern References**:
    - `lua/config/lsp.lua:53-65` (existing keybind insertion pattern inside LspAttach callback)
    - `lua/config/keymaps.lua` — check for `<leader>cf` collision before adding
  - **API/Type References**:
    - `vim.lsp.buf.code_action({ context, apply })` API: `:help vim.lsp.buf.code_action`
    - `source.fixAll.eslint` is the eslint-language-server code-action ID per vscode-eslint protocol
  - **External References**:
    - vscode-eslint code action IDs: `https://github.com/microsoft/vscode-eslint/blob/main/server/src/eslintServer.ts`
  - **WHY Each Reference Matters**: This keybind replaces the auto-fix-on-save behavior the user loses by removing eslint_d as a formatter. The exact action ID `source.fixAll.eslint` is what eslint-language-server registers; using a wrong ID silently does nothing.

  **Acceptance Criteria**:
  - [ ] `grep 'EslintFixAll\|source.fixAll.eslint' lua/config/lsp.lua` returns ≥2
  - [ ] `grep '<leader>cf' lua/config/keymaps.lua` returns 0 (or matches the new lsp.lua entry only — no collision)
  - [ ] File parses: `nvim --headless -c 'luafile lua/config/lsp.lua' -c 'qa!'` exits 0 (note: this file uses LspAttach which won't fire in luafile, but syntax must be valid)

  **QA Scenarios**:
  ```
  Scenario: <leader>cf keymap registered after LSP attach
    Tool: interactive_bash (tmux + nvim)
    Preconditions: Tasks 7, 8 committed; fixture exists
    Steps:
      1. tmux new-session -d -s qa-fixall
      2. tmux send-keys -t qa-fixall 'cd /tmp/lsp-perf-fixture && nvim src/sample.tsx' Enter
      3. Wait 4s for LSP attach
      4. tmux send-keys -t qa-fixall ':lua local map = vim.fn.maparg("<leader>cf", "n", false, true); print("rhs_set="..tostring(map.rhs ~= nil or map.callback ~= nil))' Enter
      5. Wait 1s
      6. tmux capture-pane -t qa-fixall -p > .sisyphus/evidence/task-10-keymap.log
      7. tmux kill-session -t qa-fixall
      8. grep -q 'rhs_set=true' .sisyphus/evidence/task-10-keymap.log
    Expected Result: keymap registered (callback present)
    Failure Indicators: rhs_set=false (keymap missing)
    Evidence: .sisyphus/evidence/task-10-keymap.log

  Scenario: :EslintFixAll fixes the var statement to const/let
    Tool: interactive_bash (tmux + nvim)
    Preconditions: fixture has `var x: number = 1;` in sample.tsx
    Steps:
      1. cp /tmp/lsp-perf-fixture/src/sample.tsx /tmp/lsp-perf-fixture/src/sample.tsx.bak
      2. tmux new-session -d -s qa-fixall2
      3. tmux send-keys -t qa-fixall2 'cd /tmp/lsp-perf-fixture && nvim src/sample.tsx' Enter
      4. Wait 4s for LSP attach + initial diagnostics
      5. tmux send-keys -t qa-fixall2 ':EslintFixAll' Enter
      6. Wait 2s
      7. tmux send-keys -t qa-fixall2 ':w' Enter
      8. Wait 1s
      9. tmux send-keys -t qa-fixall2 ':qa!' Enter
      10. cp /tmp/lsp-perf-fixture/src/sample.tsx .sisyphus/evidence/task-10-after-fix.tsx
      11. ! grep -q '^var ' .sisyphus/evidence/task-10-after-fix.tsx (var should be replaced)
    Expected Result: var statement replaced (eslint no-var rule auto-fixed)
    Failure Indicators: var still present after :EslintFixAll
    Evidence: .sisyphus/evidence/task-10-after-fix.tsx
  ```

  **Commit**: YES
  - Message: `feat(nvim/keymap): add <leader>cf for :EslintFixAll`
  - Files: `lua/config/lsp.lua`
  - Pre-commit: `nvim --headless -c 'qa!'` exits 0

- [ ] 11. **Run AC-1 through AC-8 sequentially + final measurement diff vs baseline**

  **What to do**:
  - Kill any lingering language servers: `pkill -f vscode-eslint-language-server; pkill -f typescript-language-server; pkill -f eslint_d` (best-effort; fine if no procs found)
  - Execute each acceptance criterion (AC-1 through AC-8) from the Verification Strategy section. Save evidence per-AC:
    - `.sisyphus/evidence/ac-1-single-eslint.log` through `.sisyphus/evidence/ac-8-plugin-hygiene.log`
  - Capture post-change measurements (mirror Task 2):
    - `.sisyphus/evidence/post-change-startup.log`
    - `.sisyphus/evidence/post-change-attach.log`
    - `.sisyphus/evidence/post-change-save.log`
    - `.sisyphus/evidence/post-change-eslint-procs.log`
  - Compute deltas:
    - Startup time delta: `tail -1 baseline-startup.log` vs `tail -1 post-change-startup.log` → save to `.sisyphus/evidence/delta-startup.txt`
    - LSP attach delta: per-LSP attach times before vs after → save to `.sisyphus/evidence/delta-attach.txt`
    - Save latency delta: average of 5 saves before vs after → save to `.sisyphus/evidence/delta-save.txt`
    - ESLint process count: before vs after (expect significant reduction) → save to `.sisyphus/evidence/delta-procs.txt`
  - Generate summary report `.sisyphus/evidence/SUMMARY.md` with:
    - Pass/fail per AC
    - Delta percentages with raw numbers
    - Any test that failed and why
  - If ANY AC fails, this task fails — report which and why; do not proceed to F1-F4

  **Must NOT do**:
  - Do NOT skip any AC
  - Do NOT cherry-pick passing scenarios while ignoring failures
  - Do NOT modify config files in this task (verification only; fixes go in re-runs of relevant earlier tasks)
  - Do NOT measure user's actual project (fixture only)

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Multi-step verification with conditional logic, evidence aggregation, and report generation
  - **Skills**: `[]`

  **Parallelization**:
  - **Can Run In Parallel**: NO (gates F1-F4)
  - **Parallel Group**: Wave 6
  - **Blocks**: F1, F2, F3, F4
  - **Blocked By**: Tasks 6, 7, 8, 9, 10

  **References**:
  - **Pattern References**:
    - Verification Strategy section above (defines AC-1 through AC-8)
    - `.sisyphus/evidence/baseline-*.log` (baseline data captured in Task 2)
  - **WHY Each Reference Matters**: The plan's success criteria depend on reproducible before/after numbers; without those deltas, “it's faster” is unfalsifiable.

  **Acceptance Criteria**:
  - [ ] `.sisyphus/evidence/SUMMARY.md` exists with pass/fail per AC
  - [ ] All 8 ACs report PASS
  - [ ] `delta-attach.txt` shows reduction ≥ 30% on at least eslint_ls attach
  - [ ] `delta-save.txt` shows post-change p50 < 500ms
  - [ ] `delta-procs.txt` shows eslint process count went from N>0 zombies to ≤1 active server

  **QA Scenarios**:
  ```
  Scenario: All ACs pass and deltas show improvement
    Tool: Bash
    Preconditions: Tasks 6-10 committed; baseline evidence present from Task 2
    Steps:
      1. Run each AC's command (referenced in Verification Strategy section). Capture stdout to .sisyphus/evidence/ac-N-*.log per AC.
      2. for n in 1 2 3 4 5 6 7 8; do test -f .sisyphus/evidence/ac-$n-*.log || echo MISSING_AC_$n; done
      3. cat .sisyphus/evidence/SUMMARY.md
      4. grep -q 'AC-[1-8]: FAIL' .sisyphus/evidence/SUMMARY.md && echo HAD_FAILURE || echo ALL_PASS
    Expected Result: ALL_PASS, no MISSING_AC_*
    Failure Indicators: HAD_FAILURE, MISSING_AC_*
    Evidence: .sisyphus/evidence/SUMMARY.md + ac-1..8-*.log + delta-*.txt

  Scenario: ESLint process count reduced
    Tool: Bash
    Steps:
      1. baseline_count=$(wc -l < .sisyphus/evidence/baseline-eslint-procs.log)
      2. post_count=$(wc -l < .sisyphus/evidence/post-change-eslint-procs.log)
      3. echo "baseline=$baseline_count post=$post_count" > .sisyphus/evidence/delta-procs.txt
      4. test "$post_count" -le "$baseline_count" (post must be ≤ baseline)
    Expected Result: post-change process count ≤ baseline
    Failure Indicators: post > baseline (regression — we added more eslint runners)
    Evidence: .sisyphus/evidence/delta-procs.txt
  ```

  **Commit**: OPTIONAL (only if `.sisyphus/evidence/` is git-tracked; otherwise no commit — evidence is local artifact)
  - Message (if committing): `chore(nvim): record baseline + post-change measurements`
  - Files: `.sisyphus/evidence/**`
  - Pre-commit: `test -f .sisyphus/evidence/SUMMARY.md && grep -q 'ALL_PASS\|All 8 ACs report PASS' .sisyphus/evidence/SUMMARY.md`


---
## Final Verification Wave (MANDATORY — after ALL implementation tasks)

> 4 review agents run in PARALLEL. ALL must APPROVE. Present consolidated results to user; wait for explicit "okay" before completing.

- [ ] F1. **Plan Compliance Audit** — `oracle`
  Read this plan end-to-end. For each "Must Have": verify implementation exists (read file, run nvim-headless command). For each "Must NOT Have": grep for forbidden patterns — reject with file:line if found (e.g. `grep -n "globpath" lsp/eslint_ls.lua`, `grep -n "eslint_d" lua/plugins/code/conform.lua`, `grep -n "vue\|svelte" lsp/ts_ls.lua lsp/eslint_ls.lua`). Verify evidence files exist in `.sisyphus/evidence/`. Compare deliverables against plan.
  Output: `Must Have [N/N] | Must NOT Have [N/N] | Tasks [N/N] | VERDICT: APPROVE/REJECT`

- [ ] F2. **Code Quality Review** — `unspecified-high`
  Run `nvim --headless -c 'checkhealth mason' -c 'checkhealth lsp' -c 'checkhealth conform' -c 'qa!' 2>&1`. Review all changed Lua files for: TODO/FIXME left behind, commented-out code blocks, syntax errors via `luac -p` if available, `print()` debug statements, dead code (functions defined but never called), AI slop (excessive comments, generic names like `data`, `temp`, `result`), inconsistent style (tabs vs spaces, double vs single quotes — match existing convention).
  Output: `checkhealth [PASS/FAIL] | luac [PASS/FAIL] | files [N clean / N issues] | VERDICT`

- [ ] F3. **Real Manual QA** — `unspecified-high`
  Start from clean state (close all nvim, kill any leftover language servers: `pkill -f vscode-eslint-language-server; pkill -f typescript-language-server; pkill -f eslint_d`). Execute EVERY QA scenario from EVERY task — follow exact steps, capture evidence. Test cross-task integration: open `/tmp/lsp-perf-fixture/src/sample.tsx`, type a `var` declaration, verify eslint diagnostic appears within 1s, save, verify oxfmt formats AND eslint diagnostic remains. Test edge cases: open empty `.tsx` file, open `.tsx` outside any project (single-file), rapid `:w` 5x in succession (no daemon crash), open handlebars file (`/tmp/lsp-perf-fixture/template.hbs` — verify djlint still lints). Save evidence to `.sisyphus/evidence/final-qa/`.
  Output: `Scenarios [N/N pass] | Integration [N/N] | Edge Cases [N tested] | VERDICT`

- [ ] F4. **Scope Fidelity Check** — `deep`
  For each task: read "What to do", read actual `git diff` for that task's commit. Verify 1:1 — everything in spec was built (no missing items), nothing beyond spec was built (no creep). Specifically check "Must NOT do" compliance per task. Detect cross-task contamination: Task 6 only touches `lsp/ts_ls.lua`, Task 7 only `lsp/eslint_ls.lua`, Task 8 only `lua/plugins/code/conform.lua`, Task 9 only `lua/plugins/code/nvim-lint.lua`, Task 4 only `lua/plugins/code/mason.lua`, Task 10 only `lua/config/lsp.lua`. Flag any unaccounted file changes (e.g. accidental edits to `vim.lua`, `keymaps.lua`).
  Output: `Tasks [N/N compliant] | Contamination [CLEAN/N issues] | Unaccounted [CLEAN/N files] | VERDICT`

---

## Commit Strategy

> One commit per task. Conventional commit format. Pre-commit verification = `nvim --headless -c 'checkhealth' -c 'qa!'` exits 0.

- **T0**: `chore(nvim): checkpoint before LSP perf fix`
- **T4**: `feat(nvim): add mason-tool-installer for self-bootstrap`
- **T6**: `fix(nvim/lsp): drop vue/svelte filetypes from ts_ls`
- **T7**: `perf(nvim/lsp): drop globpath flat-config detection in eslint_ls`
- **T8**: `perf(nvim/format): use oxfmt-only for JS/TS, drop eslint_d formatter`
- **T9**: `refactor(nvim/lint): strip eslint_d, preserve djlint+ember coverage`
- **T10**: `feat(nvim/keymap): add <leader>cf for :EslintFixAll`

T1, T2, T3, T5, T11 produce evidence files only — no commits (or single `chore(nvim): record baseline + post-change measurements` if `.sisyphus/evidence/` is tracked).

---

## Success Criteria

### Verification Commands

```bash
# 1. Eslint runs only via LSP (no daemon zombies)
ps aux | grep -E "eslint_d|vscode-eslint" | grep -v grep
# Expected: ONE vscode-eslint-language-server process per nvim instance, ZERO standalone eslint_d

# 2. Conform uses oxfmt only for JS/TS
nvim --headless -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' \
  -c 'lua vim.defer_fn(function() print(vim.inspect(require("conform").list_formatters_to_run(0))); vim.cmd("qa!") end, 1500)'
# Expected: list contains oxfmt only

# 3. nvim-lint has no eslint_d for JS/TS
nvim --headless -c 'edit /tmp/lsp-perf-fixture/src/sample.tsx' \
  -c 'lua vim.defer_fn(function() print(vim.inspect((require("lint").linters_by_ft or {})["typescriptreact"])); vim.cmd("qa!") end, 1500)'
# Expected: nil OR {} (no eslint_d)

# 4. Format-on-save under 500ms
# (run in tmux per AC-2)

# 5. Mason has all required tools installed
nvim --headless -c 'lua vim.defer_fn(function() local r=require("mason-registry"); for _,t in ipairs({"vscode-eslint-language-server","typescript-language-server","oxfmt","prettierd","stylua"}) do print(t..":", r.is_installed(t)) end; vim.cmd("qa!") end, 5000)'
# Expected: all true

# 6. LSP attach time reduced
diff .sisyphus/evidence/baseline-attach.log .sisyphus/evidence/post-change-attach.log
# Expected: post-change attach_ms ≤ baseline attach_ms × 0.7
```

### Final Checklist
- [ ] All "Must Have" present (verified in F1)
- [ ] All "Must NOT Have" absent (verified in F1)
- [ ] All AC-1 through AC-8 pass with evidence (verified in F3)
- [ ] No cross-task file contamination (verified in F4)
- [ ] User has run plan to completion and given explicit "okay"

---

## Known Limitations & Out-of-Scope

> Surface to user post-implementation so expectations are correct.

- **Typescript-language-server lag in JSX**: Not in scope. `ts_ls` itself runs `watchProgram` on file changes; if user still feels lag in JSX/TSX after this fix, the next bottleneck is `ts_ls` (consider `vtsls` or `typescript-tools.nvim` as a future investigation).
- **virtual_text flicker**: With `update_in_insert=true` × `run="onType"`, eslint diagnostics' virtual text re-renders on every keystroke. User opted into this. Mitigation if it becomes annoying: filter virtual_text by severity (only ERROR shown live, others on InsertLeave).
- **eslint --fix on save**: No longer happens automatically. User must invoke `<leader>cf` (`:EslintFixAll`) manually OR via code action. This is a UX change from current behavior.
- **lazy-lock.json drift**: Adding `mason-tool-installer` and changing nvim-lint config will mutate `lazy-lock.json`. To revert this plan's changes, user must `git checkout HEAD -- lazy-lock.json` separately, then `:Lazy! restore`.
- **Cold oxfmt on first save after boot**: First format-on-save after nvim launch may exceed 500ms timeout if oxfmt cold-starts. If observed in QA, plan task allows bumping timeout to 1000ms (still well under current 3000ms).
