pcall(function()
  local dap = require('dap')
  local dap_python_ok, dap_python = pcall(require, 'dap-python')
  if dap_python_ok then
    dap_python.setup('python3')
  end
  dap.configurations.python = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      pythonPath = function()
        local venv = vim.fs.find('.venv', { upward = true })[1]
        return venv and (venv .. '/bin/python') or 'python3'
      end,
    },
  }
end)

pcall(function()
  local dapui = require('dapui')
  dapui.setup({
    layouts = {
      {
        elements = {
          { id = 'scopes', size = 0.40 },
          { id = 'breakpoints', size = 0.20 },
          { id = 'stacks', size = 0.20 },
          { id = 'watches', size = 0.20 },
        },
        position = 'left',
        size = 48,
      },
      {
        elements = {
          { id = 'repl', size = 0.55 },
          { id = 'console', size = 0.45 },
        },
        position = 'bottom',
        size = 12,
      },
    },
  })
  pcall(function() require('nvim-dap-virtual-text').setup({}) end)

  local dap = require('dap')
  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
  end
end)

local function dap_cmd(name)
  return function()
    pcall(function() require('dap')[name]() end)
  end
end

vim.keymap.set('n', '<leader>b', dap_cmd('toggle_breakpoint'), { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>dc', dap_cmd('continue'), { desc = 'Debug continue' })
vim.keymap.set('n', '<leader>dq', dap_cmd('terminate'), { desc = 'Debug terminate' })
vim.keymap.set('n', '<leader>dr', function()
  pcall(function() require('dap').repl.open() end)
end, { desc = 'Debug open REPL' })
vim.keymap.set('n', '<leader>dl', dap_cmd('run_last'), { desc = 'Debug run last' })
vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
  pcall(function()
    local widgets = require('dap.ui.widgets')
    widgets.hover()
  end)
end, { desc = 'Debug hover' })
vim.keymap.set('n', '<leader>dj', dap_cmd('step_over'), { desc = 'Debug step over' })
vim.keymap.set('n', '<leader>di', dap_cmd('step_into'), { desc = 'Debug step into' })
vim.keymap.set('n', '<leader>do', dap_cmd('step_out'), { desc = 'Debug step out' })
vim.keymap.set('n', '<leader>db', function()
  pcall(function() require('dapui').toggle({}) end)
end, { desc = 'Debug UI toggle' })
vim.keymap.set('n', '<leader>de', function()
  pcall(function() require('dapui').eval() end)
end, { desc = 'Debug evaluate' })
