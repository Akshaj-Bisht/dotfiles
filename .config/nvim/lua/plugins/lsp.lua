-- LSP Configuration (Native Neovim 0.12, optimized for responsiveness)

local conform = require('conform')
local blink_ok, blink = pcall(require, 'blink.cmp')

local configured_servers = {
  'bashls',
  'clangd',
  'gopls',
  'jsonls',
  'lua_ls',
  'marksman',
  'pyright',
  'rust_analyzer',
  'ts_ls',
  'taplo',
  'yamlls',
}

local preferred_servers = {
  bash = 'bashls',
  c = 'clangd',
  cpp = 'clangd',
  go = 'gopls',
  javascript = 'ts_ls',
  javascriptreact = 'ts_ls',
  json = 'jsonls',
  lua = 'lua_ls',
  markdown = 'marksman',
  python = 'pyright',
  rust = 'rust_analyzer',
  sh = 'bashls',
  toml = 'taplo',
  typescript = 'ts_ls',
  typescriptreact = 'ts_ls',
  yaml = 'yamlls',
}

conform.setup({
  formatters_by_ft = {
    bash = { 'shfmt' },
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    json = { 'prettier' },
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'ruff_format' },
    rust = { 'rustfmt' },
    sh = { 'shfmt' },
    toml = { 'taplo' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    yaml = { 'prettier' },
  },
  format_on_save = {
    lsp_format = 'fallback',
    timeout_ms = 1000,
  },
})

local document_highlight = vim.api.nvim_create_augroup('lsp-document-highlight', { clear = true })

local function on_attach(client, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'References' }))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Implementation' }))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover' }))
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code actions' }))
  vim.keymap.set('n', '<leader>cf', function()
    conform.format({ async = true, lsp_format = 'fallback', bufnr = bufnr })
  end, vim.tbl_extend('force', opts, { desc = 'Format buffer' }))
  vim.keymap.set('n', '<leader>cs', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature help' }))
  vim.keymap.set('n', '<leader>cS', function()
    vim.lsp.buf.workspace_symbol(vim.fn.input('Workspace symbol: '))
  end, vim.tbl_extend('force', opts, { desc = 'Workspace symbols' }))
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename' }))
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'Show diagnostics' }))
  vim.keymap.set('n', '<leader>xl', vim.diagnostic.setloclist, vim.tbl_extend('force', opts, { desc = 'Diagnostics loclist' }))
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    -- Disabled document highlight to reduce CPU load (runs on CursorHold)
  end

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
    local navic_ok, navic = pcall(require, 'nvim-navic')
    if navic_ok and not vim.b[bufnr].navic_attached then
      navic.attach(client, bufnr)
      vim.b[bufnr].navic_attached = true
      vim.opt_local.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end
  end

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
    vim.lsp.codelens.refresh({ bufnr = bufnr })
  end
end

local capabilities = blink_ok and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

vim.lsp.config('*', {
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.config('pyright', {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        typeCheckingMode = 'basic',
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
})

vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
    },
  },
})

vim.lsp.config('ts_ls', {})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      runtime = { version = 'LuaJIT' },
      telemetry = { enable = false },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
    },
  },
})

vim.lsp.config('bashls', {})
vim.lsp.config('jsonls', {})
vim.lsp.config('marksman', {})
vim.lsp.config('taplo', {})
vim.lsp.config('yamlls', {})
vim.lsp.config('clangd', {})

vim.lsp.enable(configured_servers)

local mason_loaded = false
local pending_server_installs = {}

local function mason_setup()
  local mason_ok, mason = pcall(require, 'mason')
  local mlsp_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
  if not (mason_ok and mlsp_ok) then
    return nil
  end

  if not mason_loaded then
    mason.setup({
      ui = {
        border = 'rounded',
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
      log_level = vim.log.levels.INFO,
    })
    mason_lspconfig.setup({
      ensure_installed = configured_servers,
      automatic_enable = true,
    })

    local mt_ok, mt = pcall(require, 'mason-tool-installer')
    if mt_ok then
      mt.setup({
        ensure_installed = {
          'eslint_d',
          'markdownlint',
          'prettier',
          'ruff',
          'selene',
          'shellcheck',
          'shfmt',
          'stylua',
          'yamllint',
        },
        run_on_start = true,
        start_delay = 3000,
      })
    end

    mason_loaded = true
  end

  return mason_lspconfig
end

local function ensure_server_for_filetype(filetype)
  if filetype == '' or #vim.api.nvim_list_uis() == 0 then
    return
  end

  vim.defer_fn(function()
    local mason_lspconfig = mason_setup()
    if not mason_lspconfig then
      return
    end

    local server = preferred_servers[filetype]
    if not server or pending_server_installs[server] then
      return
    end

    local mapping_ok, mapping = pcall(require, 'mason-lspconfig.mappings.server')
    local registry_ok, registry = pcall(require, 'mason-registry')
    if not (mapping_ok and registry_ok) then
      return
    end

    local package_name = mapping.lspconfig_to_package[server]
    if not package_name or not registry.has_package(package_name) then
      return
    end

    local package = registry.get_package(package_name)
    if package:is_installed() then
      return
    end

    pending_server_installs[server] = true
    vim.notify(('Installing %s for %s via Mason'):format(server, filetype), vim.log.levels.INFO)
    package:once('install:success', function()
      pending_server_installs[server] = nil
      vim.schedule(function()
        vim.notify(('Installed %s'):format(server), vim.log.levels.INFO)
        vim.lsp.enable(server)
      end)
    end)
    package:once('install:failed', function()
      pending_server_installs[server] = nil
      vim.schedule(function()
        vim.notify(('Failed to install %s'):format(server), vim.log.levels.WARN)
      end)
    end)
    package:install()
  end, 150)
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('background-lsp-installer', { clear = true }),
  callback = function(args)
    ensure_server_for_filetype(args.match)
  end,
})

vim.schedule(function()
  mason_setup()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      ensure_server_for_filetype(vim.bo[bufnr].filetype)
    end
  end
end)
