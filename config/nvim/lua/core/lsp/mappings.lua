vim.api.nvim_set_keymap(
	"n",
	"<leader>ga",
	'<cmd>lua require("telescope.builtin").lsp_code_actions()<cr>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>ga",
	'<cmd>lua require("telescope.builtin").lsp_range_code_actions()<cr>',
	{ noremap = true, silent = true }
)
