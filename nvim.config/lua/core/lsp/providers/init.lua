-- @todo going to use this for u.merge
-- local u = require("utils")
local config = require("core.lsp.config")
-- local default_config = require("cosmic.lsp.providers.defaults")
-- local config = require("cosmic.config")
--[[ require("nvim-lsp-installer").setup({ ]]
--[[     automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig) ]]
--[[     ui = { ]]
--[[         icons = { ]]
--[[             server_installed = " ", ]]
--[[             server_pending = " ", ]]
--[[             server_uninstalled = " ﮊ", ]]
--[[         }, ]]
--[[         keymaps = { ]]
--[[             -- Keymap to expand a server in the UI ]]
--[[             toggle_server_expand = "i", ]]
--[[             -- Keymap to install a server ]]
--[[             install_server = "<CR>", ]]
--[[             -- Keymap to reinstall/update a server ]]
--[[             update_server = "u", ]]
--[[             -- Keymap to uninstall a server ]]
--[[             uninstall_server = "x", ]]
--[[         }, ]]
--[[     }, ]]
--[[ }) ]]

require("mason").setup({
    ui = {
        icons = {
            package_installed = " ",
            package_pending = " ",
            package_uninstalled = " ﮊ",
        },
    },
})
--[[ require("mason-lspconfig").setup({ ]]
--[[     ensure_installed = { "sumneko_lua" }, ]]
--[[ }) ]]

local mason_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_status_ok then
    vim.notify("Couldn't load Mason-LSP-Config" .. mason_lspconfig, "error")
    return
end

local servers = {
    "tsserver",
    "jsonls",
    "lua_ls",
    "rust_analyzer",
    "tailwindcss",
    "eslint",
    "yamlls",
    "tflint",
}

-- Extension to bridge mason.nvim with the lspconfig plugin
mason_lspconfig.setup({
    automatic_installation = true,
})

local lspconfig = require("lspconfig")

local skip_setup = { "rust_analyzer" }

for _, server in pairs(servers) do
    if not vim.tbl_contains(skip_setup, server) then
        local default_opts = config.default_opts()

        local opts = {
            on_init = require("core.lsp").common_on_init,
        }

        default_opts = vim.tbl_deep_extend("force", default_opts, opts)

        local has_custom_opts, server_custom_opts = pcall(require, "core.lsp.providers." .. server)
        if has_custom_opts then
            default_opts = vim.tbl_deep_extend("force", default_opts, server_custom_opts)
        end

        -- if server == "eslint" then
        --     vim.pretty_print(vim.inspect(default_opts))
        -- end

        lspconfig[server].setup(default_opts)
    end
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
