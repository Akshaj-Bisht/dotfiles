local bookmarks_file = vim.fn.stdpath('config') .. '/bookmarks.json'

local function load_bookmarks()
  local ok, data = pcall(vim.fn.readfile, bookmarks_file)
  if ok and data then
    local ok2, parsed = pcall(vim.json.decode, table.concat(data, '\n'))
    if ok2 and type(parsed) == 'table' then
      return parsed
    end
  end
  return {}
end

local function save_bookmarks(bookmarks)
  vim.fn.writefile({ vim.json.encode(bookmarks) }, bookmarks_file)
end

vim.keymap.set('n', '<leader>ba', function()
  local cwd = vim.uv.cwd()
  local bookmarks = load_bookmarks()
  for _, b in ipairs(bookmarks) do
    if b.path == cwd then
      vim.notify('Already bookmarked: ' .. cwd)
      return
    end
  end
  table.insert(bookmarks, { path = cwd, name = vim.fn.fnamemodify(cwd, ':t'), added = os.time() })
  save_bookmarks(bookmarks)
  vim.notify('Bookmarked: ' .. cwd)
end, { desc = 'Bookmark current directory' })

vim.keymap.set('n', '<leader>bd', function()
  local cwd = vim.uv.cwd()
  local bookmarks = load_bookmarks()
  for i, b in ipairs(bookmarks) do
    if b.path == cwd then
      table.remove(bookmarks, i)
      save_bookmarks(bookmarks)
      vim.notify('Removed bookmark: ' .. cwd)
      return
    end
  end
  vim.notify('Current directory is not bookmarked')
end, { desc = 'Remove bookmark' })

vim.keymap.set('n', '<leader>fp', function()
  local bookmarks = load_bookmarks()
  if #bookmarks == 0 then
    vim.notify('No bookmarks yet. Use <leader>ba to bookmark a directory.')
    return
  end

  local ok, err = pcall(function()
    require('snacks').picker.pick({
      source = bookmarks,
      format = 'text',
      prompt = 'Jump to bookmark',
      confirm = function(item)
        if item and item.path then
          vim.cmd('cd ' .. vim.fn.fnameescape(item.path))
          vim.notify('Switched to: ' .. item.name)
        end
      end,
    })
  end)

  if not ok then
    vim.ui.select(bookmarks, {
      prompt = 'Jump to bookmark',
      format_item = function(item) return item.name .. '  (' .. item.path .. ')' end,
    }, function(item)
      if item then
        vim.cmd('cd ' .. vim.fn.fnameescape(item.path))
        vim.notify('Switched to: ' .. item.name)
      end
    end)
  end
end, { desc = 'Jump to bookmarked project' })
