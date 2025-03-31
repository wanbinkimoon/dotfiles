# Configuration

This section covers the core configuration files that set up the basic behavior of Neovim.

## Vim Options

**File**: `nvim/lua/config/vim.lua`

Sets up basic Vim options and keymappings.

**Features**:
- Tab and indentation settings
- Leader key configuration
- UI options like line numbers and scrolling
- Basic keymappings
- Highlight on yank
- Disables some built-in plugins for performance

**Key Settings**:
- `mapleader = " "` (Space)
- `maplocalleader = ","` (Comma)
- 2-space indentation
- Line numbers enabled
- Swap files disabled
- Undo file enabled
- Split right behavior

**Key Mappings**:
- `<Esc>` - Clear search highlighting
- `<leader>o` - Add new line below (staying in normal mode)
- `<leader>O` - Add new line above (staying in normal mode)

## Lazy Plugin Manager

**File**: `nvim/lua/config/lazy.lua`

Sets up the lazy.nvim plugin manager and loads plugins from the specified categories.

**Features**:
- Automatic installation of lazy.nvim if not present
- Loads plugins from categorized directories
- Disables some built-in Vim plugins for performance
- Configures UI options for the plugin manager

**Plugin Categories**:
- code
- editor
- git
- lsp
- search
- tmux
- ui

## Folding

**File**: `nvim/lua/config/folding.lua`

Configures code folding behavior.

**Features**:
- Sets fold column to always be visible
- Uses indent-based folding by default
- Sets foldlevel to 99 (mostly expanded)
- Provides keymappings to change fold methods

**Key Mappings**:
- `<leader>zfm` - Change fold method to manual
- `<leader>zfi` - Change fold method to indent
- `<leader>zfs` - Change fold method to syntax
- `<leader>zfe` - Change fold method to expr

## Moving Code

**File**: `nvim/lua/config/move-code.lua`

Provides keymappings for moving lines or blocks of code.

**Key Mappings**:
- `<A-Down>` - Move line/selection down
- `<A-Up>` - Move line/selection up

## Splits

**File**: `nvim/lua/config/splits.lua`

Configures split behavior and navigation.

**Key Mappings**:
- `sl` - Split vertically
- `sj` - Split horizontally
- `sq` - Close pane

## Tabs

**File**: `nvim/lua/config/tabs.lua`

Configures tab behavior and navigation.

**Key Mappings**:
- `<tab>n` - Open new tab
- `<tab>x` - Close current tab
- `<tab>l` or `<tab><tab>` - Go to next tab
- `<tab>h` - Go to previous tab
- `<tab>b` - Open current buffer in new tab
- `<tab>1` through `<tab>9` - Go to tab 1-9

## Auto Reload

**File**: `nvim/lua/config/autoreload.lua`

Configures automatic reloading of files when they change on disk.

**Features**:
- Sets autoread option
- Checks for file changes on various events
- Shows notification when files are reloaded
- Configurable update time (1000ms default)

## Tmux Integration

**File**: `nvim/lua/config/tmux.lua`

Configures integration with tmux-window-name plugin.

**Features**:
- Automatically updates tmux window names based on the current file
- Runs on VimEnter and VimLeave events

## Icons

**File**: `nvim/lua/config/icons.lua`

Defines icons used throughout the configuration.

**Categories**:
- kind: Icons for LSP kinds (Function, Method, etc.)
- type: Icons for types (Array, Number, etc.)
- documents: Icons for files and folders
- git: Icons for git status
- ui: Icons for UI elements
- diagnostics: Icons for diagnostic messages
- misc: Miscellaneous icons

## Main Entry Point

**File**: `nvim/init.lua`

The main entry point that loads all configuration modules.

**Loaded Modules**:
- config.vim
- config.lazy
- config.tmux
- config.folding
- config.move-code
- config.splits
- config.tabs
- config.autoreload
- customs
