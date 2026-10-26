local M = {}

--- @alias BufferOpts  {file?: string, persist?: boolean}
--- @alias OptsProject {name: string, path: string}
--- @class Opts
--- @field projects? OptsProject[]
--- @field config? string
--- @field buffers? BufferOpts

-- Setup
--- @param opts? Opts
function M.setup(opts)
  require("pwarp.manager").setup(opts)
end

-- List projects
function M.list()
  require("pwarp.manager").list()
end

-- Go to project with the provided name
--- @param name string
function M.go_to(name)
  require("pwarp.manager").go_to(name)
end

return M
