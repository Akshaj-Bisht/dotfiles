-- Vim options

-- Relative line numbers
vim.o.relativenumber = true
vim.o.number = true

-- Case-insensitive searching unless we use capital letters
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sync vim and system clipboards
-- Check if in SSH: if so, use a different provider
if os.getenv('SSH_CONNECTION') then
  vim.o.clipboard = ''  -- Will try to auto-detect
else
  vim.o.clipboard = 'unnamedplus'  -- Use system clipboard
end

-- Raise dialog if you close unsaved buffer (prevent mistakes)
vim.o.confirm = true

-- Disable swap files to prevent annoying errors
vim.opt.swapfile = false

-- Snappy escape (timeoutlen for terminal keycodes, increased from 1 for jk sequences)
vim.o.ttimeoutlen = 100
vim.o.timeoutlen = 500  -- Timeout for mappings (e.g., jk sequence in insert/terminal mode)

-- Sign column for LSP warnings
vim.o.signcolumn = 'yes'

-- Better UI
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.o.cursorline = true
vim.o.cursorlineopt = 'number,line'
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.wrap = false
vim.o.winborder = 'rounded'

-- Search
vim.o.hlsearch = true
vim.o.incsearch = true

-- Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.smartindent = true

-- Split windows
vim.o.splitright = true
vim.o.splitbelow = true

-- Enable mouse
vim.o.mouse = 'a'

-- Faster grep
vim.o.grepprg = 'rg --vimgrep'

-- Terminal
vim.o.shell = vim.fn.executable('zsh') and 'zsh' or 'bash'

-- Disable mode show (we have statusline)
vim.o.showmode = false

-- Show matching brackets
vim.o.showmatch = true

-- Persistent undo
vim.o.undofile = true
vim.o.undolevels = 10000

-- Better backup
vim.o.backup = false
vim.o.writebackup = false

-- Enable hidden buffers
vim.o.hidden = true
vim.o.inccommand = 'split'
vim.o.splitkeep = 'screen'

-- Faster updates
vim.o.updatetime = 300

-- Complete options
vim.o.completeopt = 'menu,menuone,noselect'

-- Diagnostic config
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = { source = 'if_many' },
  virtual_text = {
    spacing = 2,
    source = 'if_many',
  },
  underline = true,
  jump = {},
})
