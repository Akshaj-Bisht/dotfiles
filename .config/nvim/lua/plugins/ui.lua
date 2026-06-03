-- UI Configuration (Theme, Dashboard, Bufferline, Statusline, and Extras)
vim.g.have_nerd_font = true

-- Set theme (tokyonight)
local tokyo_ok, tokyo = pcall(require, 'tokyonight')
if tokyo_ok then
  tokyo.setup({
    style = 'night',
    transparent = false,
    styles = {
      comments = { italic = true },
    },
  })
end
vim.cmd('colorscheme tokyonight')

-- Alpha-nvim startup screen
local alpha_ok, alpha = pcall(require, 'alpha')
if alpha_ok then
  local startify = require('alpha.themes.startify')
  startify.file_icons.provider = 'devicons'
  alpha.setup(startify.config)
end

-- Bufferline
local bufferline_ok, bufferline = pcall(require, 'bufferline')
if bufferline_ok then
  bufferline.setup {
    options = {
      mode = 'buffers',
      diagnostics = 'nvim_lsp',
      offsets = { { filetype = 'snacks_layout_box', text = 'Explorer' } },
      separator_style = 'slant',
      always_show_bufferline = true,
      enforce_regular_tabs = true,
    },
    highlights = {
      buffer_selected = { bold = true, italic = false },
      indicator_selected = { bold = true },
    },
  }
end

-- Disable tabline in alpha
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'alpha',
  callback = function()
    vim.opt.showtabline = 0
  end,
})

vim.api.nvim_create_autocmd('BufLeave', {
  pattern = 'alpha',
  callback = function()
    vim.opt.showtabline = 2
  end,
})

-- Snacks.nvim Configuration (UI enhancements)
local snacks = require('snacks')

local mini_ok, mini_icons = pcall(require, 'mini.icons')
if mini_ok then
  mini_icons.setup({})
end

-- Additional mini plugins
local mini_ai_ok, mini_ai = pcall(require, 'mini.ai')
if mini_ai_ok then
  mini_ai.setup { n_lines = 500 }
end

local mini_surround_ok, mini_surround = pcall(require, 'mini.surround')
if mini_surround_ok then
  mini_surround.setup()
end

snacks.setup({
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  dashboard = {
    enabled = false,
  },
  scroll = {
    enabled = true,
  },
  scope = {
    enabled = true,
    ft = { 'gitcommit', 'diff' },
  },
  indent = {
    enabled = true,
    only_scopes = {
      'lua',
      'python',
      'javascript',
      'typescript',
      'go',
      'rust',
      'c',
      'cpp',
    },
  },
  input = {
    enabled = true,
  },
  picker = {
    enabled = true,
    files = {
      excluded = { 'node_modules', '.git', 'dist', 'build' },
    },
  },
  statuscolumn = {
    enabled = false,
  },
  buffer = {
    enabled = true,
  },
  dim = {
    enabled = false,
  },
  zen = {
    enabled = true,
  },
})

-- Override vim.notify to send errors to cmdline (not floating window)
local orig_notify = vim.notify
vim.notify = function(msg, log_level, opts)
  msg = type(msg) == 'string' and msg or vim.inspect(msg)
  if log_level == vim.log.levels.ERROR then
    vim.api.nvim_echo({ { '[ERROR] ', 'ErrorMsg' }, { msg, '' } }, true, {})
    return
  end
  orig_notify(msg, log_level, opts)
end

-- Fast, polished statusline with mode-specific colors
vim.cmd([[
  highlight StatusN  guifg=#1e1e2e guibg=#89b4fa gui=bold
  highlight StatusI  guifg=#1e1e2e guibg=#a6e3a1 gui=bold
  highlight StatusV  guifg=#1e1e2e guibg=#fab387 gui=bold
  highlight StatusR  guifg=#1e1e2e guibg=#f38ba8 gui=bold
  highlight StatusC  guifg=#1e1e2e guibg=#cba6f7 gui=bold
  highlight StatusT  guifg=#1e1e2e guibg=#94e2d5 gui=bold
  highlight StatusS  guifg=#1e1e2e guibg=#f9e2af gui=bold
]])

