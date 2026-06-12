local oil = require('plugins.oil')

pcall(function() require('trouble').setup({}) end)
pcall(function() require('todo-comments').setup({}) end)
pcall(function() require('nvim-autopairs').setup({}) end)
pcall(function()
  require('Comment').setup({
    toggler = {
      line = 'gcc',
      block = 'gbc',
    },
    opleader = {
      line = 'gc',
      block = 'gb',
    },
  })
end)
pcall(function() require('flash').setup({}) end)
pcall(function()
  require('render-markdown').setup({ html = { enabled = false }, latex = { enabled = false } })
end)
pcall(function()
  local lint = require('lint')
  lint.linters_by_ft = {
    javascript = { 'eslint_d' },
    javascriptreact = { 'eslint_d' },
    lua = { 'selene' },
    markdown = { 'markdownlint' },
    python = { 'ruff' },
    sh = { 'shellcheck' },
    typescript = { 'eslint_d' },
    typescriptreact = { 'eslint_d' },
    yaml = { 'yamllint' },
  }
  vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('lint-on-change', { clear = true }),
    callback = function() lint.try_lint() end,
  })
end)
pcall(function()
  require('persistence').setup({
    dir = vim.fn.stdpath('state') .. '/sessions/',
    need = 1,
    branch = true,
  })
end)
pcall(function()
  require('fidget').setup({ notification = { window = { winblend = 0 } } })
end)
pcall(function()
  require('nvim-lightbulb').setup({
    autocmd = { enabled = true },
    sign = { enabled = true, text = '' },
    virtual_text = { enabled = false },
  })
end)
pcall(function() require('inc_rename').setup({}) end)
pcall(function()
  local ok, aerial = pcall(require, 'aerial')
  if ok then aerial.setup({}) end
end)

local function picker(name)
  return function()
    pcall(require('snacks').picker[name])
  end
end

vim.keymap.set('n', '<leader><leader>', picker('files'), { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', picker('grep'), { desc = 'Live grep' })
vim.keymap.set('n', '<leader>.', picker('recent'), { desc = 'Recent files' })
vim.keymap.set('n', '<leader>;', picker('resume'), { desc = 'Resume search' })
vim.keymap.set('n', '<leader>,', picker('buffers'), { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', picker('help'), { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fk', picker('keymaps'), { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>fc', picker('commands'), { desc = 'Commands' })

vim.keymap.set('n', '-', function() oil.open() end, { desc = 'Open parent directory' })
vim.keymap.set('n', '<leader>o', function() oil.open() end, { desc = 'Open file explorer' })
vim.keymap.set('n', '<leader>fe', function() oil.open() end, { desc = 'Open file explorer' })
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  pcall(function() require('flash').jump() end)
end, { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  pcall(function() require('flash').treesitter() end)
end, { desc = 'Flash treesitter' })
vim.keymap.set('n', '<leader>fg', function()
  if not vim.fs.root(0, '.git') then
    vim.notify('Not inside a git repository', vim.log.levels.WARN)
    return
  end
  pcall(function() require('snacks').picker.git_files() end)
end, { desc = 'Git files' })
vim.keymap.set('n', '<leader>sd', picker('diagnostics'), { desc = 'Search diagnostics' })

pcall(require, 'illuminate')

vim.keymap.set('n', '<leader>u', '<cmd>UndotreeShow<cr>', { desc = 'Undo tree' })
vim.keymap.set('n', '<leader>M', '<cmd>Mason<cr>', { desc = 'Mason' })

vim.keymap.set('n', ']t', function()
  pcall(function() require('todo-comments').jump_next() end)
end, { desc = 'Next TODO comment' })
vim.keymap.set('n', '[t', function()
  pcall(function() require('todo-comments').jump_prev() end)
end, { desc = 'Previous TODO comment' })

vim.keymap.set('n', '<leader>xx', function()
  vim.cmd('Trouble diagnostics toggle')
end, { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xX', function()
  vim.cmd('Trouble diagnostics toggle filter.buf=0')
end, { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>cs', function()
  vim.cmd('Trouble symbols toggle')
end, { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>xq', function()
  vim.cmd('Trouble qflist toggle')
end, { desc = 'Quickfix list' })
vim.keymap.set('n', '<leader>xs', function()
  vim.cmd('Trouble symbols toggle focus=false')
end, { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>xt', function()
  vim.cmd('Trouble todo toggle')
end, { desc = 'TODO comments' })

vim.keymap.set('n', '<leader>v', function()
  pcall(vim.cmd, 'AerialToggle!')
end, { desc = 'Toggle outline [V]iew' })

vim.keymap.set('n', '<leader>Sr', function()
  pcall(function() require('persistence').load() end)
end, { desc = 'Restore session' })
vim.keymap.set('n', '<leader>Sl', function()
  pcall(function() require('persistence').load({ last = true }) end)
end, { desc = 'Restore last session' })
vim.keymap.set('n', '<leader>Ss', function()
  pcall(function() require('persistence').save() end)
end, { desc = 'Save session' })
vim.keymap.set('n', '<leader>Sd', function()
  pcall(function() require('persistence').stop() end)
end, { desc = 'Stop session save' })
vim.api.nvim_create_user_command('WorkspaceRestore', function()
  pcall(function() require('persistence').load() end)
end, { desc = 'Restore workspace session' })

vim.keymap.set('n', '<leader>rr', function()
  return ':IncRename ' .. vim.fn.expand('<cword>')
end, { desc = 'Incremental rename', expr = true })
