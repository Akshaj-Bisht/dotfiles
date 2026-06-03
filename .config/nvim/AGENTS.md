# Neovim 0.12.2 Config - Agent Plan

## ⚠️ Required Version: Neovim 0.12.2
This configuration uses **Neovim 0.12.2** native APIs and features. It will NOT work with previous versions (0.11, 0.10, etc.).

Key 0.12-only features used:
- Native `vim.lsp.config` API (not lspconfig wrapper)
- Built-in Treesitter (no plugin needed for basic highlighting)
- Native `vim.pack` package manager
- Modern `blink.cmp` completion engine
- `which-key.nvim` with modern API

## Overview
Migrated from single init.lua to modular structure with Neovim 0.12 best practices.

## All Requirements Implemented:

### 1. Modular Structure ✅
- Split into `lua/config/` and `lua/plugins/`
- Clean separation of options, keymaps, autocmds, and plugins

### 2. Auto-Install (Main Requirement) ✅
- Open any file → detects filetype
- Automatically installs Treesitter parser if missing
- Automatically installs LSP server via Mason if missing
- Automatically installs common formatter tools via Mason on startup
- DAP remains configured, but adapter installation is still manual
- **Minimal manual setup needed**: system prerequisites below must exist

### 3. Built-in Theme ✅
- Using `default` theme (Neovim branded green-blue)
- No external theme plugin needed

### 4. Cheat Sheet / Keymap Discovery ✅
- which-key.nvim shows popup when pressing keys
- Press `<space>` to see ALL available keymaps
- `:CheatSheet` and `<leader>?` open a full single-file cheat sheet
- Alpha startup screen shows quick reference

### 5. Best Modern Plugins (2025/2026) ✅
| Plugin | Purpose |
|--------|---------|
| blink.cmp | Best completion engine |
| snacks.nvim (picker) | Fuzzy finder |
| which-key.nvim | Keymap popup discovery |
| snacks.nvim | UI animations, indent guides, file picker |
| conform.nvim | Fast formatting |
| mason.nvim | Auto-install LSP/DAP/Formatters |
| mason-lspconfig.nvim | Auto-enable and install LSPs |
| mason-tool-installer.nvim | Keep common tools installed |

### 6. Tools Kept from Original Config ✅
- oil.nvim (file explorer)
- nvim-dap + nvim-dap-python (debugging)
- render-markdown.nvim (markdown rendering)
- codediff.nvim (visual diffs)
- lazygit.nvim (git UI)
- alpha-nvim (startup screen)

### 7. Leader Key ✅
- Space (`<space>`) as leader key

### 8. Native LSP Config ✅
- Uses `vim.lsp.config` (Neovim 0.12 native API)
- No deprecated lspconfig warnings

## Directory Structure
```
nvim/
├── init.lua                 # Entry point
├── AGENTS.md               # This file
└── lua/
    ├── config/
    │   ├── options.lua     # Vim options
    │   ├── keymaps.lua     # Key mappings
    │   └── autocmds.lua    # Autocommands
    └── plugins/
        ├── lsp.lua         # Native vim.lsp.config + Mason
        ├── treesitter.lua  # Built-in Treesitter
        ├── completion.lua  # blink.cmp
        ├── ui.lua          # Theme, Snacks, Statusline, Bufferline, Alpha
        ├── whichkey.lua    # which-key.nvim
        ├── git.lua         # Gitsigns, Lazygit, Codediff
        ├── debug.lua       # DAP, DAP-UI, Virtual Text
        ├── utils.lua       # Sessions, Flash, Lint, Oil, Trouble, etc.
        └── oil.lua         # File explorer (module)
```

## Key Commands (Cheat Sheet)
| Key | Action |
|-----|--------|
| `<space>` | Press to see ALL keymaps (which-key) |
| `<leader>?` | Open full cheat sheet file |
| `<space><space>` | Find files (snacks picker) |
| `<space>/` | Live grep |
| `<space>,` | Buffers |
| `<space>gg` | Lazygit |
| `<space>e` | Show diagnostics |
| `gd` | Go to definition |
| `gr` | LSP references |
| `K` | LSP hover |
| `-` | Open parent directory (Oil) |

## Languages Supported (Auto)
**Any language** with:
- Treesitter parser → automatic syntax highlighting
- nvim-lspconfig definition → automatic LSP

Default installed: Python, Rust, Go, JavaScript, TypeScript, C/C++, Lua

## External Prerequisites
Auto-install in this config depends on tools outside Neovim:

- `git` for `vim.pack`
- `tree-sitter` CLI for parser installation
- `gcc` or another working C compiler for treesitter parser builds
- network access when Mason or treesitter need to download missing tools

If `tree-sitter` is missing, Neovim will still use bundled or already-installed parsers, but it cannot auto-install new ones.

## How Auto-Detection & Auto-Install Works:

### Step 1: Language Detection
- Neovim automatically detects filetype when you open a file (e.g., `.py` → python, `.go` → go, `.rs` → rust)
- This happens via built-in filetype detection

### Step 2: Treesitter Parser (Syntax Highlighting)
- On first open of a new file type, Treesitter checks if parser exists
- If missing → automatically installs the parser
- This requires the external `tree-sitter` CLI and a C compiler
- Result: Syntax highlighting works immediately

### Step 3: LSP Server (Language Server)
- mason-lspconfig.nvim auto-enables installed servers
- If LSP server not installed → Mason auto-downloads and installs it
- When installation completes → the server is automatically enabled
- Result: Autocomplete, go-to-definition, diagnostics work immediately

### Step 4: Formatter/DAP (Optional)
- mason-tool-installer keeps common formatter tools installed
- conform.nvim auto-formats on save where configured
- DAP keymaps/config are present, but adapter installation is still manual

### Example: Opening a new file type
```
1. You open main.go (first time)
2. Filetype detected as "go"
3. Treesitter: "go" parser not found → installs automatically
4. Mason: "gopls" not installed → downloads and installs
5. LSP: "gopls" enabled for "go" files
6. Result: Full IDE features - syntax highlighting, autocomplete, go-to-definition, diagnostics
```

### What's NOT Needed:
- No manual :TSInstall
- No manual :LspInstall
- Usually no manual configuration per language
- For new languages, just open a file and let Mason/Treesitter try installation

## Testing Commands
```vim
:CheatSheet         -- Open the full cheat sheet file
:checkhealth        -- Full health check
:checkhealth lsp    -- LSP status
:checkhealth which-key
:checkhealth mason  -- Mason status
:Mason              -- Open Mason UI
```

## Files Created
- `/home/akshaj/.config/nvim/init.lua`
- `/home/akshaj/.config/nvim/lua/config/options.lua`
- `/home/akshaj/.config/nvim/lua/config/keymaps.lua`
- `/home/akshaj/.config/nvim/lua/config/autocmds.lua`
- `/home/akshaj/.config/nvim/lua/plugins/lsp.lua`
- `/home/akshaj/.config/nvim/lua/plugins/treesitter.lua`
- `/home/akshaj/.config/nvim/lua/plugins/completion.lua`
- `/home/akshaj/.config/nvim/lua/plugins/whichkey.lua`
- `/home/akshaj/.config/nvim/lua/plugins/ui.lua`
- `/home/akshaj/.config/nvim/lua/plugins/git.lua`
- `/home/akshaj/.config/nvim/lua/plugins/debug.lua`
- `/home/akshaj/.config/nvim/lua/plugins/utils.lua`
- `/home/akshaj/.config/nvim/lua/plugins/oil.lua`
