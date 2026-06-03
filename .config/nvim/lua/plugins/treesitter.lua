local ignored_filetypes = {
  alpha = true, checkhealth = true, help = true,
  lazygit = true, man = true, mason = true, qf = true,
  snacks_notif = true,
}

local group = vim.api.nvim_create_augroup('treesitter', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  callback = function(args)
    local ft = args.match
    if ft == '' or ignored_filetypes[ft] or vim.bo[args.buf].buftype ~= '' then
      return
    end
    local lang = vim.treesitter.language.get_lang(ft)
    if lang then
      pcall(vim.treesitter.start, args.buf, lang)
    end
  end,
})

vim.schedule(function()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local ft = vim.bo[bufnr].filetype
      if ft ~= '' and not ignored_filetypes[ft] and vim.bo[bufnr].buftype == '' then
        local lang = vim.treesitter.language.get_lang(ft)
        if lang then
          pcall(vim.treesitter.start, bufnr, lang)
        end
      end
    end
  end
end)
