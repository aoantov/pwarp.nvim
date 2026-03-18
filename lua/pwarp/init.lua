
local M = {}

--- @alias OptsProject {name: string, path: string}
--- @class Opts
--- @field enabled? boolean
--- @field projects? OptsProject[]

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
