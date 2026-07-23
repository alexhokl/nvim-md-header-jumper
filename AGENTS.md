# AGENTS.md

Neovim plugin: jump between Markdown ATX headers using the built-in
`markdown` treesitter parser. Single-file implementation, no build system,
no tests, no CI.

## Layout

- `lua/md-header-jumper/init.lua` — entire plugin (queries, keymaps, user
  commands, `setup()`).
- `README.md` — source of truth for keymaps/commands and defaults; update it
  alongside `init.lua` when behavior changes.

## Conventions

- Tabs for indentation in `init.lua` (match existing style).
- Per-level functions (`goto_next_h1`..`h6`, `goto_prev_h1`..`h6`) and their
  keymaps/commands are generated via `for level = 1, 6 do` loops — add new
  levels there rather than hand-writing repetitive functions.
- Keymap options use `false` (not `nil`) to mean "don't bind this key";
  preserve that convention if adding new configurable keys.

## Verifying changes

There is no test suite or linter configured. To sanity-check changes,
load the plugin in Neovim against a markdown file, e.g.:

```
nvim --clean -u NONE -c "set rtp+=." -c "lua require('md-header-jumper').setup({})" some.md
```

then exercise `]hh`/`[hh` and `]h1`-`]h6`/`[h1`-`[h6`, or the
`:MdHeaderNext`/`:MdHeaderPrev` (and `H1`-`H6` variants) commands.
