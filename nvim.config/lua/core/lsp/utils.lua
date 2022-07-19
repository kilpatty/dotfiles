local config = require("core.lsp.config")

local M = {}

function M.add_lsp_buffer_keybindings(bufnr)
    local mappings = {
        normal_mode = "n",
        insert_mode = "i",
        visual_mode = "v",
    }

    for mode_name, mode_char in pairs(mappings) do
        for key, remap in pairs(config.lsp.buffer_mappings[mode_name]) do
            local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
            vim.keymap.set(mode_char, key, remap[1], opts)
        end
    end
end

return M
