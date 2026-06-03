# Neovim Cheat Sheet

Open with `:CheatSheet`, `:Cheatsheet`, or `<leader>?`.

---

## Getting Help
| Key | Action |
|-----|--------|
| `<space>` | Show leader key popup (which-key) |
| `<leader>?` | Open this cheat sheet |
| `:checkhealth` | Full health report |
| `:Mason` | Package manager for LSP/tools |

---

## Navigation

### Find / Search
| Key | Action |
|-----|--------|
| `<leader><leader>` | Find files |
| `<leader>/` | Live grep (search text) |
| `<leader>,` | List buffers |
| `<leader>.` | Recent files |
| `<leader>;` | Resume last picker |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>fc` | Commands |
| `<leader>fg` | Git-tracked files (fast) |
| `<leader>sd` | Search diagnostics |

### Buffers
| Key | Action |
|-----|--------|
| `[b` / `]b` | Previous / next buffer |
| `<leader>bb` | Switch to alternate buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bn` / `<leader>bp` | Next / previous buffer |

### Windows
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move focus between windows |
| `<leader>wv` / `<leader>ws` | Vertical / horizontal split |
| `<leader>wq` | Close window |
| `<leader>w=` | Equalize window sizes |
| `<leader>wh/l/j/k` | Resize window (left/right/down/up) |

### Quickfix
| Key | Action |
|-----|--------|
| `[q` / `]q` | Previous / next item |
| `<leader>qo` / `<leader>qc` | Open / close list |
| `<leader>qq` | Quit Neovim |

### Bookmarks & Projects
| Key | Action |
|-----|--------|
| `<leader>ba` | Bookmark current directory |
| `<leader>bd` | Remove bookmark |
| `<leader>fp` | Fuzzy-find and jump to a bookmark |

### Sessions
| Key | Action |
|-----|--------|
| `<leader>Sr` | Restore project session |
| `<leader>Sl` | Restore last session |
| `<leader>Ss` | Save session |
| `<leader>Sd` | Stop autosave |
| `:WorkspaceRestore` | Restore workspace session |

---

## Editing

### Movement & Selection
| Key | Action |
|-----|--------|
| `s` / `S` | Flash jump / Flash treesitter jump |
| `n` / `N` | Next / previous search result (centered) |
| `gc` / `gcc` | Toggle comment / current line |
| `J` | Join lines (keep cursor) |
| `<leader>h` | Clear search highlights |

### Visual Mode
| Key | Action |
|-----|--------|
| `<` / `>` | Indent left/right (keep selection) |
| `J` / `K` | Move selection down / up |

### Insert Mode
| Key | Action |
|-----|--------|
| `jk` | Exit to normal mode |

---

## LSP (Language Server Protocol)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>e` | Show diagnostic float |
| `<leader>ca` | Code actions |
| `<leader>cf` | Format buffer |
| `<leader>cl` | Code actions (Trouble) |
| `<leader>cs` | Signature help |
| `<leader>cS` | Search workspace symbols |
| `<leader>rn` | Rename symbol |
| `<leader>rr` | Incremental rename (preview) |
| `<leader>xl` | Diagnostics to loclist |

---

## Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gb` | Open remote in browser |
| `<leader>gl` | Git line history (current line or selection) |
| `[h` / `]h` | Previous / next hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>ru` | Diff unstaged |
| `<leader>rm` | Diff against `main` |
| `<leader>rh` | Diff against `HEAD~1` |

---

## Debugging (DAP)
| Key | Action |
|-----|--------|
| `<leader>b` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>dq` | Terminate |
| `<leader>dr` | Open REPL |
| `<leader>dl` | Rerun last |
| `<leader>dh` | Hover value |
| `<leader>dj` / `<leader>di` / `<leader>do` | Step over / into / out |
| `<leader>db` | Toggle debug UI |
| `<leader>de` | Evaluate expression |

---

## Terminal (toggleterm)
| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle terminal (current mode) |
| `<leader>tf` | Floating terminal |
| `<leader>th` | Horizontal split |
| `<leader>tv` | Vertical split |
| `<leader>tm` | Cycle mode |
| `Esc` / `jk` | Exit terminal mode |
| `<C-h/j/k/l>` | Move to window |
| `<C-q>` | Close terminal |

---

## Outline & Symbols
| Key | Action |
|-----|--------|
| `<leader>v` | Toggle outline (Aerial) |
| `<leader>xs` | Document symbols (Trouble) |
| `<leader>xx` | Diagnostics list (Trouble) |
| `<leader>xX` | Buffer diagnostics (Trouble) |
| `<leader>xq` | Quickfix list (Trouble) |
| `<leader>xt` | TODO/FIXME comments (Trouble) |
| `[t` / `]t` | Previous / next TODO comment |

---

## Misc
| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>Q` | Quit all (no save) |
| `<leader>u` | Undo tree |
| `<leader>z` | Zen mode (focus) |
| `<leader>M` | Open Mason |
| `<leader>o` / `-` | Open Oil file explorer |
| `<leader>fe` | Open Oil file explorer |
| `<leader>cp` / `<leader>cr` | Copy absolute / relative path |

---

## Mason Installed Tools

**LSP servers:** `bashls`, `clangd`, `gopls`, `jsonls`, `lua_ls`, `marksman`, `pyright`, `rust_analyzer`, `taplo`, `ts_ls`, `yamlls`

**Formatters & linters:** `eslint_d`, `markdownlint`, `prettier`, `ruff`, `shellcheck`, `shfmt`, `stylua`, `yamllint`

---

## Plugin Overview

| Plugin | Purpose |
|--------|---------|
| blink.cmp | Completion with ghost text & signature help |
| snacks.nvim | Fuzzy finder, scroll, indent guides, Zen mode |
| which-key.nvim | Keymap discovery popup |
| conform.nvim | Auto-format on save |
| mason.nvim | Install LSP servers & tools |
| oil.nvim | Filesystem as a buffer |
| nvim-dap + dap-ui | Full debugger |
| toggleterm.nvim | Floating / split terminal |
| trouble.nvim | Diagnostics, symbols, TODOs |
| gitsigns.nvim | Git gutter signs & hunk ops |
| lazygit.nvim | Git TUI integration |
| codediff.nvim | Visual diff viewer |
| flash.nvim | Fast buffer jumps |
| todo-comments.nvim | Highlight TODO/FIXME |
| Comment.nvim | `gc` for fast commenting |
| nvim-autopairs | Auto-close brackets & quotes |
| nvim-lint | Async linting on save |
| persistence.nvim | Session save & restore |
| aerial.nvim + nvim-navic | Outline + winbar breadcrumbs |
| bufferline.nvim | Tab bar for buffers |
| inc_rename.nvim | Rename with live preview |
| fidget.nvim | LSP progress spinner |
| nvim-lightbulb | Lightbulb for code actions |
| illuminate.nvim | Highlight word under cursor |
| undotree | Visual undo history |
| alpha-nvim | Startup dashboard |
| tokyonight | Colorscheme |
| mini.nvim (icons, ai, surround) | Icons, text objects, surrounds |
| render-markdown.nvim | Markdown rendering |

---

## Notes
- Open any new file type → Mason & Treesitter auto-install support
- Statusline shows: mode | filename | pwd | git branch | filetype | cursor position
- Bookmarks saved to `~/.config/nvim/bookmarks.json`
- Winbar breadcrumbs appear when LSP supports document symbols
- `jk` works in both insert mode and terminal mode
