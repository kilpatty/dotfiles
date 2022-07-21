local M = {}

M.config = {
    virtual_text = {
        source = "always",
    },
    signs = {
        active = true,
        values = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn", text = "" },
            { name = "DiagnosticSignHint", text = "" },
            { name = "DiagnosticSignInfo", text = "" },
        },
    },
    underline = true,
    -- @todo
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        format = function(d)
            local t = vim.deepcopy(d)
            local code = d.code or (d.user_data and d.user_data.lsp.code)
            if code then
                t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
            end
            return t.message
        end,
    },
}

M.buffer_mappings = {
    normal_mode = {
        ["K"] = { vim.lsp.buf.hover, "Show hover" },
        ["gd"] = { vim.lsp.buf.definition, "Goto Definition" },
        ["gD"] = { vim.lsp.buf.declaration, "Goto declaration" },
        ["gr"] = { vim.lsp.buf.references, "Goto references" },
        ["gI"] = { vim.lsp.buf.implementation, "Goto Implementation" },
        ["gs"] = { vim.lsp.buf.signature_help, "show signature help" },
        -- ["<leader>la"] = { function() vim.lsp.buf.code_action() end, desc = "LSP code action" },
        -- ["<leader>lf"] = { function() vim.lsp.buf.formatting_sync() end, desc = "Format code" },
        -- ["<leader>lh"] = { function() vim.lsp.buf.signature_help() end, desc = "Signature help" },
        -- ["<leader>lr"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol" },
        -- ["<leader>ld"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
        ["[d"] = {
            vim.diagnostic.goto_prev,
            desc = "Previous diagnostic",
        },
        ["]d"] = {
            vim.diagnostic.goto_next,
            desc = "Next diagnostic",
        },
        -- ["gl"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
        -- ["gp"] = {
        --     function()
        --         require("lvim.lsp.peek").Peek("definition")
        --     end,
        --     "Peek definition",
        -- },
        -- ["gl"] = {
        --     function()
        --         local config = lvim.lsp.diagnostics.float
        --         config.scope = "line"
        --         vim.diagnostic.open_float(0, config)
        --     end,
        --     "Show line diagnostics",
        -- },
    },
    insert_mode = {},
    visual_mode = {},
}

-- @todo I low key want to move everything below this to a file called defaults
function M.handlers()
    vim.diagnostic.config(M.config)
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { focusable = true, style = "minimal", border = "rounded" }
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { focusable = true, style = "minimal", border = "rounded" }
    )
end

local function add_lsp_buffer_keybindings(bufnr)
    local mappings = {
        normal_mode = "n",
        insert_mode = "i",
        visual_mode = "v",
    }

    for mode_name, mode_char in pairs(mappings) do
        for key, remap in pairs(M.buffer_mappings[mode_name]) do
            local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
            vim.keymap.set(mode_char, key, remap[1], opts)
        end
    end
end

-- Check this out https://github.com/budswa/nvim/blob/master/lua/art/modules/lsp/null-ls.lua
function M.default_on_attach(client, bufnr)
    -- @todo in the future play w/ illuminate
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = "lsp_document_highlight",
            pattern = "<buffer>",
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = "lsp_document_highlight",
            pattern = "<buffer>",
            callback = vim.lsp.buf.clear_references,
        })
    end

    if client.supports_method("textDocument/codeLens") then
        vim.api.nvim_create_augroup("lsp_code_lens_refresh", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
            group = "lsp_code_lens_refresh",
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
        })
    end

    -- This automatically opens diagnostics in float
    -- @todo do we only want to create this if the server is going to show us diagnostics? Not sure what variables have
    -- that to make us able to check.
    -- Might be available at textDocument/publishDiagnostics
    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = "rounded",
                source = "always",
                prefix = " ",
                scope = "cursor",
            }
            vim.diagnostic.open_float(nil, opts)
        end,
    })

    add_lsp_buffer_keybindings(bufnr)
end

-- @todo
-- function M.default_on_exit(client, bufnr)
--     if client.server_capabilities.documentHighlightProvider then
--     autocmds.clear_augroup "lsp_document_highlight"
--   end
--   if lvim.lsp.code_lens_refresh then
--     autocmds.clear_augroup "lsp_code_lens_refresh"
--   end
-- end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

-- @todo we can only use what cmp_nvim supports... See if there are better alternatives
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

-- @todo Flags: https://github.com/AstroNvim/AstroNvim/blob/v2/lua/core/utils/lsp.lua
M.flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 200,
}

-- @todo could do on_init

function M.default_opts()
    return {
        on_attach = M.default_on_attach,
        capabilities = M.capabilities,
        flags = M.flags,
    }
end

return M
