local M = {}
M.config = function()
    local status_ok, rust_tools = pcall(require, "rust-tools")
    if not status_ok then
        return
    end

    local lsp_installer_servers = require("nvim-lsp-installer.servers")
    local _, requested_server = lsp_installer_servers.get_server("rust_analyzer")

    local opts = {
        tools = {
            autoSetHints = true,
            hover_with_actions = true,
            runnables = {
                use_telescope = true,
            },
            inlay_hints = {
                only_current_line = false,
                show_parameter_hints = true,
                parameter_hints_prefix = "<-",
                other_hints_prefix = "=> ",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
            },
            hover_actions = {
                border = {
                    { "╭", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "╮", "FloatBorder" },
                    { "│", "FloatBorder" },
                    { "╯", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "╰", "FloatBorder" },
                    { "│", "FloatBorder" },
                },
            },
        },
        server = {
            -- cmd = requested_server._default_options.cmd,
            cmd_env = requested_server._default_options.cmd_env,
            on_attach = require("core.lsp.config").default_on_attach,
            -- on_init = require("core.lsp").common_on_init,
            settings = {
                -- to enable rust-analyzer settings visit:
                -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                ["rust-analyzer"] = {
                    assist = {
                        importGranularity = "module",
                        importEnforceGranularity = true,
                    },
                    rustfmt = {
                        extraArgs = { "+nightly" },
                        enableRangeFormatting = true,
                    },
                    -- enable clippy on save
                    checkOnSave = {
                        enable = true,
                        command = "clippy",
                        extraArgs = { "--target-dir", "/tmp/rust-analyzer-check" },
                    },
                },
            },
        },
    }
    rust_tools.setup(opts)
end

return M
