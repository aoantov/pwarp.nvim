local Validator = require("pjswitch.util.validator")

--- @alias ProjectMetadata {path: string}
--- @alias Project table<string,ProjectMetadata>
--- @class SwitchConfig
--- @field enabled boolean
--- @field projects Project[]
local M = {}

--- @class SwitchConfig
local state = {
  projects = {},
  enabled = true,
}

local function map_to_projects(projects)
  local projectMap = {}

  for index = 1, #projects do
    projectMap[projects[index].name] = {
      path = projects[index].path,
    }
  end

  return projectMap
end

function M.setup(opts)
  Validator.validate_opts(opts)

  state.projects = map_to_projects(opts.projects)
end

--- @return Project[]
function M.get_projects()
  return state.projects
end

--- @return boolean
function M.are_projects_empty()
  if #state.projects == 0 then
    return true
  end

  return false
end

--- @param name string
--- @return Project | nil
function M.get_project(name)
  return state.projects[name]
end

return M
