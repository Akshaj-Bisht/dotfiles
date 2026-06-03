-- Autocommands

-- Highlight yanks
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Auto-resize splits on resize
vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('resize-splits', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('remove-trailing-whitespace', { clear = true }),
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- Check if file changed outside vim
vim.api.nvim_create_autocmd({
  'FocusGained',
  'TermClose',
  'VimResume',
}, {
  group = vim.api.nvim_create_augroup('check-time', { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd('checktime')
    end
  end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('last-location', { clear = true }),
  callback = function()
    local exclude = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' }
    local filetype = vim.bo.filetype
    if vim.tbl_contains(exclude, filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Close certain filetypes with q
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close-with-q', { clear = true }),
  pattern = { 'qf', 'help', 'man', 'lspinfo', 'spectre_panel', 'checkhealth', 'mason' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, desc = 'Close window' })
  end,
})

-- Prose-friendly editing
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('prose-files', { clear = true }),
  pattern = { 'gitcommit', 'markdown', 'text' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
