# UI Enhancements

This section covers plugins that enhance the user interface of Neovim.

## lualine.nvim

A blazing fast and easy to configure Neovim statusline.

**File**: `nvim/lua/plugins/ui/lualine.lua`

**Features**:
- Configurable statusline with various components
- Integration with git, diagnostics, and more
- Tab display with custom colors
- Global statusline

## neo-tree.nvim

A file explorer tree for Neovim.

**File**: `nvim/lua/plugins/ui/neo-tree.nvim`

**Features**:
- File system explorer
- Buffer list
- Git status view
- Customizable icons and behavior
- Floating window support

**Key Mappings**:
- `<leader>e` - Toggle file explorer
- `<leader>b` - Show buffers in floating window
- `<leader>G` - Show git status in floating window
- `<leader>w` - Toggle file explorer in floating window

## noice.nvim

Experimental UI for messages, cmdline, and popupmenu.

**File**: `nvim/lua/plugins/ui/noice.lua`

**Features**:
- Enhanced command line UI
- Better message display
- Customizable views for different types of content
- Integration with nvim-notify

## dracula.nvim

Dracula colorscheme for Neovim.

**File**: `nvim/lua/plugins/ui/dracula.lua`

**Features**:
- Dark theme with vibrant colors
- Support for transparent background
- Custom highlights for various plugins
- Italic comments

## tokyonight.nvim

A clean, dark Neovim theme.

**File**: `nvim/lua/plugins/ui/tokyonight.lua`

**Features**:
- Multiple variants (night, storm, day, moon)
- Customizable colors and highlights
- Support for various plugins

## statuscol.nvim

Status column plugin for showing line numbers, fold indicators, and more.

**File**: `nvim/lua/plugins/ui/statuscol.lua`

**Features**:
- Configurable status column
- Integration with gitsigns
- Fold indicators
- Line numbers with options for formatting

<!-- barbar.nvim has been removed -->

## dashboard (alpha-nvim)

A fast and fully programmable greeter for Neovim.

**File**: `nvim/lua/plugins/ui/dashboard.lua`

**Features**:
- Customizable start screen
- Quick access buttons for common actions
- Displays plugin statistics
- Visually appealing header

**Key Mappings** (from dashboard):
- `f` - Find file
- `n` - New file
- `r` - Recent files
- `t` - Find text
- `c` - Open config
- `q` - Quit

## Icons Configuration

**File**: `nvim/lua/config/icons.lua`

**Features**:
- Defines icons for various UI elements
- Used by multiple plugins for consistent appearance
- Categories include:
  - LSP kind icons
  - Type icons
  - Document icons
  - Git icons
  - UI icons
  - Diagnostic icons
