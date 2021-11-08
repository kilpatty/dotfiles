local M = {}
-- local Log = require("core.log")
-- local utils = require("core.utils")

local function lsp_highlight_document(client)
	--@todo come  back to this when config works
	-- if core.lsp.document_highlight == false then
	-- 	return -- we don't need further
	-- end
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
			false
		)
	end
end

local function lsp_code_lens_refresh(client)
	--@todo come  back to this when config works
	-- if core.lsp.code_lens_refresh == false then
	-- 	return
	-- end

	if client.resolved_capabilities.code_lens then
		vim.api.nvim_exec(
			[[
      augroup lsp_code_lens_refresh
        autocmd! * <buffer>
        autocmd InsertLeave <buffer> lua vim.lsp.codelens.refresh()
        autocmd InsertLeave <buffer> lua vim.lsp.codelens.display()
      augroup END
    ]],
			false
		)
	end
end

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

function M.common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
	end

	return capabilities
end

local function select_default_formatter(client)
	if client.name == "null-ls" or not client.resolved_capabilities.document_formatting then
		return
	end
	-- Log:debug("Checking for formatter overriding for " .. client.name)
	local formatters = require("core.lsp.null-ls.formatters")
	local client_filetypes = client.config.filetypes or {}
	for _, filetype in ipairs(client_filetypes) do
		if #vim.tbl_keys(formatters.list_registered_providers(filetype)) > 0 then
			-- Log:debug("Formatter overriding detected. Disabling formatting capabilities for " .. client.name)
			client.resolved_capabilities.document_formatting = false
			client.resolved_capabilities.document_range_formatting = false
		end
	end
end

function M.common_on_init(client, bufnr)
	--@todo come back to tthis later as we need to fix the global shit.
	-- if core.lsp.on_init_callback then
	-- 	core.lsp.on_init_callback(client, bufnr)
	-- 	Log:debug("Called lsp.on_init_callback")
	-- 	return
	-- end
	select_default_formatter(client)
end

function M.common_on_attach(client, bufnr)
	-- @todo NICE this worked - now we just probs want to get this into a different spot so that we aren't hardcoding all these things in.
	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
		local ts_utils = require("nvim-lsp-ts-utils")

		-- defaults
		ts_utils.setup({
			debug = false,
			disable_commands = false,
			enable_import_on_completion = false,

			-- import all
			import_all_timeout = 5000, -- ms
			-- lower numbers indicate higher priority
			import_all_priorities = {
				same_file = 1, -- add to existing import statement
				local_files = 2, -- git files or files with relative path markers
				buffer_content = 3, -- loaded buffer content
				buffers = 4, -- loaded buffer names
			},
			import_all_scan_buffers = 100,
			import_all_select_source = false,

			-- eslint
			eslint_enable_code_actions = true,
			eslint_enable_disable_comments = true,
			eslint_bin = "eslint",
			eslint_enable_diagnostics = false,
			eslint_opts = {},

			-- formatting
			enable_formatting = false,
			formatter = "prettier",
			formatter_opts = {},

			-- update imports on file move
			update_imports_on_move = false,
			require_confirmation_on_move = false,
			watch_dir = nil,

			-- filter diagnostics
			filter_out_diagnostics_by_severity = {},
			filter_out_diagnostics_by_code = {},

			-- inlay hints
			-- @todo reenable when this works.
			auto_inlay_hints = false,
			inlay_hints_highlight = "Comment",
		})

		-- required to fix code action ranges and filter diagnostics
		ts_utils.setup_client(client)

		-- no default maps, so you may want to define some here
		local opts = { silent = true }
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
	end
	--@todo come back to tthis later as we need to fix the global shit.
	-- if core.lsp.on_attach_callback then
	-- 	core.lsp.on_attach_callback(client, bufnr)
	-- 	Log:debug("Called lsp.on_attach_callback")
	-- end
	lsp_highlight_document(client)
	lsp_code_lens_refresh(client)
	add_lsp_buffer_keybindings(bufnr)
end

local function bootstrap_nlsp(opts)
	opts = opts or {}
	local lsp_settings_status_ok, lsp_settings = pcall(require, "nlspsettings")
	if lsp_settings_status_ok then
		lsp_settings.setup(opts)
	end
end

function M.get_common_opts()
	return {
		on_attach = M.common_on_attach,
		on_init = M.common_on_init,
		capabilities = M.common_capabilities(),
	}
end

function M.setup()
	-- Log:debug("Setting up LSP support")

	local lsp_status_ok, _ = pcall(require, "lspconfig")
	if not lsp_status_ok then
		return
	end

	-- @todo
	-- for _, sign in ipairs(core.lsp.diagnostics.signs.values) do
	-- 	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	-- end

	require("core.lsp.providers")

	-- require("core.lsp.handlers").setup()

	-- if not utils.is_directory(core.lsp.templates_dir) then
	-- 	require("core.lsp.templates").generate_templates()
	-- end

	-- bootstrap_nlsp({ config_home = utils.join_paths(get_config_dir(), "lsp-settings") })

	-- require("core.lsp.null-ls").setup()

	-- require("core.utils").toggle_autoformat()
end

return M
-- local lsp_installer = require("nvim-lsp-installer")
--
-- lsp_installer.on_server_ready(function(server)
-- 	local opts = {}
--
-- 	-- (optional) Customize the options passed to the server
-- 	-- if server.name == "tsserver" then
-- 	--     opts.root_dir = function() ... end
-- 	-- end
--
-- 	if server.name == "rust_analyzer" then
-- 		require("rust-tools").setup({
-- 			server = { cmd = server._default_options.cmd },
-- 		})
-- 		return
-- 	end
-- 	-- This setup() function is exactly the same as lspconfig's setup function.
-- 	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md
-- 	server:setup(opts)
-- end)
