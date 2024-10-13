-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

--[[ @todo review if this is the best place for it.  ]]
-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
