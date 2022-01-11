local default_on_attach = require("core.lsp").common_on_attach
local M = {}

function M.on_attach(client, bufnr)
	default_on_attach(client, bufnr)

	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

M.settings = {
	json = { schemas = require("schemastore").json.schemas(), format = { enable = false } },
}

return M
