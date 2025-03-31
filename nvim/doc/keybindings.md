# Neovim Keybindings Reference

This document provides a comprehensive list of all keybindings configured in this Neovim setup, organized by category.

## Global Keys

| Key | Mode | Description |
|-----|------|-------------|
| `Space` | All | Leader key |
| `,` | All | Local leader key |
| `<Esc>` | Normal | Clear search highlighting |
| `<leader>o` | Normal | Add new line below (staying in normal mode) |
| `<leader>O` | Normal | Add new line above (staying in normal mode) |

## Navigation

### Splits

| Key | Mode | Description |
|-----|------|-------------|
| `sl` | Normal | Split vertically |
| `sj` | Normal | Split horizontally |
| `sq` | Normal | Close pane |

### Tmux Integration

| Key | Mode | Description |
|-----|------|-------------|
| `<C-h>` | Normal | Navigate left (Neovim/Tmux) |
| `<C-j>` | Normal | Navigate down (Neovim/Tmux) |
| `<C-k>` | Normal | Navigate up (Neovim/Tmux) |
| `<C-l>` | Normal | Navigate right (Neovim/Tmux) |
| `<C-\>` | Normal | Navigate to last active pane/split |
| `<C-Space>` | Normal | Navigate to next pane/split |

### Tabs

| Key | Mode | Description |
|-----|------|-------------|
| `<tab>n` | Normal | Open new tab |
| `<tab>x` | Normal | Close current tab |
| `<tab>l` or `<tab><tab>` | Normal | Go to next tab |
| `<tab>h` | Normal | Go to previous tab |
| `<tab>b` | Normal | Open current buffer in new tab |
| `<tab>1` through `<tab>9` | Normal | Go to tab 1-9 |

### Code Movement

| Key | Mode | Description |
|-----|------|-------------|
| `<A-Down>` | Normal | Move line down |
| `<A-Up>` | Normal | Move line up |
| `<A-Down>` | Visual | Move selection down |
| `<A-Up>` | Visual | Move selection up |

## Code Editing

### nvim-surround

| Key | Mode | Description |
|-----|------|-------------|
| `ys` | Normal | Add surrounding |
| `yss` | Normal | Add surrounding to the current line |
| `yS` | Normal | Add surrounding and place on new lines |
| `ySS` | Normal | Add surrounding to the current line and place on new lines |
| `ds` | Normal | Delete surrounding |
| `cs` | Normal | Change surrounding |
| `S` | Visual | Add surrounding |

### Comment.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc` | Normal/Visual | Toggle comment (with motion or in visual mode) |
| `gb` | Normal/Visual | Toggle block comment (with motion or in visual mode) |

### nvim-cmp (Completion)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-Space>` | Insert | Complete |
| `<C-b>/<C-f>` | Insert | Scroll docs |
| `<C-e>` | Insert | Abort completion |
| `<CR>` | Insert | Confirm selection |

### Folding

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>zfm` | Normal | Change fold method to manual |
| `<leader>zfi` | Normal | Change fold method to indent |
| `<leader>zfs` | Normal | Change fold method to syntax |
| `<leader>zfe` | Normal | Change fold method to expr |

### Treesitter Textobjects

| Key | Mode | Description |
|-----|------|-------------|
| `a=`/`i=` | Normal/Visual | Select outer/inner part of an assignment |
| `l=`/`r=` | Normal/Visual | Select left/right hand side of an assignment |
| `a:`/`i:` | Normal/Visual | Select outer/inner part of an object property |
| `l:`/`r:` | Normal/Visual | Select left/right part of an object property |
| `aa`/`ia` | Normal/Visual | Select outer/inner part of a parameter/argument |
| `ai`/`ii` | Normal/Visual | Select outer/inner part of a conditional |
| `al`/`il` | Normal/Visual | Select outer/inner part of a loop |
| `af`/`if` | Normal/Visual | Select outer/inner part of a function call |
| `am`/`im` | Normal/Visual | Select outer/inner part of a method/function definition |
| `ac`/`ic` | Normal/Visual | Select outer/inner part of a class |

#### Treesitter Swap

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>na` | Normal | Swap parameter/argument with next |
| `<leader>n:` | Normal | Swap object property with next |
| `<leader>nm` | Normal | Swap function with next |
| `<leader>pa` | Normal | Swap parameter/argument with previous |
| `<leader>p:` | Normal | Swap object property with previous |
| `<leader>pm` | Normal | Swap function with previous |

#### Treesitter Movement

