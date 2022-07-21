local default_on_attach = require("core.lsp.config").default_on_attach

local M = {}

function M.on_attach(client, bufnr)
    default_on_attach(client, bufnr)

    client.server_capabilities.documentFormattingProvider = true
end

M.settings = {
    yaml = {
        format = {
            enable = true,
            proseWrap = "always",
        },
        hover = true,
        completion = true,
        validate = true,
        schemaStore = {
            enable = true,
            url = "",
        },
        trace = { server = "trace" },
        schemas = {
            kubernetes = {
                "daemon.{yml,yaml}",
                "manager.{yml,yaml}",
                "restapi.{yml,yaml}",
                "role.{yml,yaml}",
                "role_binding.{yml,yaml}",
                "*onfigma*.{yml,yaml}",
                "*ngres*.{yml,yaml}",
                "*ecre*.{yml,yaml}",
                "*eployment*.{yml,yaml}",
                "*ervic*.{yml,yaml}",
                "kubectl-edit*.yaml",
            },
            ["https://json.schemastore.org/chart.json"] = "Chart.yaml",
        },
    },
}

return M
