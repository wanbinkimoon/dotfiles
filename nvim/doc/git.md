# Git Plugins

This section covers plugins that provide Git integration in Neovim.

## gitsigns.nvim

Adds git decorations to the buffer and provides git operations.

**File**: `nvim/lua/plugins/git/gitsigns.lua`

**Features**:
- Shows git changes in the sign column
- Provides blame line information
- Allows navigation between hunks
- Supports staging, unstaging, and resetting hunks

**Key Mappings**:
- `<leader>gi` - Diff this file
- `<leader>gp` - Preview hunk
- `<leader>gl` - Blame line with full details
- `<localleader>]` - Navigate to next hunk
- `<localleader>[` - Navigate to previous hunk
- `<localleader>r` - Reset hunk

## gitlinker.nvim

Generate shareable file permalinks for various Git web frontend hosts.

**File**: `nvim/lua/plugins/git/gitlinker.lua`

**Features**:
- Creates URLs to the current file/selection on GitHub, GitLab, etc.
- Supports custom URL formats
- Works with visual selections for line ranges

**Key Mappings**:
- `<leader>gy` - Open current file/selection in browser (normal and visual modes)

## fugitive

The premier Git plugin for Vim/Neovim.

**File**: `nvim/lua/plugins/git/fugitive.lua`

**Features**:
- Full Git integration
- Git status, blame, diff, and more
- Integration with diffview.nvim for enhanced diff viewing

**Key Mappings**:
- `<leader>gs` - Open git status
- `<leader>gb` - Git blame
- `<leader>gd` - Git diff
- `<leader>gD` - Git diff split
- `<leader>gk` - Diff get from right (in diff view)
- `<leader>gj` - Diff get from left (in diff view)
- `<leader>gv` - Open diff view
- `<leader>gc` - Close diff view

## lazygit.nvim

Plugin for calling lazygit from within Neovim.

**File**: `nvim/lua/plugins/git/lazygit.lua`

**Features**:
- Opens lazygit in a floating window
- Provides a seamless Git UI experience without leaving Neovim

**Key Mappings**:
- `<leader>lg` - Open lazygit

## diffview.nvim

A tabpage interface for easily cycling through diffs for all modified files for any git rev.

**Features**:
- Enhanced diff view similar to VSCode
- File history view
- Customizable layouts
- File tree navigation

**Configuration**:
- Horizontal diff layout by default
- Tree-style file listing
- Integration with fugitive