| Key | Mode | Description |
|-----|------|-------------|
| `]f`/`[f` | Normal | Next/previous function call start |
| `]m`/`[m` | Normal | Next/previous method/function def start |
| `]c`/`[c` | Normal | Next/previous class start |
| `]i`/`[i` | Normal | Next/previous conditional start |
| `]l`/`[l` | Normal | Next/previous loop start |
| `]F`/`[F` | Normal | Next/previous function call end |
| `]M`/`[M` | Normal | Next/previous method/function def end |
| `]C`/`[C` | Normal | Next/previous class end |
| `]I`/`[I` | Normal | Next/previous conditional end |
| `]L`/`[L` | Normal | Next/previous loop end |
| `]s`/`[s` | Normal | Next/previous scope |
| `]z`/`[z` | Normal | Next/previous fold |

## LSP

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>D` | Normal | Hover documentation |
| `<leader>cd` | Normal | Go to definition |
| `<leader>cR` | Normal | Find references |
| `<leader>ci` | Normal | Go to implementation |
| `<leader>ca` | Normal | Code action |
| `<leader>cr` | Normal | Rename symbol |
| `<leader>cfc` | Normal | Format current file |
| `gD` | Normal | Go to declaration |
| `gd` | Normal | Go to definition |
| `[d` | Normal | Go to previous diagnostic |
| `]d` | Normal | Go to next diagnostic |
| `K` | Normal | Hover documentation |

## Git

### gitsigns.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gi` | Normal | Diff this file |
| `<leader>gp` | Normal | Preview hunk |
| `<leader>gl` | Normal | Blame line with full details |
| `<localleader>]` | Normal | Navigate to next hunk |
| `<localleader>[` | Normal | Navigate to previous hunk |
| `<localleader>r` | Normal | Reset hunk |

### gitlinker.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gy` | Normal/Visual | Open current file/selection in browser |

### fugitive

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gs` | Normal | Open git status |
| `<leader>gb` | Normal | Git blame |
| `<leader>gd` | Normal | Git diff |
| `<leader>gD` | Normal | Git diff split |
| `<leader>gk` | Normal | Diff get from right (in diff view) |
| `<leader>gj` | Normal | Diff get from left (in diff view) |
| `<leader>gv` | Normal | Open diff view |
| `<leader>gc` | Normal | Close diff view |

### lazygit.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>lg` | Normal | Open lazygit |

## Search

### telescope.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sf` | Normal | Find files |
| `<leader><leader>` | Normal | Recent files |
| `<leader>sb` | Normal | Buffers |
| `<leader>sg` | Normal | Live grep |
| `<leader>sw` | Normal/Visual | Search word under cursor |
| `<leader>ss` | Visual | Search current selection |
| `<leader>sd` | Normal/Visual | Git diff |
| `<leader>sb` | Normal/Visual | Git branches |
| `<leader>sc` | Normal/Visual | Git commits |
| `<leader>sh` | Normal/Visual | Git history |
| `<leader>sH` | Normal/Visual | Git file history |
| `<leader>st` | Normal | List tabs |
| `<leader>s<CR>` | Normal | Grep current directory |
| `<leader>sp` | Normal | Grep project |

### grug-far.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sr` | Normal | Open search and replace |

### Custom Find and Replace

| Key | Mode | Description |
|-----|------|-------------|
| `<localleader>r` | Normal | Replace all instances |
| `<localleader>s` | Normal | Replace selected instance |
| `<localleader>n` | Normal | Select next instance |
| `<localleader>p` | Normal | Select previous instance |
| `<localleader>u` | Normal | Undo last action |
| `<localleader>c` or `Esc` | Normal | Close the find and replace window |

## UI

### symbols-outline.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>cs` | Normal | Toggle Symbols Outline |

### trouble.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>xx` | Normal | Toggle diagnostics list |
| `<leader>xX` | Normal | Toggle buffer diagnostics |

### which-key.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>?` | Normal | Show global keymaps |

### neo-tree.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>e` | Normal | Toggle file explorer |
| `<leader>b` | Normal | Show buffers in floating window |
| `<leader>G` | Normal | Show git status in floating window |
| `<leader>w` | Normal | Toggle file explorer in floating window |

<!-- barbar.nvim has been removed -->

### dashboard (alpha-nvim)

| Key | Mode | Description |
|-----|------|-------------|
| `f` | Normal | Find file (from dashboard) |
| `n` | Normal | New file (from dashboard) |
| `r` | Normal | Recent files (from dashboard) |
| `t` | Normal | Find text (from dashboard) |
| `c` | Normal | Open config (from dashboard) |
| `q` | Normal | Quit (from dashboard) |

## AI Assistance

### avante.nvim

| Key | Mode | Description |
|-----|------|-------------|
| `<C-a>` | Insert | Submit to AI assistant |

## Commands

| Command | Description |
|---------|-------------|
| `:Replace` | Open the custom find and replace window |
| `:Format` | Format the current file |
| `:GrepCurrentDir` | Grep in the current directory |
| `:GrepProject` | Grep in the project root |
| `:FindFilesInDir [path]` | Find files in a specific directory |
