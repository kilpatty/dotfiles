local packer = nil

if packer == nil then
	packer = require("packer")
	packer.init({
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
			prompt_border = "single",
		},
		git = {
			clone_timeout = 800, -- Timeout, in seconds, for git clones
		},
		compile_path = vim.fn.stdpath("config") .. "/lua/compiled.lua",
		auto_clean = true,
		compile_on_sync = true,
	})
end

-- @todo this does not work...
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- @todo I might move this to init similar to cosmic vim.
	use({
		"lewis6991/impatient.nvim",
		config = function()
			require("impatient")
		end,
	})

	-- This will be removed once https://github.com/neovim/neovim/pull/15436 is merged - so keep an eye on it

	use({
		"neovim/nvim-lspconfig",
		requires = {
			{
				"hrsh7th/cmp-nvim-lsp",
				after = "nvim-lspconfig",
			},
			{
				"jose-elias-alvarez/nvim-lsp-ts-utils",
				config = function()
					require("core.ts_utils").config()
				end,
				after = "cmp-nvim-lsp",
			},
			{
				"ray-x/lsp_signature.nvim",
				after = "nvim-lsp-ts-utils",
			},
			{ "onsails/lspkind-nvim", after = "lsp_signature.nvim" },
		},
		config = function()
			require("null-ls").config({
				sources = {
					require("null-ls").builtins.formatting.stylua,
					require("null-ls").builtins.formatting.eslint_d,
				},
			})
			local on_attach = function(client)
				if client.resolved_capabilities.document_formatting then
					vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
				end
			end
			require("lspconfig")["null-ls"].setup({
				on_attach = on_attach,
			})
		end,
	})
	use({
		"simrat39/rust-tools.nvim",
		config = function()
			require("core.rust_tools").config()
		end,
	})
	use("tamago324/nlsp-settings.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	-- @todo look into autoinstalling here. I think that lunarvim handles it and I will eventually get to that, but just putting a note here in the scenario that they don't.
	use("williamboman/nvim-lsp-installer")
	-- @todo might want to tag theme here btw.
	use("rcarriga/nvim-notify")

	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
			},
		},
		event = "BufWinEnter",
	})

	use("nathom/filetype.nvim")

	use({ -- icons
		"kyazdani42/nvim-web-devicons",
		after = "tokyonight.nvim",
	})

	use({ -- color scheme
		"folke/tokyonight.nvim",
		config = function()
			-- vim.g.tokyonight_style = 'day'
			-- vim.g.tokyonight_sidebars = { 'qf' }
			-- vim.cmd('colorscheme tokyonight')
			-- Example config in Lua
			vim.g.tokyonight_style = "night"
			vim.g.tokyonight_italic_functions = true
			vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

			-- Change the "hint" color to the "orange" color, and make the "error" color bright red
			vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }

			-- Load the colorscheme
			vim.cmd([[colorscheme tokyonight]])
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				options = { theme = "tokyonight" },
			})
		end,
		after = "nvim-web-devicons",
	})

	-- file explorer
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			-- Coming back to this @todo
			-- require('cosmic.core.file-explorer')
		end,
		opt = true,
		cmd = {
			"NvimTreeClipboard",
			"NvimTreeClose",
			"NvimTreeFindFile",
			"NvimTreeOpen",
			"NvimTreeRefresh",
			"NvimTreeToggle",
		},
	})

	-- lang/syntax stuff
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			"windwp/nvim-ts-autotag",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"nvim-treesitter/nvim-treesitter-refactor",
		},
		run = ":TSUpdate",
		event = "BufEnter",
		config = function()
			-- require('cosmic.core.treesitter')
			-- local config = require('cosmic.config')
			require("nvim-treesitter.configs").setup({
				-- ensure_installed = config.treesitter.ensure_installed,
				-- @todo - we want to move this to config similar to how it's commented out above - also let's review all the plugins here to see if we want anything different
				-- @todo could just do this which is the maintained fn.
				-- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
				-- @todo let's review this btw
				-- ignore_install = { "javascript" }, -- List of parsers to ignore installing
				ensure_installed = "maintained",
				highlight = {
					enable = true,
					use_languagetree = true,
				},
				indent = {
					enable = true,
				},
				autotag = {
					enable = true,
				},
				context_commentstring = {
					enable = true,
				},
				refactor = {
					highlight_definitions = { enable = true },
					highlight_current_scope = { enable = false },
				},
				playground = {
					enable = true,
					disable = {},
					updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
					persist_queries = false, -- Whether the query persists across vim sessions
					keybindings = {
						toggle_query_editor = "o",
						toggle_hl_groups = "i",
						toggle_injected_languages = "t",
						toggle_anonymous_nodes = "a",
						toggle_language_display = "I",
						focus_language = "f",
						unfocus_language = "F",
						update = "R",
						goto_node = "<cr>",
						show_help = "?",
					},
				},
			})
		end,
	})

	use("nvim-treesitter/playground")

	use({
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
	})

	-- autocompletion
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("core.autocomplete").init()
		end,
		requires = {
			{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			{ "hrsh7th/cmp-buffer", after = "cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lua", after = "cmp-buffer" },
			{ "hrsh7th/cmp-path", after = "cmp-nvim-lua" },
		},
		after = "LuaSnip",
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("core.autocomplete").autopairs()
		end,
		after = "nvim-cmp",
	})

	-- Dashboard
	-- use {
	--   "ChristianChiarulli/dashboard-nvim",
	--   event = "BufWinEnter",
	--   config = function()
	--     require("core.dashboard").setup()
	--   end,
	-- }

	-- @todo still need to write config for this, see: https://github.com/numToStr/Comment.nvim
	-- Additionally check this out: https://www.reddit.com/r/neovim/comments/q35328/commentnvim_simple_and_powerful_comment_plugin/
	-- and this: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- @todo testing out trouble plugin... looks cool
	-- @todo finish playing with the config here: https://github.com/folke/trouble.nvim
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
