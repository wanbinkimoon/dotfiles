# LSP (Language Server Protocol) Setup

This section covers plugins and configurations related to the Language Server Protocol in Neovim.

## nvim-lspconfig

Configurations for built-in LSP client.

**File**: `nvim/lua/plugins/lsp/nvim-lspconfig.lua`

**Features**:
- Configures various language servers
- Sets up diagnostic signs and handlers
- Provides key mappings for LSP functionality

**Configured Language Servers**:
- TypeScript (ts_ls)
- HTML
- Lua (lua_ls)
- YAML (yamlls)
- JSON (jsonls)
- CSS (cssls)
- Python (pyright)
- ESLint

**Key Mappings**:
- `<leader>D` - Hover documentation
- `<leader>cd` - Go to definition
- `<leader>cR` - Find references
- `<leader>ci` - Go to implementation
- `<leader>ca` - Code action
- `<leader>cr` - Rename symbol

## mason.nvim

Portable package manager for Neovim that runs everywhere Neovim runs.

**File**: `nvim/lua/plugins/lsp/mason.lua`

**Features**:
- Manages installation of LSP servers, DAP servers, linters, and formatters
- Integrates with lspconfig for automatic server setup
- Provides a UI for managing tools

**Automatically Installed Servers**:
- lua_ls
- prosemd_lsp
- eslint
- cssls
- ts_ls
- ember
- texlab
- pyright
- cmake
- emmet_language_server
- tailwindcss

## none-ls.nvim

Use Neovim as a language server to inject LSP diagnostics, code actions, and more.

**File**: `nvim/lua/plugins/lsp/none-ls.lua`

**Features**:
- Provides formatting, diagnostics, and code actions from non-LSP sources
- Integrates with the built-in LSP client
- Supports various tools like prettier, eslint, etc.

**Configured Sources**:
- stylua (Lua formatter)
- prettier (JavaScript/TypeScript/CSS/HTML formatter)
- erb_lint (ERB diagnostics)
- rubocop (Ruby diagnostics and formatting)

**Key Mappings**:
- `<leader>cfc` - Format current file

## conform.nvim

A formatting plugin that works with LSP clients and external formatters.

**File**: `nvim/lua/plugins/lsp/conform.lua`

**Features**:
- Provides formatting for various languages
- Can use LSP formatters or external tools
- Supports formatting on save

**Configured Formatters**:
- stylua (Lua)
- isort, black (Python)
- rustfmt (Rust)
- prettier (JavaScript, YAML, CSS, HTML, JSON, Markdown)

## treesitter

Provides syntax highlighting and code navigation based on a concrete syntax tree.

**File**: `nvim/lua/plugins/lsp/treesitter.lua`

**Features**:
- Enhanced syntax highlighting
- Incremental selection based on syntax nodes
- Indentation based on syntax
- Auto-installation of language parsers

**Installed Parsers**:
- json, javascript, typescript, tsx
- yaml, html, css
- prisma, markdown, svelte, graphql
- bash, lua, vim
- dockerfile, gitignore
- and more

**Key Mappings**:
- `<C-space>` - Incremental selection
- `<bs>` - Decremental selection

## LSP Utilities

**File**: `nvim/lua/utils/lsp.lua`

**Features**:
- Common LSP setup functions
- Document highlighting
- Key mapping setup
- Capabilities configuration
