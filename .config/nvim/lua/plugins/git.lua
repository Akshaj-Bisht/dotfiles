pcall(function()
  require('gitsigns').setup({
    current_line_blame = false,
    signs = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  })
end)
pcall(require, 'lazygit')

local function git_root()
  local current = vim.api.nvim_buf_get_name(0)
  local start = current ~= '' and vim.fs.dirname(current) or vim.uv.cwd()
  local root = vim.fs.root(start, '.git')
  return root or vim.uv.cwd()
end

local function normalize_remote_url(remote)
  if remote:match('^git@github%.com:') then
    return remote:gsub('^git@github%.com:', 'https://github.com/'):gsub('%.git$', '')
  end
  return remote:gsub('%.git$', '')
end

local function in_git_repo()
  return vim.fs.root(0, '.git') ~= nil
end

local function git_line_history(start_line, end_line)
  start_line, end_line = math.min(start_line, end_line), math.max(start_line, end_line)
  local filepath = vim.fn.expand('%:p')
  local root = git_root()
  local relative = vim.fs.relpath(root, filepath)
  if not relative then
    vim.notify('Current buffer is not inside the git root', vim.log.levels.WARN)
    return
  end
  local range = start_line .. ',' .. end_line .. ':' .. relative
  local command = { 'git', '-C', root, '--no-pager', 'log', '-L', range }
  local output = vim.fn.systemlist(command)
  local command_text = vim.fn.join(vim.tbl_map(vim.fn.shellescape, command), ' ')
  vim.cmd('vnew')
  vim.bo.buftype = 'nofile'
  vim.bo.filetype = 'diff'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.list_extend({ command_text, '' }, output))
  vim.bo.modified = false
end

vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'Open Lazygit' })

vim.keymap.set('n', '<leader>gb', function()
  if not in_git_repo() then
    vim.notify('Current buffer is not inside a git repository', vim.log.levels.WARN)
    return
  end
  local root = git_root()
  local remote = vim.fn.systemlist({ 'git', '-C', root, 'remote', 'get-url', 'origin' })[1]
  if remote and remote ~= '' then
    vim.ui.open(normalize_remote_url(remote))
  else
    vim.notify('No git remote named origin found', vim.log.levels.WARN)
  end
end, { desc = 'Open git remote' })

vim.keymap.set('n', '<leader>gl', function()
  git_line_history(vim.fn.line('.'), vim.fn.line('.'))
end, { desc = 'Git line history' })

vim.keymap.set('v', '<leader>gl', function()
  git_line_history(vim.fn.line('v'), vim.fn.line('.'))
end, { desc = 'Git line history (visual)' })

local function gitsigns_cmd(name)
  return function()
    pcall(function() require('gitsigns')[name]() end)
  end
end

vim.keymap.set('n', ']h', gitsigns_cmd('next_hunk'), { desc = 'Next git hunk' })
vim.keymap.set('n', '[h', gitsigns_cmd('prev_hunk'), { desc = 'Previous git hunk' })
vim.keymap.set('n', '<leader>gp', gitsigns_cmd('preview_hunk'), { desc = 'Preview git hunk' })
vim.keymap.set('n', '<leader>gs', gitsigns_cmd('stage_hunk'), { desc = 'Stage git hunk' })
vim.keymap.set('n', '<leader>gr', gitsigns_cmd('reset_hunk'), { desc = 'Reset git hunk' })
vim.keymap.set('n', '<leader>ru', '<cmd>CodeDiff<cr>', { desc = 'Code diff not staged' })
vim.keymap.set('n', '<leader>rm', '<cmd>CodeDiff main<cr>', { desc = 'Code diff main' })
vim.keymap.set('n', '<leader>rh', '<cmd>CodeDiff HEAD~1<cr>', { desc = 'Code diff previous' })
