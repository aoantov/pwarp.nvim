local validator = require("pwarp.util.validator")

local M = {}

--- @alias Project {path: string, name: string}
--- @class SwitchConfig
--- @field enabled boolean
--- @field projects table<string,Project>
--- @class SwitchConfig
local state = {
  projects = {},
  enabled = true,
}

--- @param project Project
local function generate_project_key(project)
  return project.name
end

--- @param projects Project[]
local function map_to_projects(projects)
  local project_map = {}
  local key

  for index = 1, #projects do
    key = generate_project_key(projects[index])
    project_map[key] = {
      path = projects[index].path,
      name = projects[index].name,
    }
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
  local projects = {}

  for _, meta in pairs(state.projects) do
    table.insert(projects, meta)
  end

  return projects
end

-- Are projects empty
--- @return boolean
function M.are_projects_empty()
  if state.projects == {} then
    return true
  end

  return false
end

--- Get project by name
--- @param name string
--- @return Project | nil
function M.get_project(name)
  return state.projects[name]
end

return M
