local M = {}

-- local config = require("core.lsp.config")

-- local Log = require "lvim.core.log"

-- @todo figure out how to handle the errors in our LSP logs with LUA no handler for workspace diagnostic update something like that
-- @todo BUG: if I start a new line with O or o, and then instantly tab, I get an error from unpack.
function M.setup()
    local status_ok, null_ls = pcall(require, "null-ls")
    if not status_ok then
        -- Log:error "Missing null-ls dependency"
        return
    end

    -- local default_opts = config.default_opts()
    --
    -- local opts = {
    --     on_init = require("core.lsp").common_on_init,
    -- }
    --
    -- default_opts = vim.tbl_deep_extend("force", default_opts, opts)
    -- local default_opts = require("core.lsp").get_common_opts()
    -- null_ls.setup(vim.tbl_deep_extend("force", default_opts, {
    -- 	default = true,
    -- 	sources = {
    -- 		null_ls.builtins.formatting.stylua,
    -- 		null_ls.builtins.formatting.prettier,
    -- 	},
    -- }))

    null_ls.setup({
        default = true,
        sources = {
            --@todo luacheck https://github.com/mpeterv/luacheck for linter
            null_ls.builtins.formatting.stylua,
            -- null_ls.builtins.formatting.prettierd,
            null_ls.builtins.diagnostics.yamllint,
            null_ls.builtins.diagnostics.vale,
        },
    })
end

return M
