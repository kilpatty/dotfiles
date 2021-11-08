local g = vim.g
local opt = vim.opt
-- local cmd = vim.cmd
-- local indent = 2

g.mapleader = " "

require("plugins")
require("compiled")
-- require("core.lsp")
require("core.lsp").setup()
require("core.bindings")

-- Remap the leader key to space

-- TextEdit might fail if hidden is not set.
opt.hidden = true

-- UI
-- Set hybrid mode for line numbers
opt.relativenumber = true
opt.number = true
--  Always show the signcolumn, otherwise it would shift the text each time
--  diagnostics appear/become resolved.
opt.signcolumn = "yes"
-- Use True Colors
opt.termguicolors = true

opt.splitbelow = true
opt.splitright = true

-- Backups
-- Some servers have issues with backup files, see #649.
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Perfomance
--  Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
--  delays and poor user experience.
opt.updatetime = 100
opt.timeoutlen = 400
opt.redrawtime = 1500
opt.ttimeoutlen = 10

-- vim.cmd 'source ~/.vimrc'
