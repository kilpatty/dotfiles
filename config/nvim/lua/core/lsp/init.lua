local M = {}

local function add_lsp_buffer_keybindings(bufnr)
    local mappings = {
        normal_mode = "n",
        insert_mode = "i",
        visual_mode = "v",
    }

    -- @todo move this back into config at some point...
    local buffer_mappings = {
        normal_mode = {
            ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" },
            ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
            ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
            ["gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto references" },
            ["gI"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
            ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "show signature help" },
            ["gp"] = { "<cmd>lua require'lvim.lsp.peek'.Peek('definition')<CR>", "Peek definition" },
            ["gl"] = {
                "<cmd>lua require'lvim.lsp.handlers'.show_line_diagnostics()<CR>",
                "Show line diagnostics",
            },
        },
        insert_mode = {},
        visual_mode = {},
    }

    -- @todo come back and re-enable this.
    -- if core.builtin.which_key.active then
    -- 	-- Remap using which_key
    -- 	local status_ok, wk = pcall(require, "which-key")
    -- 	if not status_ok then
    -- 		return
    -- 	end
    -- 	for mode_name, mode_char in pairs(mappings) do
    -- 		wk.register(core.lsp.buffer_mappings[mode_name], { mode = mode_char, buffer = bufnr })
    -- 	end
    -- else
    -- Remap using nvim api
    for mode_name, mode_char in pairs(mappings) do
        -- @todo I moved buffer_mappings from config, to just be local here. Keeping this line as a reminder to switch back.
        -- for key, remap in pairs(core.lsp.buffer_mappings[mode_name]) do
        for key, remap in pairs(buffer_mappings[mode_name]) do
            vim.api.nvim_buf_set_keymap(bufnr, mode_char, key, remap[1], { noremap = true, silent = true })
        end
    end
    -- end
end

function M.setup()
    -- Log:debug("Setting up LSP support")

    local lsp_status_ok, _ = pcall(require, "lspconfig")
    if not lsp_status_ok then
        return
    end

    require("fidget").setup()

    -- vim.lsp.set_log_level("trace")

    require("lsp_signature").setup({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
            border = "rounded",
        },
    })

    local signs = require("core.lsp.config").config.signs
    for _, sign in ipairs(signs.values) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
    end

    require("core.lsp.config").handlers()

    -- if typescript_ok then
    --     typescript.setup({
    --         disable_commands = false, -- prevent the plugin from creating Vim commands
    --         debug = false, -- enable debug logging for commands
    --         -- LSP Config options
    --         server = {
    --             capabilities = require("lsp.servers.tsserver").capabilities,
    --             handlers = handlers,
    --             on_attach = require("lsp.servers.tsserver").on_attach,
    --         },
    --     })
    -- end

    require("core.lsp.providers")

    require("core.lsp.null-ls").setup()

    require("core.autocmds").configure_format_on_save()
end

return M
