-- Key mappings

local cheatsheet = vim.fn.stdpath('config') .. '/CHEATSHEET.md'

local function open_cheatsheet()
  vim.cmd('edit ' .. vim.fn.fnameescape(cheatsheet))
end

vim.api.nvim_create_user_command('CheatSheet', open_cheatsheet, { desc = 'Open Neovim cheat sheet' })
vim.api.nvim_create_user_command('Cheatsheet', open_cheatsheet, { desc = 'Open Neovim cheat sheet' })
vim.keymap.set('n', '<leader>?', open_cheatsheet, { desc = 'Open cheat sheet' })

-- Copy path shortcuts
vim.keymap.set('n', '<leader>cp', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end, { desc = 'Copy absolute path' })

vim.keymap.set('n', '<leader>cr', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end, { desc = 'Copy relative path' })

-- Show diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics' })

-- Easily move between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Resize windows
vim.keymap.set('n', '<leader>wh', '<C-w>5<', { desc = 'Resize window left' })
vim.keymap.set('n', '<leader>wl', '<C-w>5>', { desc = 'Resize window right' })
vim.keymap.set('n', '<leader>wj', '<C-w>5+', { desc = 'Resize window down' })
vim.keymap.set('n', '<leader>wk', '<C-w>5-', { desc = 'Resize window up' })

-- Window management
vim.keymap.set('n', '<leader>wv', ':vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>ws', ':split<cr>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>wq', '<C-w>q', { desc = 'Close window' })
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Equalize windows' })
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>Q', ':qa!<cr>', { desc = 'Quit all without saving' })

-- Better indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- Move text up/down
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move visual selection down' })
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move visual selection up' })

-- Keep cursor centered
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines (keep cursor)' })

-- Clear highlights
vim.keymap.set('n', '<leader>h', ':nohlsearch<cr>', { desc = 'Clear search highlights' })

-- Quick escape from insert mode
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Terminal keymaps for toggleterm are in plugins/terminal.lua

-- Buffer navigation
vim.keymap.set('n', '[b', ':bprevious<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bb', '<C-^>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<cr>', { desc = 'Delete buffer' })

-- Quickfix
vim.keymap.set('n', '<leader>qo', ':copen<cr>', { desc = 'Open quickfix' })
vim.keymap.set('n', '<leader>qc', ':cclose<cr>', { desc = 'Close quickfix' })
vim.keymap.set('n', '<leader>qq', ':q<cr>', { desc = 'Quit' })
vim.keymap.set('n', ']q', ':cnext<cr>', { desc = 'Next quickfix item' })
vim.keymap.set('n', '[q', ':cprevious<cr>', { desc = 'Previous quickfix item' })

-- Note: LSP keymaps are set in lua/plugins/lsp.lua on LSP attach
-- which-key keymaps are in lua/plugins/whichkey.lua
