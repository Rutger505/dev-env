# Neovim Config

Personal Neovim configuration built on [Lazy.nvim](https://github.com/folke/lazy.nvim).

**Leader key:** `Space`

## Keybindings

### General

| Key | Action |
|-----|--------|
| `<Esc>` | Clear search highlights |

### Windows

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move focus between windows / tmux panes |
| `<C-Left/Right>` | Resize window width |
| `<C-Up/Down>` | Resize window height |
| `<leader>wc` | Close window |
| `<leader>w-` | Split horizontal |
| `<leader>w\` | Split vertical |
| `<leader>we` | Equalize windows |

### Navigation

| Key | Action |
|-----|--------|
| `[t` / `]t` | Prev / next tab |
| `<leader>tn` | New tab |
| `<leader>tc` | Close tab |
| `[b` / `]b` | Prev / next buffer |
| `<leader>bn` | New buffer |
| `<leader>bc` | Close buffer |
| `[h` / `]h` | Prev / next git hunk |
| `[d` / `]d` | Prev / next diagnostic |
| `[e` / `]e` | Prev / next error |
| `[q` / `]q` | Prev / next quickfix |

### Telescope

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Switch buffers |
| `<leader>fh` | Search help tags |
| `<leader>ft` | Search TODO comments |
| `<leader>f.` | Resume last search |

### File Explorer

| Key | Action |
|-----|--------|
| `<leader>e` | Focus Neo-tree |
| `<leader>E` | Reveal current file in Neo-tree |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>cd` | Go to declaration |
| `<leader>ci` | Go to implementation |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |

### Code

| Key | Action |
|-----|--------|
| `<leader>cc` | Comment line / selection (normal + visual) |
| `<leader>cf` | Format buffer or selection |
| `<leader>cs` | Symbol browser |
| `<leader>cl` | LSP definitions panel |
| `<leader>cp` | PlantUML preview (in `.puml` files) |

### Diagnostics

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle project diagnostics |
| `<leader>xX` | Toggle buffer diagnostics |
| `<leader>xd` | Diagnostic float |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Open LazyGit |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |

### Plugin Manager

| Key | Action |
|-----|--------|
| `<leader>l` | Open Lazy |
| `<leader>m` | Open Mason |
| `<leader>qq` | Quit all |

## Language Servers

Language servers are managed by [Mason](https://github.com/williamboman/mason.nvim). `lua_ls` is pre-installed. To add more, either:

- Open `:Mason` and install them manually, or
- Add them to `ensure_installed` in `lua/plugins/lsp.lua`

Treesitter parsers are installed automatically (`auto_install = true`) when you open a file.

## Formatting

[conform.nvim](https://github.com/stevearc/conform.nvim) formats on save. Formatters are configured per filetype in `lua/plugins/editor.lua`; filetypes without one are left untouched.

| Filetype | Formatter |
|----------|-----------|
| markdown | prettier |

Install the formatter binary through `:Mason`.

## Markdown

[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) renders headings, lists, checkboxes, tables and code blocks inside the buffer. It activates on `markdown` filetypes; concealed markup expands again on the line the cursor sits on.

## TODO

- [ ] Add DAP (debugger) support — `nvim-dap` + `nvim-dap-ui`
- [ ] Add flash.nvim
- [ ] Add some sort of ai integrations
