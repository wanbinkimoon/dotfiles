# Editor Plugins

This section covers plugins that enhance the general editing experience in Neovim.

## symbols-outline.nvim

A tree-like view for symbols in Neovim using LSP.

**File**: `nvim/lua/plugins/editor/symbols-outline.lua`

**Features**:
- Shows a tree-like view of symbols in the current file
- Supports navigation between symbols
- Configurable display options

**Key Mappings**:
- `<leader>cs` - Toggle Symbols Outline

## trouble.nvim

A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.

**File**: `nvim/lua/plugins/editor/trouble.nvim`

**Features**:
- Displays diagnostics, references, and other lists in a structured view
- Supports filtering and sorting
- Customizable display options

**Key Mappings**:
- `<leader>xx` - Toggle diagnostics list
- `<leader>xX` - Toggle buffer diagnostics

## which-key.nvim

Displays a popup with possible key bindings of the command you started typing.

**File**: `nvim/lua/plugins/editor/which-key.lua`

**Features**:
- Shows available key bindings in a popup
- Helps discover and remember mappings
- Supports different presets (classic, modern, helix)

**Key Mappings**:
- `<leader>?` - Show global keymaps

## Custom Editor Configurations

### Folding

**File**: `nvim/lua/config/folding.lua`

**Features**:
- Configures code folding behavior
- Sets fold column to always be visible
- Uses indent-based folding by default

**Key Mappings**:
- `<leader>zfm` - Change fold method to manual
- `<leader>zfi` - Change fold method to indent
- `<leader>zfs` - Change fold method to syntax
- `<leader>zfe` - Change fold method to expr

### Splits

**File**: `nvim/lua/config/splits.lua`

**Features**:
- Configures split behavior
- Provides mappings for creating and navigating splits

**Key Mappings**:
- `sl` - Split vertically
- `sj` - Split horizontally
- `sq` - Close pane

### Tabs

**File**: `nvim/lua/config/tabs.lua`

**Features**:
- Configures tab behavior
- Provides mappings for creating and navigating tabs

**Key Mappings**:
- `<tab>n` - Open new tab
- `<tab>x` - Close current tab
- `<tab>l` or `<tab><tab>` - Go to next tab
- `<tab>h` - Go to previous tab
- `<tab>b` - Open current buffer in new tab
- `<tab>1` through `<tab>9` - Go to tab 1-9

### Moving Code

**File**: `nvim/lua/config/move-code.lua`

**Features**:
- Provides mappings for moving lines up and down

**Key Mappings**:
- `<A-Down>` - Move line down (normal mode)
- `<A-Up>` - Move line up (normal mode)
- `<A-Down>` - Move selection down (visual mode)
- `<A-Up>` - Move selection up (visual mode)

### Auto Reload

**File**: `nvim/lua/config/autoreload.lua`

**Features**:
- Automatically reloads files when they change on disk
- Shows notification when files are reloaded
