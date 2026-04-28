# Plan: `<leader>gd` shows files (not hunks) vs base branch

## TL;DR

> **Quick Summary**: Add `group = true` to the existing `Snacks.picker.git_diff` call so the picker lists one entry **per changed file** instead of one entry per hunk. Update the `desc` to reflect the new semantic.
>
> **Deliverables**:
> - Modified `<leader>gd` keybinding block in `lua/plugins/navigation/snacks-picker.lua`
> - Updated `desc` text for the keybinding
>
> **Estimated Effort**: Quick (≈2 LOC change, ~1 min implementation, ~5 min QA)
> **Parallel Execution**: NO — single trivial task, no parallelism possible
> **Critical Path**: T1 → F1-F4

---

## Context

### Original Request
> "currently i'm testing television but when i do `<leader>gd` I see single hunk
> changed but I want to see only changed files is it possible with my current plugin?"

### Interview Summary
**Key clarifications**:
- User said "television" — config has **no television plugin**. Active picker = `folke/snacks.nvim`. Telescope is `enabled = false`. User confirmed via Question tool: meant snacks.
- "Changed files" semantic confirmed: **files changed vs base branch (main...HEAD)**, not working-tree status.

**Research Findings (librarian)**:
- `Snacks.picker.git_diff` accepts `{ base?: string, staged?: boolean, group?: boolean }`.
- **Default `group = false` → entry per hunk** (current unwanted behavior).
- **`group = true` → entry per file** (exactly what user wants).
- `git_status` does NOT accept `base` — wrong tool for "vs base branch".
- Source ref: `lua/snacks/picker/config/sources.lua` lines 3207-3245 in folke/snacks.nvim.

### Metis Review
**Gaps surfaced and addressed**:
- UX questions (what does Enter do, what's in preview, deleted file handling, rename handling, etc.) — **mooted** by using built-in `group = true`. Snacks handles all defaults consistently.
- Adjacent duplicate mapping (`<leader>gh` and `<leader>gbc` both = `git_log_file`) — **out of scope**, called out below.
- Base detection edge cases (no main/master, detached HEAD, outside repo) — **preserved as-is**, pre-existing behavior unchanged.
- Required: update `desc` field — incorporated.
- Required: comprehensive tmux-based ACs — incorporated.

---

## Work Objectives

### Core Objective
Change `<leader>gd` so it lists changed files (one entry per file) instead of changed hunks (one entry per hunk), keeping the existing base-branch detection logic intact.

### Concrete Deliverables
- `lua/plugins/navigation/snacks-picker.lua` lines 60-69: `Snacks.picker.git_diff` call gains `group = true`; `desc` updated.

### Definition of Done
- [ ] Pressing `<leader>gd` in nvim opens the snacks picker with **one entry per changed file** (file paths only, no `@@` hunk headers, no `+`/`-` diff body lines in the list pane).
- [ ] Base detection still works for both `main` and `master` repos.
- [ ] All other keybindings in the file behave identically to before.
- [ ] Lua file parses cleanly (no LSP diagnostics introduced).

### Must Have
- `group = true` argument in the `Snacks.picker.git_diff` call.
- Updated `desc` accurately reflecting "files" semantic.
- Existing base detection logic (lines 63-65) preserved verbatim.
- `vim.fn.shellescape` preserved on dir argument.

### Must NOT Have (Guardrails)
- ❌ Custom picker logic / new helper modules — built-in `group = true` is sufficient.
- ❌ Changes to any other keybinding (`<leader>gh`, `<leader>sb`, `<leader>ghc`, `<leader>gbc`, all `<leader>s*`).
- ❌ Changes to picker UI config (lines 8-47: layout, sources, formatters, matcher, win.input.keys).
- ❌ Renaming `<leader>gd` to a different key.
- ❌ Adding a "preserve old hunk-list behavior under different key" mapping.
- ❌ "Fixing" the duplicate `<leader>gh`/`<leader>gbc` mapping (separate concern, separate plan if user wants it).
- ❌ Refactoring base detection (e.g., to use `@{u}` or `origin/HEAD`).
- ❌ Touching `telescope.lua`, `neo-tree.lua`, or any non-snacks-picker file.
- ❌ AI slop: extracted helpers, generic param names (`opts`, `config`), excessive comments, JSDoc/Lua doc bloat.

### Out of Scope (Acknowledged but Deferred)
- Duplicate keybinding bug: both `<leader>gh` (line 70) and `<leader>gbc` (line 73) call `Snacks.picker.git_log_file()`. Real bug, but not this task.
- Smarter base detection (upstream tracking, `origin/HEAD`).
- Replacing snacks with `television.nvim` or any other picker.
- Improving "no base branch found" UX (current code silently falls through to `master`).

---

## Verification Strategy (MANDATORY)

> **ZERO HUMAN INTERVENTION** — All verification is agent-executed via tmux.

### Test Decision
- **Infrastructure exists**: NO (nvim Lua configs typically have no unit-test setup in this repo).
- **Automated tests**: NONE (no framework set up; user did not request test scaffolding).
- **Framework**: N/A.
- **Primary verification**: Agent-executed QA scenarios via `Bash` (which invokes `tmux` and `nvim` as subprocesses) running real nvim against fresh per-scenario fixture git repos.

### QA Policy
Every task includes agent-executed QA scenarios. Evidence saved to `.sisyphus/evidence/task-{N}-{scenario-slug}.{ext}`.

- **TUI/CLI (nvim)**: `Bash` tool calls invoking `tmux new-session`, `tmux send-keys`, and `tmux capture-pane` against `nvim` running inside a tmux session. Each scenario builds its own fixture and tears it down. (`interactive_bash` is intentionally NOT used here — it accepts only tmux subcommands and cannot run the surrounding `mktemp`/`git`/`grep` shell, which is why every scenario is wrapped in `Bash`.)
- **Static**: `lsp_diagnostics` on the modified file — must show no new errors.

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Implementation):
└── T1: Update <leader>gd call to use group=true and refresh desc [quick]

