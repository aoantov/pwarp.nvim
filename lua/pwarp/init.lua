-- Commands
vim.api.nvim_create_user_command("Warp", function()
  require("pwarp").list()
end, {})

vim.api.nvim_create_user_command("WarpTo", function(opts)
  require("pwarp").goto(opts.args)
end, { nargs = 1 })

local M = {}

--- @alias OptsProject {name: string, path: string}
--- @class Opts
--- @field enabled? boolean
--- @field projects? OptsProject[]
--- @field config? string

-- Setup 
--- @param opts? Opts
function M.setup(opts)
  require("pwarp.config").setup(opts)
end


-- List projects
function M.list()
  require("pwarp.manager").list()
end


-- Go to project with the provided name
--- @param name string
function M.goto(name)
  require("pwarp.manager").goto(name)
end

return M
