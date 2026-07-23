# nvim-md-header-jumper

Jump between Markdown (ATX) headers using treesitter.

## Features

- `]h` — jump to the next header
- `[h` — jump to the previous header
- `:MdHeaderNext` / `:MdHeaderPrev` user commands
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
  next_key = "]h",  -- keymap for jumping to the next header
  prev_key = "[h",  -- keymap for jumping to the previous header
})
```

Pass `false` for either key to skip binding it (e.g. you want to map the
commands to different keys yourself):

```lua
require("md-header-jumper").setup({
  next_key = false,
  prev_key = false,
})
```

The `:MdHeaderNext` and `:MdHeaderPrev` commands are always available once
`setup()` has run.
