# nvim-md-header-jumper

Jump between Markdown (ATX) headers using treesitter.

## Features

- `]hh` — jump to the next header
- `[hh` — jump to the previous header
- `]h1`-`]h6` — jump to the next header of a specific level (h1-h6)
- `[h1`-`[h6` — jump to the previous header of a specific level (h1-h6)
- `:MdHeaderNext` / `:MdHeaderPrev` user commands
- `:MdHeaderNextH1`-`:MdHeaderNextH6` / `:MdHeaderPrevH1`-`:MdHeaderPrevH6`
  user commands for level-specific jumps
- Uses the built-in `markdown` treesitter parser; no extra plugins required

## Requirements

- Neovim 0.10+
- A `markdown` treesitter parser (`:TSInstall markdown` if you use
  nvim-treesitter, or via your distribution)

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "alexhokl/nvim-md-header-jumper",
  ft = "markdown",
  opts = {},
}
```

## Configuration

Defaults:

```lua
require("md-header-jumper").setup({
  next_key = "]hh",  -- keymap for jumping to the next header
  prev_key = "[hh",  -- keymap for jumping to the previous header

  -- keymaps for jumping to the next/previous header of a specific level
  next_h1_key = "]h1",
  next_h2_key = "]h2",
  next_h3_key = "]h3",
  next_h4_key = "]h4",
  next_h5_key = "]h5",
  next_h6_key = "]h6",
  prev_h1_key = "[h1",
  prev_h2_key = "[h2",
  prev_h3_key = "[h3",
  prev_h4_key = "[h4",
  prev_h5_key = "[h5",
  prev_h6_key = "[h6",
})
```

Pass `false` for any key to skip binding it (e.g. you want to map the
commands to different keys yourself):

```lua
require("md-header-jumper").setup({
  next_key = false,
  prev_key = false,
  next_h1_key = false,
  prev_h1_key = false,
})
```

The `:MdHeaderNext` / `:MdHeaderPrev` commands and the level-specific
`:MdHeaderNextH1`-`:MdHeaderNextH6` / `:MdHeaderPrevH1`-`:MdHeaderPrevH6`
commands are always available once `setup()` has run.
