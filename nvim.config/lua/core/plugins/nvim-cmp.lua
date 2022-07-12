local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local formatting_config = {
	fields = { "kind", "abbr", "menu" },
	kind_icons = {
		Class = " ",
		Color = " ",
		Constant = "ﲀ ",
		Constructor = " ",
		Enum = "練",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = "",
		Folder = " ",
		Function = " ",
		Interface = "ﰮ ",
		Keyword = " ",
		Method = " ",
		Module = " ",
		Operator = "",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		Struct = " ",
		Text = " ",
		TypeParameter = " ",
		Unit = "塞",
		Value = " ",
		Variable = " ",
	},
	source_names = {
		nvim_lsp = "(LSP)",
		emoji = "(Emoji)",
		path = "(Path)",
		calc = "(Calc)",
		cmp_tabnine = "(Tabnine)",
		vsnip = "(Snippet)",
		luasnip = "(Snippet)",
		buffer = "(Buffer)",
	},
	duplicates = {
		buffer = 1,
		path = 1,
		nvim_lsp = 0,
		luasnip = 1,
	},
	duplicates_default = 0,
}

local cmp_cfg = {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- disabled for autopairs mapping
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	window = {
	documentation = {
		border = "single",
		winhighlight = "FloatBorder:FloatBorder,Normal:Normal",
	}
	},
	experimental = {
		ghost_text = true,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "path" },
	}),
	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = formatting_config.kind_icons[vim_item.kind]
			vim_item.menu = formatting_config.source_names[entry.source.name]
			vim_item.dup = formatting_config.duplicates[entry.source.name] or formatting_config.duplicates_default
			return vim_item
		end,
	},
}

vim.cmd([[
  autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
]])

cmp.setup(cmp_cfg)

cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

--[[ cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }),
  }) ]]

-- M.autopairs = function()
-- 	require("nvim-autopairs").setup({
-- 		disable_filetype = { "TelescopePrompt", "vim" },
-- 	})
--
-- 	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
-- 	local cmp = require("cmp")
-- 	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
-- end
--
-- return M
