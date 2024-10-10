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

    -- Cursorhold fix
    use({
        "antoinemadec/FixCursorHold.nvim",
        event = { "BufRead", "BufNewFile" },
        config = function()
            vim.g.cursorhold_updatetime = 100
        end,
    })

    -- This will be removed once https://github.com/neovim/neovim/pull/15436 is merged - so keep an eye on it

    use("rafamadriz/friendly-snippets")
    use({
        "neovim/nvim-lspconfig",
        requires = {
            { "b0o/SchemaStore.nvim" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            --[[ { "williamboman/nvim-lsp-installer" }, ]]
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
        "folke/neodev.nvim",
        module = "neodev",
    })

    use({
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
    })

    -- @todo look into autoinstalling here. I think that lunarvim handles it and I will eventually get to that, but just putting a note here in the scenario that they don't.
    -- @todo might want to tag theme here btw.
    use("rcarriga/nvim-notify")

    use("nvim-lua/plenary.nvim")
    -- @todo need to configure this
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
            require("core.plugins.telescope")
        end,
        event = "BufWinEnter",
    })

    use({ -- icons
        "kyazdani42/nvim-web-devicons",
        after = "tokyonight.nvim",
    })

    use({ -- color scheme
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                light_style = "day", -- The theme is used when the background is set to light
                transparent = false, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark", -- style for floating windows
                },
                sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
                day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
                hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
                dim_inactive = false, -- dims inactive windows
                lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

                --- You can override specific color groups to use other groups or a hex color
                --- function will be called with a ColorScheme table
                ---@param colors ColorScheme
                on_colors = function(colors) end,

                --- You can override specific highlights to use other groups or a hex color
                --- function will be called with a Highlights and ColorScheme table
                ---@param highlights Highlights
                ---@param colors ColorScheme
                on_highlights = function(highlights, colors) end,
            })
            -- vim.g.tokyonight_style = 'day'
            -- vim.g.tokyonight_sidebars = { 'qf' }
            -- vim.cmd('colorscheme tokyonight')
            -- Example config in Lua
            -- vim.g.tokyonight_style = "night"
            -- vim.g.tokyonight_italic_functions = true
            -- vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

            -- Change the "hint" color to the "orange" color, and make the "error" color bright red
            -- vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }

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

    -- Whichkey
    use({
        "folke/which-key.nvim",
        config = function()
            require("core.plugins.which-key").setup()
        end,
        event = "BufWinEnter",
    })

    use({
        "goolord/alpha-nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("core.plugins.alpha")
            -- require("alpha").setup(require("alpha.themes.startify").config)
        end,
    })

    -- Surround
    use({
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    })

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
            require("core.plugins.comment")
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

    use({
        "stevearc/dressing.nvim",
        module = "vim.ui",
        config = function()
            require("dressing").setup({})
        end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
