local M = {}

function M:init()
    local autocmds = require("core.autocmds")
    autocmds.load_defaults()
end

return M
