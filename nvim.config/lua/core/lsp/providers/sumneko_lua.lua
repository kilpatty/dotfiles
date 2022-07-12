return {
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					        library = vim.api.nvim_get_runtime_file("", true),
				},
				checkThirdParty = false,
				maxPreload = 10000,
			},
			 telemetry = {
        enable = false,
      },
		},
	},
}
