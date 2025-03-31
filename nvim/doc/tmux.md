# Tmux Integration

This section covers plugins and configurations that integrate Neovim with Tmux.

## nvim-tmux-navigation

Seamless navigation between Neovim splits and Tmux panes.

**File**: `nvim/lua/plugins/tmux/tmux-navigation.lua`

**Features**:
- Navigate between Neovim splits and Tmux panes using the same keybindings
- Consistent navigation experience across the terminal

**Key Mappings**:
- `<C-h>` - Navigate left
- `<C-j>` - Navigate down
- `<C-k>` - Navigate up
- `<C-l>` - Navigate right
- `<C-\>` - Navigate to last active pane/split
- `<C-Space>` - Navigate to next pane/split

## Tmux Configuration

**File**: `nvim/lua/config/tmux.lua`

**Features**:
- Integration with tmux-window-name plugin
- Automatically updates window names based on the current file
- Runs on VimEnter and VimLeave events

This integration ensures that your Tmux window names stay in sync with what you're editing in Neovim, providing better context when working with multiple windows and panes.

### Usage with tmux-window-name

The configuration automatically detects if the tmux-window-name plugin is installed and uses it to rename Tmux windows based on the current Neovim buffer. This provides a seamless experience where your Tmux window titles reflect what you're currently editing.

### Benefits of Tmux Integration

1. **Consistent Navigation**: Use the same key mappings to move between Neovim splits and Tmux panes
2. **Context Awareness**: Window names update to reflect the current file
3. **Workflow Enhancement**: Seamlessly work across multiple terminal sessions and Neovim instances
