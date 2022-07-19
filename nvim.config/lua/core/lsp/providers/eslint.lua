local util = require("lspconfig").util

local M = {}

-- M.root_dir = function(fname)
--     return util.root_pattern("tsconfig.json")(fname) or util.root_pattern(".eslintrc.js", ".git")(fname)
-- end

-- M.settings = {
--     codeAction = {
--         disableRuleComment = {
--             enable = true,
--             location = "separateLine",
--         },
--         showDocumentation = {
--             enable = true,
--         },
--     },
--     -- codeActionOnSave = {
--     --     enable = false,
--     --     mode = "all",
--     -- },
--     format = true,
--     nodePath = "",
--     onIgnoredFiles = "off",
--     -- packageManager = "npm",
--     quiet = false,
--     rulesCustomizations = {},
--     run = "onType",
--     useESLintClass = false,
--     validate = "on",
--     -- workingDirectory = {
--     --     mode = "location",
--     -- },
-- }

return M
