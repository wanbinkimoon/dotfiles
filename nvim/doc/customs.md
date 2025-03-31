# Custom Functions

This section covers custom functions and utilities that enhance the Neovim experience.

## Find and Replace

**File**: `nvim/lua/customs/find-and-replace.lua`

A custom find and replace plugin that provides an interactive interface for finding and replacing text within the current buffer.

**Features**:
- Interactive split window for find and replace operations
- Highlights all matches in the target buffer
- Allows per-instance or global substitution
- Navigation between matches
- Undo last action

**Usage**:
- Call the `:Replace` command to open the find and replace window
- Enter the search text and replacement text
- Use the following commands in normal mode:
  - `<localleader>r` - Replace all instances
  - `<localleader>s` - Replace selected instance
  - `<localleader>n` - Select next instance
  - `<localleader>p` - Select previous instance
  - `<localleader>u` - Undo last action
  - `<localleader>c` - Close the find and replace window
  - `Esc` - Close the find and replace window

**Implementation Details**:
- Uses Neovim's API for buffer manipulation
- Creates a dedicated buffer for the find and replace interface
- Maintains an undo stack for reverting changes
- Uses namespaces for highlighting matches
- Provides visual feedback for the current selection

## Custom Command Registration

**File**: `nvim/lua/customs/init.lua`

Registers custom commands for use in Neovim.

**Commands**:
- `:Replace` - Opens the custom find and replace interface

This file serves as an entry point for custom functionality, making it easy to add more custom commands in the future.
