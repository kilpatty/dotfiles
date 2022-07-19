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
