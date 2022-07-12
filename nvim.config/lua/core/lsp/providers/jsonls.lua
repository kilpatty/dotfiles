local M = {}

M.settings = {
    json = {
        validate = { enable = true },
        schemas = require("schemastore").json.schemas(),
    },
}

M.setup = {
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
            end,
        },
    },
}

return M
