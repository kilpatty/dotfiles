local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
    impatient.enable_profile()
end

require("compiled")
require("options")
require("plugins")
require("core.utils")
-- require("core.lsp")
require("core.lsp").setup()
require("core.bindings")
