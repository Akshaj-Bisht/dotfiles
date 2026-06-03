local M = {}

local oil_loaded = false

function M.setup()
  if oil_loaded then
    return true
  end

  local ok, oil = pcall(require, 'oil')
  if not ok then
    return false
  end

  oil.setup({
    columns = { 'icon' },
    keymaps = {
      ['<C-h>'] = false,
      ['<C-j>'] = false,
      ['<C-k>'] = false,
      ['<C-l>'] = false,
      ['<M-h>'] = 'actions.select_split',
      ['q'] = 'actions.close',
      ['<Esc>'] = 'actions.close',
    },
    view_options = { show_hidden = true },
  })

  oil_loaded = true
  return true
end

function M.open(dir)
  if M.setup() then
    require('oil').open(dir)
  end
end

return M
