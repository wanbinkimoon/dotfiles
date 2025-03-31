# Code Plugins

This section covers plugins that enhance coding experience, provide completion, and add syntax-related features.

## nvim-surround

A plugin for easily surrounding text with pairs of characters.

**File**: `nvim/lua/plugins/code/nvim-surround.lua`

**Features**:
- Add, change, or delete surrounding pairs like parentheses, quotes, etc.
- Works in normal, visual, and insert modes

**Key Mappings**:
- `ys` - Add surrounding in normal mode
- `yss` - Add surrounding to the current line
- `yS` - Add surrounding and place on new lines
- `ySS` - Add surrounding to the current line and place on new lines
- `ds` - Delete surrounding
- `cs` - Change surrounding
- `S` - Add surrounding in visual mode

## autoclose.nvim

Automatically closes pairs of characters like parentheses, brackets, and quotes.

**File**: `nvim/lua/plugins/code/auto-close.lua`

**Features**:
- Automatically inserts closing characters
- Lazy-loaded for better performance

## Comment.nvim

A plugin for easily commenting code.

**File**: `nvim/lua/plugins/code/comment.lua`

**Features**:
- Toggle comments on lines or blocks
- Supports multiple languages
- Context-aware commenting

**Key Mappings**:
- `gcc` - Toggle line comment
- `gbc` - Toggle block comment
- `gc` - Toggle comment (with motion or in visual mode)
- `gb` - Toggle block comment (with motion or in visual mode)

## nvim-cmp

Advanced completion plugin with multiple sources.

**File**: `nvim/lua/plugins/code/cpm-nvim.lua`

**Features**:
- LSP integration
- Snippet support
- Multiple completion sources
- Copilot integration

**Key Mappings**:
- `<C-Space>` - Complete
- `<C-b>/<C-f>` - Scroll docs
- `<C-e>` - Abort completion
- `<CR>` - Confirm selection

## mistake.nvim

Automatically corrects common typing mistakes.

**File**: `nvim/lua/plugins/code/mistake.lua`

**Features**:
- Corrects common typos as you type
- Customizable dictionary

## tailwindcss

Tools for working with Tailwind CSS.

**File**: `nvim/lua/plugins/code/tailwindcss.lua`

**Features**:
- Colorizer for Tailwind CSS classes in completion
- Tailwind tools for better integration

## avante.nvim

AI assistant integration for Neovim.

**File**: `nvim/lua/plugins/code/avante.lua`

**Features**:
- AI-powered code assistance
- File selection and context-aware suggestions
- Image pasting support

**Key Mappings**:
- `<C-a>` - Submit to AI assistant (insert mode)

## copilot

GitHub Copilot integration.

**File**: `nvim/lua/plugins/code/copilot.lua`

**Features**:
- AI-powered code completion
- Suggestion panel
- CMP integration (optional)

## nvim-treesitter-textobjects

Provides text objects based on treesitter for more precise code navigation and manipulation.

**File**: `nvim/lua/plugins/code/nvim-treesitter-textobjects.lua`

**Features**:
- Text objects for functions, classes, parameters, etc.
- Movement commands to navigate between code structures
- Swap functionality for parameters and other elements

**Key Mappings**:
- Various text objects like `af`/`if` (function), `ac`/`ic` (class), etc.
- Movement keys like `]m`/`[m` (next/previous method)
- Swap commands like `<leader>na` (swap parameter with next)
