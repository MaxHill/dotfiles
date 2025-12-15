---@type Language
local M = {}

M.lsps = {
    {
        mason_name = "superhtml",
        lsp_name = "superhtml"
    }
}

-- Note: superhtml LSP handles formatting, no need for additional formatters

M.setup = function()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "superhtml",
        callback = function()
            vim.bo.commentstring = "<!-- %s -->"
        end,
    })
end

return M