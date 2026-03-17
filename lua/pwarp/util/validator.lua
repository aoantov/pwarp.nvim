local general_utils = require("pwarp.util.general")

local M = {}

--- @param project OptsProject
local function validate_project(project)
  general_utils.check_types({ [project.name] = "string", [project.path] = "string" })

  if not general_utils.does_path_exist(project.path) then
    error("Invalid path for project '" .. project.name .. "'")
  end
end

--- @param projects OptsProject
local function validate_projects(projects)
  for index = 1, #projects do
    validate_project(projects[index])
  end
end

--- @param projects Project[]
--- @return boolean
local function are_projects_present(projects)
  return projects ~= nil and projects ~= {}
end

--- Validate options
--- @param opts? Opts
function M.validate_opts(opts)
  if opts == nil or opts == {} then
    error("Empty config options")
  end

  if are_projects_present(opts.projects) then
    validate_projects(opts.projects)
  end
end

return M
