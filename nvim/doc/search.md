# Search Tools

This section covers plugins that enhance search and navigation capabilities in Neovim.

## telescope.nvim

A highly extendable fuzzy finder over lists.

**File**: `nvim/lua/plugins/search/telescope.nvim`

**Features**:
- Fuzzy finding for files, buffers, text, and more
- Extensible with various plugins
- Customizable UI and behavior
- Integration with git, LSP, and other tools

**Extensions**:
- telescope-ui-select: Uses Telescope for vim.ui.select
- telescope-live-grep-args: Enhanced live grep with arguments
- telescope-git-branch: Git branch integration
- telescope-git-file-history: File history viewing
- telescope-tabs: Tab management

**Key Mappings**:
- `<leader>sf` - Find files
- `<leader><leader>` - Recent files
- `<leader>sb` - Buffers
- `<leader>sg` - Live grep
- `<leader>sw` - Search word under cursor
- `<leader>ss` - Search current selection (visual mode)
- `<leader>sd` - Git diff
- `<leader>sb` - Git branches
- `<leader>sc` - Git commits
- `<leader>sh` - Git history
- `<leader>sH` - Git file history
- `<leader>st` - List tabs
- `gd` - LSP definitions
- `gr` - LSP references
- `gi` - LSP implementations
- `gt` - LSP type definitions
- `gs` - LSP document symbols

**Custom Commands**:
- `:GrepCurrentDir` - Grep in the current directory
- `:GrepProject` - Grep in the project root
- `:FindFilesInDir [path]` - Find files in a specific directory

## grug-far.nvim

A find and replace plugin.

**File**: `nvim/lua/plugins/search/grug-far.lua`

**Features**:
- Interactive find and replace across files
- Preview changes before applying
- Transient mode for quick operations

**Key Mappings**:
- `<leader>sr` - Open search and replace

## Custom Find and Replace

**File**: `nvim/lua/customs/find-and-replace.lua`

**Features**:
- Interactive find and replace within the current buffer
- Highlights all matches
- Allows per-instance or global substitution
- Navigation between matches
- Undo functionality

**Usage**:
- `:Replace` - Open the find and replace window

**Key Mappings in Find and Replace Window**:
- `<localleader>r` - Replace all instances
- `<localleader>s` - Replace selected instance
- `<localleader>n` - Select next instance
- `<localleader>p` - Select previous instance
- `<localleader>u` - Undo last action
- `<localleader>c` or `Esc` - Close the find and replace window
