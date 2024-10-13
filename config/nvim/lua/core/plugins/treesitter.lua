local defaults = {
    ensure_installed = "all",
    ignore_install = { "phpdoc", "scfg" },
    highlight = {
        enable = true,
        use_languagetree = true,
    },
    incremental_selection = { enable = true },
    indent = {
        enable = true,
        disable = { "yaml" },
    },
    autotag = {
        enable = true,
    },
    refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = false },
    },
}

require("ts_context_commentstring").setup({
    enable_autocmd = false,
})

require("nvim-treesitter.configs").setup(defaults)
