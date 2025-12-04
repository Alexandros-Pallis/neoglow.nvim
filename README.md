# neoglow.nvim

A Neovim plugin for previewing Markdown files using [Glow](https://github.com/charmbracelet/glow) directly in your neovim editor.

> [!CAUTION]
**EARLY DEVELOPMENT WARNING**: This plugin is in a very early stage of development. Use at your own risk. Expect breaking changes, bugs, and incomplete features.

## Features

- Preview Markdown files with Glow's beautiful terminal rendering
- Toggle between source and preview with simple commands
- Automatic detection of Markdown files
- Quick buffer switching with `q` key in preview mode

## Requirements

- **Neovim** >= 0.7.0 (requires `vim.api.nvim_create_user_command`, `vim.api.nvim_set_option_value`, and terminal job control APIs)
- **[Glow](uttps://github.com/charmbracelet/glow)** - Must be installed and available in your PATH

### Installing Glow

```bash
# macOS
brew install glow

# Arch Linux
pacman -S glow

# Nix
nix-env -iA nixpkgs.glow

# From source
go install github.com/charmbracelet/glow@latest
```

For other installation methods, see [Glow's documentation](https://github.com/charmbracelet/glow#installation).

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

**Option 1: Lazy-load on keypress (recommended)**

```lua
{
  "Alexandros-Pallis/neoglow.nvim",
  opts = {
    keys = {
      {
        "<leader>og",
        function() require("neoglow").toggle() end,
        desc = "Toggle Neoglow",
      },
    },
  },
}
```

**Option 2: Load immediately, use command only**

```lua
{
  "Alexandros-Pallis/neoglow.nvim",
  opts = {},
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "Alexandros-Pallis/neoglow.nvim",
  config = function()
    require("neoglow").setup({})
  end,
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'Alexandros-Pallis/neoglow.nvim'

lua << EOF
  require("neoglow").setup({})
EOF
```

## Usage

### Commands

- `:Neoglow toggle` - Toggle Glow preview of the current Markdown file

### Default Keybindings

- `q` - Return to source buffer (when in preview mode)

No toggle keymap is set by default. Use `:Neoglow toggle` or configure your own keymap (see Configuration section).

### Example Workflow

1. Open a Markdown file in Neovim
2. Run `:Neoglow toggle` (or use a custom keymap if configured)
3. View the rendered preview in the same window
4. Press `q` to return to the source Markdown file
5. Run `:Neoglow toggle` again to toggle back to the preview

## Configuration

You can customize keymaps by passing options to `setup()`:

```lua
require("neoglow").setup({
  keys = {
    {
      "<leader>og",
      function() require("neoglow").toggle() end,
      desc = "Toggle Neoglow",
    },
  },
})
```

## How It Works

neoglow.nvim creates a terminal buffer and runs Glow to render your Markdown file. The preview replaces your current window, and you can easily switch back to the source file with a single keypress.

## Limitations

- Preview is read-only (no live editing/updates)
- Works only with saved Markdown files
- No custom Glow configuration options yet
- Single window preview only

## Roadmap

- [ ] Live preview updates on buffer save
- [ ] Custom Glow styling options
- [ ] Split window preview mode
- [x] Configurable keybindings
- [ ] Support for unsaved buffers
- [ ] Better error handling

## Contributing

Contributions are welcome! This is an early-stage project, so feel free to open issues for bugs, feature requests, or submit pull requests.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Glow](https://github.com/charmbracelet/glow) - The beautiful Markdown renderer that powers this plugin