local mode_data = {
  n = { hl = 'StatusN', label = ' NORMAL ' },
  i = { hl = 'StatusI', label = ' INSERT ' },
  v = { hl = 'StatusV', label = ' VISUAL ' },
  V = { hl = 'StatusV', label = ' V·LINE ' },
  ['\22'] = { hl = 'StatusV', label = ' V·BLOCK ' },
  c = { hl = 'StatusC', label = ' COMMAND ' },
  t = { hl = 'StatusT', label = ' TERMINAL ' },
  R = { hl = 'StatusR', label = ' REPLACE ' },
  s = { hl = 'StatusS', label = ' SELECT ' },
  S = { hl = 'StatusS', label = ' S·LINE ' },
  ['\19'] = { hl = 'StatusS', label = ' S·BLOCK ' },
}

local cached_mode_raw = 'n'

vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('statusline-mode', { clear = true }),
  callback = function()
    cached_mode_raw = vim.api.nvim_get_mode().mode
  end,
})

local cached_icon = ''
local cached_git_branch = ''

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('statusline-cache', { clear = true }),
  callback = function()
    local ok, icons = pcall(require, 'mini.icons')
    if ok and icons.get_icon then
      local icon = icons.get_icon(vim.fn.expand('%:t'), vim.bo.filetype)
      local hl = icons.get_highlight and icons.get_highlight(vim.fn.expand('%:t'), vim.bo.filetype) or 'Normal'
      cached_icon = icon and ('%#' .. hl .. '#' .. icon .. '%* ') or ''
    else
      cached_icon = ''
    end
    local root = vim.fs.root(0, '.git')
    if root then
      local head = vim.fn.systemlist({ 'git', '-C', root, 'branch', '--show-current' })[1]
      cached_git_branch = head or ''
    else
      cached_git_branch = ''
    end
  end,
})

vim.api.nvim_create_autocmd('DirChanged', {
  group = vim.api.nvim_create_augroup('statusline-dir', { clear = true }),
  callback = function()
    local root = vim.fs.root(0, '.git')
    if root then
      local head = vim.fn.systemlist({ 'git', '-C', root, 'branch', '--show-current' })[1]
      cached_git_branch = head or ''
    else
      cached_git_branch = ''
    end
  end,
})

_G._stl = function()
  local raw = cached_mode_raw
  local data = mode_data[raw]
  local hl = data and data.hl or 'StatusLine'
  local label = data and data.label or (' ' .. raw:upper() .. ' ')
  local fname = vim.fn.expand('%:t')
  if fname == '' then fname = '[No Name]' end
  local parts = {}
  if vim.bo.modified then table.insert(parts, '+') end
  if vim.bo.readonly then table.insert(parts, 'RO') end
  local mod_ro = #parts > 0 and ' [' .. table.concat(parts, ' ') .. ']' or ''
  local ft = vim.bo.filetype
  local ft_str = ft ~= '' and ' ' .. ft or ''
  local git = cached_git_branch ~= '' and '  ' .. cached_git_branch or ''
  local ctx_dir
  if vim.bo.filetype == 'oil' then
    local ok, d = pcall(require('oil').get_current_dir)
    ctx_dir = ok and d or nil
  end
  if not ctx_dir then
    local fdir = vim.fn.expand('%:p:h')
    ctx_dir = (fdir ~= '' and vim.fn.isdirectory(fdir) == 1) and fdir or vim.uv.cwd()
  end
  local dir = vim.fn.fnamemodify(ctx_dir, ':~')
  if dir == '~' then dir = '' else dir = ' ' .. dir end
  local left = '%#' .. hl .. '#' .. label .. '%* ' .. cached_icon .. fname .. mod_ro
  local right = git .. dir .. ft_str .. ' %l:%-2c %p%%'
  return left .. '%=' .. right
end

vim.o.statusline = '%{%v:lua._stl()%}'
vim.o.laststatus = 3

vim.keymap.set('n', '<leader>z', function()
  require('snacks').zen()
end, { desc = 'Zen mode' })
