local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
	local opts = {}

	-- (optional) Customize the options passed to the server
	-- if server.name == "tsserver" then
	--     opts.root_dir = function() ... end
	-- end

	if server.name == "rust_analyzer" then
		require("rust-tools").setup({
			server = { cmd = server._default_options.cmd },
		})
		return
	end
	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md
	server:setup(opts)
end)
