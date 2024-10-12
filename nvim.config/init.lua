local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
    impatient.enable_profile()
end

require("compiled")
require("options")
require("plugins")
require("config"):init()
require("core.lsp").setup()
require("core.bindings")

--[[ @todo review if this is the best place for it.  ]]
-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
