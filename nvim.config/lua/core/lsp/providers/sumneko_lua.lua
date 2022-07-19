local default_on_attach = require("core.lsp.config").default_on_attach

local opts = {}

function opts.on_attach(client, bufnr)
    default_on_attach(client, bufnr)

    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

opts.settings = {
    Lua = {
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim", "packer_plugins" },
        },
    },
}

local lua_dev_loaded, lua_dev = pcall(require, "lua-dev")
if not lua_dev_loaded then
    return opts
end

local dev_opts = {
    library = {
        vimruntime = true, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = true,

        -- plugins = true, -- installed opt or start plugins in packpath
        -- you can also specify the list of plugins to make available as a workspace library
        -- plugins = { "plenary.nvim" },
    },
    lspconfig = opts,
}

return lua_dev.setup(dev_opts)
