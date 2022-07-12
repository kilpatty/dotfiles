-- @todo going to use this for u.merge
local u = require("utils")
local config = require("core.lsp.config")
-- local default_config = require("cosmic.lsp.providers.defaults")
-- local config = require("cosmic.config")
require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = " ",
            server_pending = " ",
            server_uninstalled = " ﮊ",
        },
        keymaps = {
            -- Keymap to expand a server in the UI
            toggle_server_expand = "i",
            -- Keymap to install a server
            install_server = "<CR>",
            -- Keymap to reinstall/update a server
            update_server = "u",
            -- Keymap to uninstall a server
            uninstall_server = "x",
        },
    },
})

local lspconfig = require("lspconfig")

local servers = { "tsserver", "jsonls", "sumneko_lua", "rust_analyzer", "tailwindcss" }

for _, server in pairs(servers) do
    local default_opts = config.default_opts()

    local opts = {
        on_init = require("core.lsp").common_on_init,
    }

    default_opts = vim.tbl_deep_extend("force", default_opts, opts)

    local has_custom_opts, server_custom_opts = pcall(require, "core.lsp.providers." .. server)
    if has_custom_opts then
        default_opts = vim.tbl_deep_extend("force", default_opts, server_custom_opts)
    end

    lspconfig[server].setup(default_opts)
end

-- disable server if config disabled server list says so
-- opts.autostart = true
-- if vim.tbl_contains(disabled_servers, server.name) then
-- 	opts.autostart = false
-- end

-- set up default cosmic options
-- if server.name == "tsserver" then
-- 	opts = vim.tbl_deep_extend("force", opts, require("core.lsp.providers.tsserver"))
-- 	-- elseif server.name == "efm" then
-- 	-- 	opts = vim.tbl_deep_extend("force", opts, require("cosmic.lsp.providers.efm"))
-- elseif server.name == "jsonls" then
-- 	opts = vim.tbl_deep_extend("force", opts, require("core.lsp.providers.jsonls"))
-- elseif server.name == "sumneko_lua" then
-- 	opts = vim.tbl_deep_extend("force", opts, require("core.lsp.providers.lua"))
-- 	-- elseif server.name == "eslint" then
-- 	-- 	opts = vim.tbl_deep_extend("force", opts, require("cosmic.lsp.providers.eslint"))
-- end
--
-- if server.name == "rust_analyzer" then
-- else
--
-- -- override options if user definds them
-- if type(config.lsp.servers[server.name]) == "table" then
-- 	if config.lsp.servers[server.name].opts ~= nil then
-- 		opts = config.lsp.servers[server.name].opts
-- 	end
-- end

-- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
-- server:setup(opts)
-- vim.cmd([[ do User LspAttachBuffers ]])
