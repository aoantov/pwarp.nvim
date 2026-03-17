local validator = require("pwarp.util.validator")

local M = {}

--- @alias Project {path: string, name: string}
--- @class SwitchConfig
--- @field enabled boolean
--- @field projects Project[]
--- @class SwitchConfig
local state = {
  projects = {},
  enabled = true,
}

--- @param projects Project[]
local function map_to_projects(projects)
  local project_map = {}

  for index = 1, #projects do
    table.insert(project_map, {
      path = projects[index].path,
      name = projects[index].name,
    })
  end

  return project_map
end

--- @param opts Opts
local function update_state(opts)
  state.enabled = opts.enabled or state.enabled

  if opts.projects ~= nil and opts.projects ~= {} then
    state.projects = map_to_projects(opts.projects)
  end
end

-- Setup
--- @param opts? Opts
function M.setup(opts)
  if opts ~= nil and opts ~= {} then
    validator.validate_opts(opts)
    update_state(opts)
  end
end

-- Get all projects
--- @return Project[]
function M.get_projects()
  return state.projects
end

-- Are projects empty
--- @return boolean
function M.are_projects_empty()
  if #state.projects == 0 then
    return true
  end

  return false
end

--- Get project by name
--- @param name string
--- @return Project | nil
function M.get_project(name)
  for i = 1, #state.projects do
    if state.projects[i].name == name then
      return state.projects[i]
    end
  end

  return nil
end

return M
