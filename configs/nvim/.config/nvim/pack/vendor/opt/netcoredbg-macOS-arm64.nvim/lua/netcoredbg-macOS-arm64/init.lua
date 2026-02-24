local M = {}

-- Get plugin directory path
local function get_plugin_directory()
    local str = debug.getinfo(1, "S").source:sub(2)
    return str:match("(.*/)"):gsub("/[^/]+/[^/]+/$", "/")
end

local plugin_directory = get_plugin_directory()
local netcoredbg_path = plugin_directory .. "netcoredbg/netcoredbg"

local settings_cache = {}

local function debug_log(msg)
    -- Only show if you set a debug flag
    if vim.g.dap_cs_debug then
        debug_log("[dap-cs] " .. msg, vim.log.levels.DEBUG)
    end
end

-- Recursively find the nearest .csproj from a starting directory
local function find_nearest_csproj(start_dir)
    local path = start_dir
    while path ~= "/" do
        for name in vim.fs.dir(path) do
            if name:match("%.csproj$") then
                debug_log("[dap-cs] Found .csproj: " .. path .. "/" .. name)
                return path .. "/" .. name
            end
        end
        path = vim.fn.fnamemodify(path, ":h")
    end
    debug_log("[dap-cs] No .csproj found starting from: " .. start_dir)
    return nil
end

-- Determine output DLL from .csproj
local function get_dll_path_from_csproj(csproj_path)
    local project_dir = vim.fn.fnamemodify(csproj_path, ":h")
    local project_name = vim.fn.fnamemodify(csproj_path, ":t:r")
    local tfm_dir_cmd = 'find "' .. project_dir .. '/bin/Debug" -type d -name "net*" | head -n 1'
    debug_log("[dap-cs] Searching for TFM directory with command: " .. tfm_dir_cmd)
    local handle = io.popen(tfm_dir_cmd)
    local tfm_path = handle:read("*a"):gsub("[%s\n]+", "")
    handle:close()

    if tfm_path ~= "" then
        local dll_path = tfm_path .. "/" .. project_name .. ".dll"
        debug_log("[dap-cs] Potential DLL path: " .. dll_path)
        if vim.fn.filereadable(dll_path) == 1 then
            debug_log("[dap-cs] DLL found: " .. dll_path)
            return dll_path
        else
            debug_log("[dap-cs] DLL not found at: " .. dll_path)
        end
    else
        debug_log("[dap-cs] No TFM directory found under bin/Debug")
    end
    return nil
end

local function parse_launch_settings(csproj_dir)
    if settings_cache[csproj_dir] then
        return settings_cache[csproj_dir]
    end
    local path = csproj_dir .. "/Properties/launchSettings.json"
    local file = io.open(path, "r")
    if not file then
        debug_log("[dap-cs] Properties/launchSettings.json not found at: " .. path)
        return {}
    end

    local content = file:read("*a")
    file:close()

    -- Strip UTF-8 BOM if present
    if content:sub(1, 3) == '\239\187\191' then
        debug_log("[dap-cs] Stripped UTF-8 BOM from launchSettings.json")
        content = content:sub(4)
    end

    local ok, json = pcall(vim.fn.json_decode, content)
    if not ok then
        debug_log("[dap-cs] Failed to parse Properties/launchSettings.json: " .. content)
        return {}
    end

    if not json.profiles or vim.tbl_isempty(json.profiles) then
        debug_log("[dap-cs] No profiles found in launchSettings.json")
        return {}
    end

    -- Collect profile names
    local profile_names = {}
    for profile_name, _ in pairs(json.profiles) do
        table.insert(profile_names, profile_name)
    end
    table.sort(profile_names)

    -- Ask user to choose
    local choice = nil
    if #profile_names > 1 then
        local menu = { "Select launch profile:" }
        for i, name in ipairs(profile_names) do
            table.insert(menu, string.format("%d. %s", i, name))
        end
        choice = vim.fn.inputlist(menu)
        if choice < 1 or choice > #profile_names then
            debug_log("[dap-cs] Invalid choice")
            return {}
        end
    else
        choice = 1
    end

    local selected_name = profile_names[choice]
    local profile = json.profiles[selected_name]

    local env = profile.environmentVariables or {}
    if profile.applicationUrl then
        debug_log("[dap-cs] Found applicationUrl: " .. profile.applicationUrl)
        if not env.ASPNETCORE_URLS then
            env.ASPNETCORE_URLS = profile.applicationUrl
            debug_log("[dap-cs] Setting ASPNETCORE_URLS to: " .. profile.applicationUrl)
        end
    else
        debug_log("[dap-cs] No applicationUrl found.")
    end

    settings_cache[csproj_dir] = {
        env = env,
        workingDirectory = profile.workingDirectory,
    }
    return {
        env = env,
        workingDirectory = profile.workingDirectory,
    }
end

-- DAP Setup
M.setup = function(dap)
    dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg_path,
        args = { "--interpreter=vscode" },
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "NetCoreDbg: Launch",
            request = "launch",
            console = "internalConsole",
             cwd = function()
                 local file_dir = vim.fn.expand("%:p:h")
                 local csproj = find_nearest_csproj(file_dir)
                if not csproj then
                    local cwd_fallback = vim.fn.getcwd()
                    debug_log("[dap-cs] No csproj found, using cwd: " .. cwd_fallback)
                    return cwd_fallback
                end

                local csproj_dir = vim.fn.fnamemodify(csproj, ":h")
                local settings = parse_launch_settings(csproj_dir)

                local final_cwd = csproj_dir
                if settings.workingDirectory then
                    if not vim.fn.isabsolute(settings.workingDirectory) then
                        final_cwd = csproj_dir .. "/" .. settings.workingDirectory
                    else
                        final_cwd = settings.workingDirectory
                    end
                end

                return final_cwd
            end,
             program = function()
                 local file_dir = vim.fn.expand("%:p:h")
                 local csproj = find_nearest_csproj(file_dir)
                if not csproj then
                    debug_log("[dap-cs] Could not find .csproj, asking for DLL path")
                    return vim.fn.input("Could not find .csproj. Path to dll: ", "", "file")
                end
                local dll = get_dll_path_from_csproj(csproj)
                if dll then
                    debug_log("[dap-cs] Using DLL: " .. dll)
                    return dll
                else
                    debug_log("[dap-cs] DLL not found automatically, asking for path")
                end

                return vim.fn.input("Could not find dll. Path: ", "", "file")
            end,
             env = function()
                 local file_dir = vim.fn.expand("%:p:h")
                 local csproj = find_nearest_csproj(file_dir)
                if not csproj then
                    return { ASPNETCORE_ENVIRONMENT = "Development" }
                end
                local csproj_dir = vim.fn.fnamemodify(csproj, ":h")
                local settings = parse_launch_settings(csproj_dir)
                local env = settings.env or {}
                -- ensure there's always an environment
                if not env.ASPNETCORE_ENVIRONMENT then
                    env.ASPNETCORE_ENVIRONMENT = "Development"
                end
                return env
            end,
        },
    }
end

return M
