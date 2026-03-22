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
  if opts.enabled ~= nil then
    state.enabled = opts.enabled
  end

  if state.enabled and opts.projects ~= nil and opts.projects ~= {} then
    state.projects = map_to_projects(opts.projects)
  end
end

--- @param path string
--- @return Opts
local function get_config_from(path)
  local config_file = io.open(vim.fs.abspath(path))

  if config_file == nil then
    error("Unable to open configuration file")
  end

  local json_config_string = config_file:read("*a")
  local has_file_closed = config_file:close()

  if not has_file_closed then
    error("Unable to close configuration file")
  end

  local config = vim.json.decode(json_config_string)

  return config
end

-- Setup
--- @param opts? Opts
function M.setup(opts)
  local active_opts = opts

  if active_opts == nil or active_opts == {} then
    return
  end

  if active_opts.config ~= nil then
    active_opts = get_config_from(active_opts.config)
  end

  validator.validate_opts(active_opts)
  update_state(active_opts)
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