Wave FINAL (Review — 4 parallel reviewers):
├── F1: Plan compliance audit (oracle)
├── F2: Code quality review (unspecified-high)
├── F3: Real manual QA (unspecified-high)
└── F4: Scope fidelity check (deep)
→ Present results → Get explicit user okay

Critical Path: T1 → F1-F4 → user okay
Parallel Speedup: N/A (only one impl task)
Max Concurrent: 4 (final review wave)
```

### Dependency Matrix

- **T1**: blocked by — none. blocks — F1-F4.
- **F1-F4**: blocked by — T1. blocks — user okay.

### Agent Dispatch Summary

- **Wave 1**: 1 task — T1 → `quick`
- **Wave FINAL**: 4 tasks — F1 → `oracle`, F2 → `unspecified-high`, F3 → `unspecified-high`, F4 → `deep`

---

## TODOs

- [x] 1. Add `group = true` to `Snacks.picker.git_diff` call and update `desc`

  **What to do**:
  - Open `lua/plugins/navigation/snacks-picker.lua`.
  - Locate the `<leader>gd` keybinding block at lines 60-69.
  - On the `Snacks.picker.git_diff(...)` call (currently line 66: `Snacks.picker.git_diff({ base = base })`), add `group = true` so it becomes:
    ```lua
    Snacks.picker.git_diff({ base = base, group = true })
    ```
  - Update the `desc` (currently line 68: `desc = "[G]it: [D]iff vs base branch"`) to:
    ```lua
    desc = "[G]it: [D]iff Files vs base branch"
    ```
  - Save. Run `lsp_diagnostics` on the file to confirm no new errors.

  **Must NOT do**:
  - Modify lines 1-59 or 70-83 of the file (anything outside the `<leader>gd` block).
  - Replace, refactor, or wrap the base detection (lines 63-65 stay byte-for-byte identical).
  - Drop `vim.fn.shellescape` from the dir variable.
  - Change the function signature, the keybinding (`<leader>gd` stays), or the surrounding `keys = { ... }` array structure.
  - Add comments explaining what `group = true` does (the option name is self-documenting).
  - Touch `<leader>gh`, `<leader>gbc`, or any other mapping in the file.

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Two-line edit in a single file. No domain reasoning required, no architectural decisions, no creative output. Pure mechanical edit guided by exact line numbers and snippets.
  - **Skills**: none required
    - Skills evaluated and rejected:
      - `tdd`: no test infrastructure exists; not applicable.
      - `caveman-commit`: commit message is generated by the executor; no specific compression need flagged by user.

  **Parallelization**:
  - **Can Run In Parallel**: NO (only task in Wave 1)
  - **Parallel Group**: Wave 1 (alone)
  - **Blocks**: F1, F2, F3, F4
  - **Blocked By**: None — can start immediately.

  **References**:

  **Pattern References** (existing code to follow):
  - `lua/plugins/navigation/snacks-picker.lua:60-69` — the exact block to edit. Surrounding keybinding entries (lines 50-58, 70-73) show the canonical `{ "<lhs>", function() ... end, desc = "..." }` shape — mirror it.
  - `lua/plugins/navigation/snacks-picker.lua:70-73` — adjacent git mappings. Their `desc` style ("[G]it: ...", "[S]earch: ...") is the convention to follow.

  **API/Type References** (contracts):
  - Snacks picker config type: `snacks.picker.git.diff.Config` extends `snacks.picker.git.Config` and adds `group?: boolean`, `staged?: boolean`, `base?: string`. Source: `lua/snacks/picker/config/sources.lua` lines 3207-3245 in folke/snacks.nvim. Default `group = false`. Setting `group = true` causes one entry per file (instead of per hunk) — the entire reason this task exists.

  **Test References**:
  - None. No existing test file in repo.

  **External References**:
  - Snacks picker docs: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md (search for `git_diff` source).
  - Source-of-truth for `group` option: https://github.com/folke/snacks.nvim/blob/main/lua/snacks/picker/config/sources.lua

  **WHY each reference matters**:
  - The `snacks-picker.lua:60-69` block is the **only** place to edit. Reading the surrounding keys array prevents accidental damage to neighbours.
  - The snacks source/docs reference confirms that `group = true` is real, supported, and produces the requested behavior — not a hallucination.
  - Adjacent `desc` styles ensure the new `desc` matches house conventions ("[G]it: ..." prefix).

  **Acceptance Criteria**:

  **Static checks**:
  - [ ] `lsp_diagnostics filePath="lua/plugins/navigation/snacks-picker.lua"` returns zero new errors and zero new warnings on the modified file.
  - [ ] Diff against the pre-edit version touches **only** lines 66 and 68 of the original file (the `Snacks.picker.git_diff` call and the `desc` line). Verified with: `git diff -U0 -- lua/plugins/navigation/snacks-picker.lua | grep -E '^@@' | wc -l` should reflect changes only in that range.

  **QA Scenarios (MANDATORY)**:

  ```
  Pre-flight (run ONCE before any scenario, in repo root):
    Tool: Bash
    Steps:
      1. mkdir -p .sisyphus/evidence
      2. export EVIDENCE_DIR="$HOME/.config/nvim/.sisyphus/evidence"   # absolute path — cwd-independent
      3. export NVIM_INIT="$HOME/.config/nvim/init.lua"
    Expected Result: directory exists; env vars usable in subsequent scenarios.

  Scenario 1: <leader>gd shows file list, not hunk list, in a `main`-based repo (HAPPY PATH)
    Tool: Bash (invokes tmux as subprocess; self-contained)
    Preconditions: pre-flight complete.
    Steps:
      1. Build fresh fixture (Bash):
         export S1_TMPDIR=$(mktemp -d)
         cd "$S1_TMPDIR"
         git init -q && git checkout -qb main
         printf 'base\n' > a.txt && printf 'base\n' > b.txt && printf 'base\n' > c.txt
         git add . && git -c user.email=t@t -c user.name=t commit -qm "base"
         git checkout -qb feature
         printf 'modified\nmodified2\n' > a.txt
         printf 'added\n' > new.txt
         git add a.txt new.txt
         git -c user.email=t@t -c user.name=t commit -qm "feature changes"
      2. Start nvim in tmux (Bash):
         tmux new-session -d -s nvgd -x 220 -y 60 "nvim -u $NVIM_INIT $S1_TMPDIR/a.txt"
         sleep 3   # wait for snacks/lazy to load
      3. Trigger keybinding (Bash):
         tmux send-keys -t nvgd " gd"     # space=leader, then gd
         sleep 2   # wait for picker to render
      4. Capture pane (Bash):
         tmux capture-pane -t nvgd -p > "$EVIDENCE_DIR/task-1-files-listed.txt"
      5. Assert (Bash):
         grep -q "a.txt"   "$EVIDENCE_DIR/task-1-files-listed.txt"
         grep -q "new.txt" "$EVIDENCE_DIR/task-1-files-listed.txt"
         # No hunk-header markers
         ! grep -qE "^[[:space:]]*@@.*@@" "$EVIDENCE_DIR/task-1-files-listed.txt"
         # No diff body lines containing the literal fixture content
         ! grep -qE "^[+-][^+-].*(modified|base|added)" "$EVIDENCE_DIR/task-1-files-listed.txt"
    Expected Result: file list visible (a.txt, new.txt at minimum); zero hunk headers; zero diff-body lines.
    Failure Indicators: presence of `@@`-style hunk headers; presence of `+modified` / `-base` / `+added` strings inside the picker pane.
    Evidence: $EVIDENCE_DIR/task-1-files-listed.txt
    Cleanup (Bash):
      tmux kill-session -t nvgd 2>/dev/null
      rm -rf "$S1_TMPDIR"
      unset S1_TMPDIR

  Scenario 2: master fallback — no `main` branch, base detection picks `master`
    Tool: Bash (invokes tmux as subprocess; self-contained)
    Preconditions: pre-flight complete.
    Steps:
      1. Build fresh fixture using master as base (Bash):
         export S2_TMPDIR=$(mktemp -d)
         cd "$S2_TMPDIR"
         git init -q && git checkout -qb master
         printf 'base\n' > a.txt
         git add . && git -c user.email=t@t -c user.name=t commit -qm "base"
         git checkout -qb feature
         printf 'modified\n' > a.txt
         git -c user.email=t@t -c user.name=t commit -am "change"
      2. Start nvim in tmux (Bash):
         tmux new-session -d -s nvgd2 -x 220 -y 60 "nvim -u $NVIM_INIT $S2_TMPDIR/a.txt"
         sleep 3
      3. Trigger keybinding (Bash):
         tmux send-keys -t nvgd2 " gd"
         sleep 2
      4. Capture pane (Bash):
         tmux capture-pane -t nvgd2 -p > "$EVIDENCE_DIR/task-1-master-fallback.txt"
      5. Assert (Bash):
         grep -q "a.txt" "$EVIDENCE_DIR/task-1-master-fallback.txt"
    Expected Result: a.txt appears in picker (proves base detection fell back to `master` and the file list rendered correctly).
    Failure Indicators: empty picker; `a.txt` absent; nvim error visible in pane.
    Evidence: $EVIDENCE_DIR/task-1-master-fallback.txt
    Cleanup (Bash):
      tmux kill-session -t nvgd2 2>/dev/null
      rm -rf "$S2_TMPDIR"
      unset S2_TMPDIR

  Scenario 3: regression — adjacent git mapping <leader>gh still works (SELF-CONTAINED, no shared fixture)
    Tool: Bash (invokes tmux as subprocess; self-contained)
    Preconditions: pre-flight complete.
    Steps:
      1. Build fresh fixture with at least one commit on a branch (Bash):
         export S3_TMPDIR=$(mktemp -d)
         cd "$S3_TMPDIR"
         git init -q && git checkout -qb main
         printf 'base\n' > a.txt
         git add . && git -c user.email=t@t -c user.name=t commit -qm "base"
         git checkout -qb feature
         printf 'modified\n' > a.txt
         git -c user.email=t@t -c user.name=t commit -am "feature"
      2. Start nvim in tmux (Bash):
         tmux new-session -d -s nvgh -x 220 -y 60 "nvim -u $NVIM_INIT $S3_TMPDIR/a.txt"
         sleep 3
      3. Trigger keybinding (Bash):
         tmux send-keys -t nvgh " gh"
         sleep 2
      4. Capture pane (Bash):
         tmux capture-pane -t nvgh -p > "$EVIDENCE_DIR/task-1-gh-regression.txt"
      5. Assert (Bash):
         grep -qiE "commit|history|^[[:xdigit:]]{7,}" "$EVIDENCE_DIR/task-1-gh-regression.txt"
    Expected Result: snacks picker shows commit/log entries (proves <leader>gh still calls `Snacks.picker.git_log_file()` unchanged).
    Failure Indicators: nvim error; empty pane; "key not bound" message; absence of any commit-like content.
    Evidence: $EVIDENCE_DIR/task-1-gh-regression.txt
    Cleanup (Bash):
      tmux kill-session -t nvgh 2>/dev/null
      rm -rf "$S3_TMPDIR"
      unset S3_TMPDIR

  Scenario 4 (NEGATIVE / EDGE CASE): on the base branch — empty diff, no spurious entries
    Tool: Bash (invokes tmux as subprocess; self-contained)
    Preconditions: pre-flight complete.
    Steps:
      1. Build fresh fixture with single commit on main, HEAD == main (Bash):
         export S4_TMPDIR=$(mktemp -d)
         cd "$S4_TMPDIR"
         git init -q && git checkout -qb main
         printf 'base\n' > a.txt
         git add . && git -c user.email=t@t -c user.name=t commit -qm "base"
         # HEAD == main now — main...HEAD is empty
      2. Start nvim in tmux (Bash):
         tmux new-session -d -s nvempty -x 220 -y 60 "nvim -u $NVIM_INIT $S4_TMPDIR/a.txt"
         sleep 3
      3. Trigger keybinding (Bash):
         tmux send-keys -t nvempty " gd"
         sleep 2
      4. Capture pane (Bash):
         tmux capture-pane -t nvempty -p > "$EVIDENCE_DIR/task-1-empty-diff.txt"
      5. Assert (Bash):
         # No spurious 'a.txt' line presented as a changed file
         ! grep -qE "^[[:space:]]*[┃│|]?[[:space:]]*a\.txt[[:space:]]*$" "$EVIDENCE_DIR/task-1-empty-diff.txt"
         # And nvim must not have crashed
         ! grep -qiE "error|traceback|stack" "$EVIDENCE_DIR/task-1-empty-diff.txt"
    Expected Result: picker is empty (or never opens); nvim healthy; no error traceback in pane.
    Failure Indicators: a.txt listed as changed (would indicate base detection broke); lua/nvim error in pane.
    Evidence: $EVIDENCE_DIR/task-1-empty-diff.txt
    Cleanup (Bash):
      tmux kill-session -t nvempty 2>/dev/null
      rm -rf "$S4_TMPDIR"
      unset S4_TMPDIR
  ```

  **Specificity confirmation**:
  - Exact tmux session names: `nvgd`, `nvgd2`, `nvgh`, `nvempty` (no collisions).
  - Concrete fixture data: `a.txt`, `b.txt`, `c.txt`, `new.txt` with literal content `base`, `modified`, `added`.
  - Concrete assertions: explicit `grep -q` patterns; negative assertions use `! grep -qE`.
  - Timing: explicit `sleep 3` after nvim launch (lazy/snacks load), `sleep 2` after key press.
  - Negative scenario: empty-diff scenario.

  **Evidence to Capture**:
  - [ ] `.sisyphus/evidence/task-1-files-listed.txt` — primary file list capture
  - [ ] `.sisyphus/evidence/task-1-master-fallback.txt` — master fallback capture
  - [ ] `.sisyphus/evidence/task-1-gh-regression.txt` — adjacent mapping regression capture
  - [ ] `.sisyphus/evidence/task-1-empty-diff.txt` — empty-diff edge case capture

  **Commit**: YES (single-task plan, single commit)
  - Message: `feat(nvim): list changed files (not hunks) for <leader>gd`
  - Files: `lua/plugins/navigation/snacks-picker.lua`
  - Pre-commit: run all four QA scenarios above; all assertions must pass.

---

## Final Verification Wave (MANDATORY — after T1)

> 4 reviewers run in parallel. ALL must APPROVE. Present consolidated results to user, wait for explicit "okay" before completion.

- [x] F1. **Plan Compliance Audit** — `oracle`
  Read this plan end-to-end. For each "Must Have": verify implementation exists in `lua/plugins/navigation/snacks-picker.lua` (read the file, confirm `group = true` is present, confirm `desc` updated, confirm base detection lines unchanged, confirm `vim.fn.shellescape` retained). For each "Must NOT Have" guardrail: search the diff for forbidden patterns (extracted helpers, new keybindings, edits outside lines 60-69, "AI slop" comments). Verify all 4 evidence files exist in `.sisyphus/evidence/`.
  Output: `Must Have [N/N] | Must NOT Have [N/N] | Tasks [1/1] | Evidence [4/4] | VERDICT: APPROVE/REJECT`

- [x] F2. **Code Quality Review** — `unspecified-high`
  Run `lsp_diagnostics` on the modified file (must be clean). Inspect the diff:
  - No `as any`-equivalents (Lua: no untyped table casts that defeat snacks types).
  - No commented-out code, no `print(...)` debug leftovers.
  - No new comments unless they explain non-obvious WHY.
  - Variable names unchanged (`dir`, `base` retained — no rename to `opts`/`config`/`data`).
  - Indentation matches surrounding tabs.
  - No unused variables.
  Output: `LSP [PASS/FAIL] | Diff scope [PASS/FAIL] | Slop check [N issues] | VERDICT`

- [x] F3. **Real Manual QA** — `unspecified-high`
  Execute every QA scenario from T1 from a clean shell. Capture all evidence files. Then perform an additional integration check: with the `feature` branch fixture, navigate the picker (send arrow keys, then `<CR>`) and verify a file is opened in nvim (capture `:echo expand('%:t')` output). Save to `.sisyphus/evidence/final-qa/`.
  Output: `Scenarios [4/4 pass] | Integration [PASS/FAIL] | VERDICT`

- [x] F4. **Scope Fidelity Check** — `deep`
  Read T1 "What to do" + the actual git diff (`git diff HEAD -- lua/plugins/navigation/snacks-picker.lua`). Verify 1:1:
  - `group = true` appears exactly once on the `Snacks.picker.git_diff` call.
  - `desc` value updated to the spec'd string.
  - No edits outside lines 60-69.
  - No new files created (other than evidence under `.sisyphus/evidence/`).
  - No "Out of Scope" items leaked into the diff (no edits to `<leader>gh`, `<leader>gbc`, base detection, etc.).
  Output: `Tasks [1/1 compliant] | Contamination [CLEAN/N issues] | Unaccounted files [CLEAN/N files] | VERDICT`

---

## Commit Strategy

- **T1**: `feat(nvim): list changed files (not hunks) for <leader>gd`
  - File: `lua/plugins/navigation/snacks-picker.lua`
  - Pre-commit gate: all 4 QA scenarios pass + LSP clean.

---

## Success Criteria

### Verification Commands
```bash
# Check the diff is exactly the two intended changes
git diff -- lua/plugins/navigation/snacks-picker.lua | grep -E '^[+-]' | grep -v '^[+-][+-][+-]'
# Expected: exactly 4 lines (one '-' and one '+' for the git_diff call, one '-' and one '+' for desc)

# LSP clean
# (run via lsp_diagnostics tool — expected: no new errors)

# Evidence present
ls -1 .sisyphus/evidence/task-1-*.txt | wc -l
# Expected: 4
```

### Final Checklist
- [ ] `Snacks.picker.git_diff` call now passes `group = true`
- [ ] `desc` updated to reflect "files" semantic
- [ ] Base detection lines (63-65) unchanged
- [ ] `vim.fn.shellescape` preserved
- [ ] No edits outside lines 60-69
- [ ] No other keybindings touched
- [ ] LSP diagnostics: 0 new issues
- [ ] All 4 QA scenarios pass
- [ ] All 4 evidence files captured
- [ ] F1-F4 all APPROVE
- [ ] User explicitly says "okay" before marking F1-F4 checked
