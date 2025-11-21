local M = {}

M.install = function(name)
    vim.schedule(function()
        local registry = require("mason-registry")
        if not registry.is_installed(name) then
            local pkg = registry.get_package(name)
            pkg:install()
        end
    end)
end

return M
