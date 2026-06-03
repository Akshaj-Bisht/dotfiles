-- Set <space> as leader (must happen before other plugins loaded)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable built-in providers/features we don't use to keep startup lean.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

-- Load configuration modules
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Load plugins (they will self-configure)
-- These are loaded after config so they can access vim options
vim.pack.add({
  -- Core dependencies
  'https://github.com/nvim-lua/plenary.nvim', -- needed by codediff
  'https://github.com/L3MON4D3/LuaSnip', -- snippet engine for blink.cmp

  -- LSP + Mason
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/stevearc/conform.nvim',

  -- Completion
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },

  -- Keymap discovery
  'https://github.com/folke/which-key.nvim',

  -- UI enhancements
  'https://github.com/folke/snacks.nvim',
  'https://github.com/goolord/alpha-nvim',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/stevearc/aerial.nvim',
  'https://github.com/akinsho/toggleterm.nvim',

  -- Word highlight
  'https://github.com/RRethy/vim-illuminate',

  -- File explorer
  'https://github.com/stevearc/oil.nvim',

  -- Git
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/esmuellert/codediff.nvim',

  -- Debugging
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/mfussenegger/nvim-dap-python',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/theHamsta/nvim-dap-virtual-text',

  -- Themes
  'https://github.com/folke/tokyonight.nvim',

  -- LSP extras
  'https://github.com/SmiteshP/nvim-navic',

  -- UI
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-tree/nvim-web-devicons',

  -- Utilities
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/mbbill/undotree',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/folke/persistence.nvim',
  'https://github.com/smjonas/inc-rename.nvim',
  'https://github.com/kosayoda/nvim-lightbulb',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
}, { load = true, confirm = false })

local function load(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.schedule(function()
      vim.notify(('Failed to load %s: %s'):format(module, err), vim.log.levels.WARN)
    end)
  end
end

load('plugins.ui')
load('plugins.whichkey')
load('plugins.terminal')

local function startup_directory_arg()
  if vim.fn.argc() == 0 then return nil end
  local arg = vim.fn.argv(0)
  return (arg ~= '' and vim.fn.isdirectory(arg) == 1) and arg or nil
end

local startup_dir = startup_directory_arg()
if startup_dir then
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
      pcall(require('plugins.oil').open, startup_dir)
    end,
  })
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('defer-lsp', { clear = true }),
  once = true,
  callback = function()
    vim.schedule(function() load('plugins.lsp') end)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('defer-treesitter', { clear = true }),
  once = true,
  callback = function()
    vim.schedule(function() load('plugins.treesitter') end)
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = vim.api.nvim_create_augroup('defer-completion', { clear = true }),
  once = true,
  callback = function()
    load('plugins.completion')
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('defer-ui-tools', { clear = true }),
  once = true,
  callback = function()
    vim.schedule(function()
      load('plugins.git')
      load('plugins.debug')
      load('plugins.utils')
      load('plugins.projects')
    end)
  end,
})
