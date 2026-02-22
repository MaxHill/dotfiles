require("user.types")

---@type Language
local M = {}

M.lsps = {
    {
        mason_name = "zls",
        lsp_name = "zls",
        config = {
            root_markers = { "build.zig", "build.zig.zon", ".git" },
        }
    }
}

M.filetypes = { "zig", "zon" }

M.formatters = {
    {
        name = "zigfmt",
        options = {
            command = "zig",
            args = { "fmt", "--stdin" },
            stdin = true,
        }
    }
}

-- Helper function to find Zig project root
local function find_zig_project_root()
    local cwd = vim.fn.getcwd()
    -- Look for build.zig in current directory or parent directories
    local root = vim.fs.root(0, { "build.zig", "build.zig.zon" })
    return root or cwd
end

-- Helper function to find executables in zig-out/bin
local function find_zig_executables()
    local root = find_zig_project_root()
    local bin_dir = root .. "/zig-out/bin"
    
    -- Check if zig-out/bin exists
    local handle = vim.loop.fs_scandir(bin_dir)
    if not handle then
        return {}
    end
    
    local executables = {}
    while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end
        
        -- Only include files (not directories) and skip .pdb files
        if type == "file" and not name:match("%.pdb$") then
            local full_path = bin_dir .. "/" .. name
            -- Check if file is executable
            local stat = vim.loop.fs_stat(full_path)
            if stat and stat.mode then
                table.insert(executables, { name = name, path = full_path })
            end
        end
    end
    
    return executables
end

-- Helper function to prompt for executable selection
local function select_executable()
    local executables = find_zig_executables()
    
    if #executables == 0 then
        vim.notify("No executables found in zig-out/bin. Build the project first.", vim.log.levels.ERROR)
        return nil
    end
    
    if #executables == 1 then
        return executables[1].path
    end
    
    -- Multiple executables, prompt user
    local choices = {}
    for i, exe in ipairs(executables) do
        table.insert(choices, string.format("%d: %s", i, exe.name))
    end
    
    local choice = vim.fn.inputlist(vim.list_extend({ "Select executable to debug:" }, choices))
    
    if choice > 0 and choice <= #executables then
        return executables[choice].path
    end
    
    return nil
end

-- Helper function to build Zig project
local function build_zig_project(callback)
    local root = find_zig_project_root()
    
    vim.notify("Building Zig project...", vim.log.levels.INFO)
    
    -- Run zig build in a terminal job
    vim.fn.jobstart({ "zig", "build" }, {
        cwd = root,
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                vim.notify("Build successful!", vim.log.levels.INFO)
                if callback then callback(true) end
            else
                vim.notify("Build failed with exit code " .. exit_code, vim.log.levels.ERROR)
                if callback then callback(false) end
            end
        end,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(line)
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(line)
                    end
                end
            end
        end,
    })
end

M.setup = function()
    local mason_utils = require("user.mason")
    mason_utils.install("codelldb")
    
    local dap = require("dap")
    
    -- Configure codelldb adapter for Zig (using executable mode for better reliability)
    dap.adapters.codelldb = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        -- On Windows, you may need: detached = false,
    }
    
    -- Zig debug configurations
    dap.configurations.zig = {
        -- Configuration 1: Build and launch executable
        {
            name = "Build and Launch",
            type = "codelldb",
            request = "launch",
            program = function()
                -- Build the project first
                local program_path = nil
                local co = coroutine.running()
                
                build_zig_project(function(success)
                    if success then
                        program_path = select_executable()
                    end
                    coroutine.resume(co)
                end)
                
                coroutine.yield()
                return program_path
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = function()
                local args_string = vim.fn.input("Program arguments (leave empty for none): ")
                if args_string == "" then
                    return {}
                end
                return vim.split(args_string, " ")
            end,
        },
        
        -- Configuration 2: Launch existing executable (no build)
        {
            name = "Launch (no build)",
            type = "codelldb",
            request = "launch",
            program = function()
                return select_executable()
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = function()
                local args_string = vim.fn.input("Program arguments (leave empty for none): ")
                if args_string == "" then
                    return {}
                end
                return vim.split(args_string, " ")
            end,
        },
        
        -- Configuration 3: Build and debug Zig tests
        {
            name = "Build and Test",
            type = "codelldb",
            request = "launch",
            program = function()
                local root = find_zig_project_root()
                local test_exe = root .. "/zig-out/bin/test"
                
                -- Build tests first
                vim.notify("Building Zig tests...", vim.log.levels.INFO)
                
                local handle = io.popen("cd " .. root .. " && zig build test 2>&1")
                local result = handle:read("*a")
                local success = handle:close()
                
                if not success then
                    vim.notify("Test build failed:\n" .. result, vim.log.levels.ERROR)
                    return nil
                end
                
                vim.notify("Test build successful!", vim.log.levels.INFO)
                
                -- Check if test executable exists
                local stat = vim.loop.fs_stat(test_exe)
                if stat then
                    return test_exe
                end
                
                -- If not in default location, try to find it
                local executables = find_zig_executables()
                for _, exe in ipairs(executables) do
                    if exe.name:match("test") then
                        return exe.path
                    end
                end
                
                vim.notify("Could not find test executable", vim.log.levels.ERROR)
                return nil
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
        },
        
        -- Configuration 4: Attach to running process
        {
            name = "Attach to Process",
            type = "codelldb",
            request = "attach",
            pid = function()
                local handle = io.popen("ps aux | grep -v grep | grep -E '(zig-out|zig)' | awk '{print $2 \" \" $11}'")
                local result = handle:read("*a")
                handle:close()
                
                if result == "" then
                    return tonumber(vim.fn.input("Process ID: "))
                end
                
                -- Show available processes
                local processes = {}
                for line in result:gmatch("[^\r\n]+") do
                    table.insert(processes, line)
                end
                
                if #processes == 0 then
                    return tonumber(vim.fn.input("Process ID: "))
                end
                
                local choices = { "Select process to attach:" }
                for i, proc in ipairs(processes) do
                    table.insert(choices, string.format("%d: %s", i, proc))
                end
                table.insert(choices, string.format("%d: Enter PID manually", #processes + 1))
                
                local choice = vim.fn.inputlist(choices)
                
                if choice > 0 and choice <= #processes then
                    local pid = processes[choice]:match("^(%d+)")
                    return tonumber(pid)
                elseif choice == #processes + 1 then
                    return tonumber(vim.fn.input("Process ID: "))
                end
                
                return nil
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }
end

return M
