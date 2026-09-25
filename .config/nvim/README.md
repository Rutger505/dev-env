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

### AI (sidekick.nvim)

| Key | Action |
|-----|--------|
| `<M-y>` (Alt+y) | Jump to / apply next edit suggestion (normal + insert) |
| `<M-l>` (Alt+l) | Accept ghost text (insert) |
| `<C-.>` | Focus the AI CLI window (any mode) |
| `<leader>aa` | Toggle Claude |
| `<leader>as` | Pick a CLI tool |
| `<leader>ad` | Detach CLI session |
| `<leader>at` | Send current position/selection (normal + visual) |
| `<leader>af` | Send current file |
| `<leader>av` | Send visual selection |
| `<leader>ap` | Pick a prompt (normal + visual) |

Ghost text at the cursor (Neovim's built-in `vim.lsp.inline_completion`) and next edit suggestions for other lines (sidekick) both come from the Copilot language server, which Mason installs. Next edit suggestions update while you type in insert mode too, and survive leaving insert mode. If nothing shows up, sign in with `:LspCopilotSignIn`.

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
| rust | rustfmt |

Install the formatter binary through `:Mason`. rustfmt comes from rustup instead.

## Rust

[rustaceanvim](https://github.com/mrcjkb/rustaceanvim) starts rust-analyzer for Rust buffers, so don't install `rust_analyzer` through Mason. It would start a second server. Install the server with `rustup component add rust-analyzer`. Diagnostics on save come from clippy.

`:RustLsp` has the extras: `runnables`, `testables`, `expandMacro`, `explainError`, `openCargo`.

[crates.nvim](https://github.com/saecki/crates.nvim) shows crate versions inline in `Cargo.toml`.

## Markdown

[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) renders headings, lists, checkboxes, tables and code blocks inside the buffer. It activates on `markdown` filetypes; concealed markup expands again on the line the cursor sits on.

## TODO

- [ ] Add DAP (debugger) support — `nvim-dap` + `nvim-dap-ui`
- [ ] Add flash.nvim
- [ ] Add some sort of ai integrations (sidekick.nvim prototype in `lua/plugins/sidekick.lua`)
