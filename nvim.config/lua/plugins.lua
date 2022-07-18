-- @todo this does not work...
-- @todo but there are some new solutions I think check this out: https://github.com/wbthomason/packer.nvim/issues/750
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

return packer.startup(function(use)
    use("lewis6991/impatient.nvim")

    use("wbthomason/packer.nvim")

    -- @todo I might move this to init similar to cosmic vim.
    -- use({
    -- 	"lewis6991/impatient.nvim",
    -- 	config = function()
    -- 		require("impatient")
    -- 	end,
    -- })

    -- This will be removed once https://github.com/neovim/neovim/pull/15436 is merged - so keep an eye on it

    use("rafamadriz/friendly-snippets")
    use({
        "neovim/nvim-lspconfig",
        requires = {
            { "b0o/SchemaStore.nvim" },
            { "williamboman/nvim-lsp-installer" },
            { "jose-elias-alvarez/nvim-lsp-ts-utils" },
            { "jose-elias-alvarez/null-ls.nvim", after = "nvim-lspconfig" },
            { "ray-x/lsp_signature.nvim", after = "nvim-lspconfig" },
            { "jose-elias-alvarez/typescript.nvim", after = "nvim-lspconfig" },
            { "j-hui/fidget.nvim", after = "nvim-lspconfig" },
        },
    })

    use({
        "hrsh7th/nvim-cmp",
        config = function()
            require("core.plugins.nvim-cmp")
        end,
        event = "InsertEnter",
        requires = {
            {
                "L3MON4D3/LuaSnip",
                config = function()
                    require("core.plugins.luasnips")
                end,
                requires = {
                    "rafamadriz/friendly-snippets",
                },
            },
            { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },

            {
                "windwp/nvim-autopairs",
                config = function()
                    require("core.plugins.auto-pairs")
                end,

                after = "nvim-cmp",
            },
        },
    })

    use({
        -- "simrat39/rust-tools.nvim",
        "kilpatty/rust-tools.nvim",
    })

    -- @todo look into autoinstalling here. I think that lunarvim handles it and I will eventually get to that, but just putting a note here in the scenario that they don't.
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
        config = function()
            require("core.telescope")
        end,
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

    use("arkav/lualine-lsp-progress")
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup({
                options = { theme = "tokyonight" },
                sections = {
                    lualine_c = {
                        "filename",
                        "lsp_progress",
                    },
                },
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

    -- Tree Sitter
    use({
        "nvim-treesitter/nvim-treesitter",
        requires = {
            "windwp/nvim-ts-autotag",
            "JoosepAlviste/nvim-ts-context-commentstring",
            "nvim-treesitter/nvim-treesitter-refactor",
        },
        run = ":TSUpdate",
        config = function()
            require("core.plugins.treesitter")
        end,
    })

    -- autocompletion

    -- Dashboard
    -- use {
    --   "ChristianChiarulli/dashboard-nvim",
    --   event = "BufWinEnter",
    --   config = function()
    --     require("core.dashboard").setup()
    --   end,
    -- }

    -- git column signs
    -- @todo revisit cnofig here, see: https://github.com/LunarVim/LunarVim/blob/rolling/lua/lvim/core/gitsigns.lua
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        event = "BufRead",
        config = function()
            require("gitsigns").setup()
        end,
    })

    -- @todo still need to write config for this, see: https://github.com/numToStr/Comment.nvim
    -- Additionally check this out: https://www.reddit.com/r/neovim/comments/q35328/commentnvim_simple_and_powerful_comment_plugin/
    -- and this: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- Indentation
    use({
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        config = function()
            require("core.plugins.indent-line")
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
