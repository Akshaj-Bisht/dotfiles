 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#131314',
    base01 = '#201f21',
    base02 = '#2a2a2b',
    base03 = '#919097',
    base04 = '#c8c5cd',
    base05 = '#e5e1e3',
    base06 = '#e5e1e3',
    base07 = '#e5e1e3',
    base08 = '#ffb4ab',
    base09 = '#dcbecf',
    base0A = '#c7c5cf',
    base0B = '#c5c4db',
    base0C = '#dcbecf',
    base0D = '#c5c4db',
    base0E = '#c7c5cf',
    base0F = '#93000a',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e5e1e3',          bg = '#131314' })
  hi('TelescopeBorder',         { fg = '#919097',             bg = '#131314' })
  hi('TelescopePromptNormal',   { fg = '#e5e1e3',          bg = '#131314' })
  hi('TelescopePromptBorder',   { fg = '#919097',             bg = '#131314' })
  hi('TelescopePromptPrefix',   { fg = '#c5c4db',             bg = '#131314' })
  hi('TelescopePromptCounter',  { fg = '#c8c5cd',  bg = '#131314' })
  hi('TelescopePromptTitle',    { fg = '#131314',             bg = '#c5c4db' })
  hi('TelescopePreviewTitle',   { fg = '#131314',             bg = '#c7c5cf' })
  hi('TelescopeResultsTitle',   { fg = '#131314',             bg = '#dcbecf' })
  hi('TelescopeSelection',      { fg = '#e5e1e3',          bg = '#2a2a2b' })
  hi('TelescopeSelectionCaret', { fg = '#c5c4db',             bg = '#2a2a2b' })
  hi('TelescopeMatching',       { fg = '#c5c4db',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
