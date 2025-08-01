# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Neovim configuration repository structured around the Lazy plugin manager. It provides a full-featured IDE-like experience with focus on web development (JavaScript/TypeScript, HTML, CSS) and Lua development.

## Architecture

- **Plugin Management**: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management with lazy-loading
- **Plugin Organization**: Plugins are categorized by functionality in `lua/plugins/`:
  - `code/`: LSP, syntax highlighting, formatting, linting
  - `completion/`: code completion, AI assistance
  - `editor/`: todo comments, diagnostics, keybinding help
  - `git/`: commands, URL generation, indicators
  - `navigation/`: fuzzy finding, motion, file exploration
  - `ui/`: statusline, file explorer, themes
- **Core Configuration**: Core settings are in `lua/config/`:
  - `init.lua`: Central configuration loader
  - `vim.lua`: Core Vim settings
  - `keymaps.lua`: Global keybindings
  - `lsp.lua`: LSP configuration
- **LSP Configurations**: Individual language server configurations in `lsp/` directory

## Key Components

### Language Server Protocol (LSP)

- LSP configurations are stored in `lsp/*.lua` files
- Language servers are enabled via `vim.lsp.enable()` in `lua/config/lsp.lua`
- Key LSP plugins:
  - nvim-lspconfig: Core LSP configuration
  - mason.nvim: Language server installer
  - conform.nvim: Code formatting
  - nvim-lint: Linting

### Code Formatting & Linting

- Uses `conform.nvim` for formatting with `:Format` command and auto-format on save
- Primary formatters:
  - prettierd: For JavaScript/TypeScript/web files
  - stylua: For Lua files

### Navigation & Search

- Telescope for fuzzy finding with customized UI
  - `<leader>sf`: Find files
  - `<leader><leader>`: Recent files
  - `<leader>sg`: Live grep
  - `<leader>sw`: Search word under cursor

### File Explorer

- Neo-tree file explorer
  - `<leader>e`: Toggle file explorer
  - `<leader>b`: Toggle buffer explorer
  - `<leader>G`: Toggle git status

### AI Assistance

- CodeCompanion for AI coding assistance (Anthropic-powered)
  - `<leader>cc`: Open chat
  - `<leader>ci`: Inline assistant
  - `<leader>cp`: Actions palette
  - `<leader>ce`: Explain code (visual mode)

## Key Keybindings

- Space (`<space>`) is the leader key
- Navigation:
  - `<tab>n`: New tab
  - `<tab>x`: Close tab
  - `<tab><tab>` or `<tab>l`: Next tab
  - `<tab>h`: Previous tab
  - `sl`: Split vertically
  - `sj`: Split horizontally
  - `sq`: Close pane
- LSP:
  - `K`: Show hover documentation
  - `<leader>ca`: Code actions
  - `<leader>cr`: Rename symbol
  - `Gd`: Go to definition
  - `Gr`: Find references
  - `Gt`: Go to type definition

## Working with this Repository

When modifying this configuration:

1. Study the existing plugin structure before adding new plugins
2. Follow the categorization in `lua/plugins/` directories
3. Use lazy-loading with appropriate events/commands
4. Match the existing code style (indentation, naming, etc.)
5. Test changes before committing

To add a new plugin:
1. Create a new file in the appropriate category directory in `lua/plugins/`
2. Follow the lazy.nvim format as seen in existing files
3. Configure appropriate lazy-loading

To add language support:
1. Add a new LSP configuration file in `lsp/`
2. Enable the language server in `lua/config/lsp.lua`
3. Configure formatting in `lua/plugins/code/conform.lua`