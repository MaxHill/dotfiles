return {
  "ThePrimeagen/git-worktree.nvim",

  config = function()
    local Worktree = require "git-worktree"
    Worktree.setup()
    Worktree.on_tree_change(function(op, metadata)
      if op == Worktree.Operations.Switch then
        if metadata.path:find("public-web-12", 1, true) then
          print "The word public-web-12 was found."
          -- Extract the base directory
          local base_dir = metadata.path:match "(.*/public%-web%-12)"
          if base_dir then
            local appsettingsSrc = base_dir .. "/appsettings.Local.json"
            local appsettingsDest = metadata.path .. "/src/appsettings.Local.json"

            -- Copy the file
            local cmd = string.format('cp "%s" "%s"', appsettingsSrc, appsettingsDest)
            print("Executing: " .. cmd)
            os.execute(cmd)
          end
        else
          print "The word public-web-12 was not found."
        end
      end
    end)
  end,
}
