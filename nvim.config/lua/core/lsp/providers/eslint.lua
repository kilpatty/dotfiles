local util = require("lspconfig").util
local default_on_attach = require("core.lsp.config").default_on_attach

local M = {}

function M.on_attach(client, bufnr)
    default_on_attach(client, bufnr)

    client.server_capabilities.documentFormattingProvider = true
end

M.root_dir = util.find_git_ancestor

-- M.root_dir = function(fname)
--     return util.root_pattern("tsconfig.json")(fname) or util.root_pattern(".eslintrc.js", ".git")(fname)
-- end

M.settings = {
    -- codeAction = {
    --     disableRuleComment = {
    --         enable = true,
    --         location = "separateLine",
    --     },
    --     showDocumentation = {
    --         enable = true,
    --     },
    -- },
    -- codeActionOnSave = {
    --     enable = false,
    --     mode = "all",
    -- },
    format = true,
    nodePath = "",
    onIgnoredFiles = "off",
    packageManager = "pnpm",
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    -- workingDirectory = {
    --     mode = "location",
    -- },
}

return M
