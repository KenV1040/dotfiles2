local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

-- Defining a list of lsps to setup. If you have a specific setup for that lsp, define a separate one
local servers = {"pyright"}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- Add the auto-command and the function for detecting venv and setting the Python path
vim.cmd [[
  autocmd BufEnter,DirChanged * lua detect_venv_and_set_python_path()
]]

function detect_venv_and_set_python_path()
  local current_dir = vim.fn.getcwd()
  local venv_path = current_dir .. '/venv/bin/python'  -- Adjust the path based on your structure
  local is_venv_present = vim.fn.isdirectory(current_dir .. '/venv') == 1

  if is_venv_present then
    local clients = vim.lsp.get_active_clients({
      bufnr = 0,
      name = 'pyright',
    })

    for _, client in ipairs(clients) do
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, { python = { pythonPath = venv_path } })
      vim.lsp.buf_notify(0, 'workspace/didChangeConfiguration', { settings = client.config.settings })
    end
  end
end
