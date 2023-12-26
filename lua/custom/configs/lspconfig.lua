local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

local servers = {"pyright"}
local pathValue = os.getenv("PATH")

-- Check if the PATH contains a pattern indicating a Python venv
local isVenvActivated = string.match(pathValue, "/venv/bin") or string.match(pathValue, "\\.venv\\Scripts")

-- Check the result of the match and print accordingly
if isVenvActivated then
  print("Python virtual environment seems to be activated.")
  vim.g.pyright_python_binary = pathValue .. "/python"
else
    print("Python virtual environment is not activated.")
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

