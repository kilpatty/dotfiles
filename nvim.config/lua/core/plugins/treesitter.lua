local defaults = {
	ensure_installed = "all",
	ignore_install = { "phpdoc" },
	highlight = {
		enable = true,
		use_languagetree = true,
	},
	  incremental_selection = { enable = true },
	indent = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	refactor = {
		highlight_definitions = { enable = true },
		highlight_current_scope = { enable = false },
	},
}

require("nvim-treesitter.configs").setup(defaults)
