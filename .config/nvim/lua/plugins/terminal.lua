local ok, toggleterm = pcall(require, 'toggleterm')
if not ok then return end

toggleterm.setup{
  size = 15,
  open_mapping = false,
  direction = 'float',
  shade_terminals = true,
  float_opts = {
    border = 'rounded',
  },
}

-- Terminal keymaps inside terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('toggleterm-keymaps', { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', vim.tbl_extend('force', opts, { desc = 'Exit terminal mode' }))
    -- jk closes the floating terminal
    vim.keymap.set('t', 'jk', '<C-\\><C-n><cmd>close<cr>', vim.tbl_extend('force', opts, { desc = 'Exit and close terminal' }))
    vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', vim.tbl_extend('force', opts, { desc = 'Focus left window' }))
    vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', vim.tbl_extend('force', opts, { desc = 'Focus lower window' }))
    vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', vim.tbl_extend('force', opts, { desc = 'Focus upper window' }))
    vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', vim.tbl_extend('force', opts, { desc = 'Focus right window' }))
    vim.keymap.set('t', '<C-q>', '<C-\\><C-n><cmd>close<cr>', vim.tbl_extend('force', opts, { desc = 'Close terminal' }))
  end,
})

-- Terminal mode cycling: float → horizontal → vertical
local current_mode_idx = 1
local mode_directions = { 'float', 'horizontal', 'vertical' }

local function get_context_dir()
  if vim.bo.filetype == 'oil' then
    local ok, d = pcall(require('oil').get_current_dir)
    if ok and d then return d end
  end
  local fdir = vim.fn.expand('%:p:h')
  if fdir ~= '' and vim.fn.isdirectory(fdir) == 1 then return fdir end
  return vim.uv.cwd()
end

local function toggle_terminal(direction)
  local Terminal = require('toggleterm.terminal').Terminal
  local term = Terminal:new({ direction = direction, hidden = true, dir = get_context_dir() })
  term:toggle()
end

vim.keymap.set('n', '<leader>tt', function()
  local dir = mode_directions[current_mode_idx]
  toggle_terminal(dir)
end, { desc = 'Toggle terminal' })

vim.keymap.set('n', '<leader>tf', function()
  toggle_terminal('float')
end, { desc = 'Floating terminal' })

vim.keymap.set('n', '<leader>th', function()
  toggle_terminal('horizontal')
end, { desc = 'Horizontal terminal' })

vim.keymap.set('n', '<leader>tv', function()
  toggle_terminal('vertical')
end, { desc = 'Vertical terminal' })

vim.keymap.set('n', '<leader>tm', function()
  current_mode_idx = (current_mode_idx % #mode_directions) + 1
  local dir = mode_directions[current_mode_idx]
  vim.notify(('Terminal mode: %s'):format(dir))
end, { desc = 'Cycle terminal mode' })
