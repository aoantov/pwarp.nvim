local validator = require("pwarp.util.validator")

local M = {}

--- @alias Project {path: string, name: string}
--- @class SwitchConfig
--- @field projects Project[]
--- @field fn.persist_bufs boolean
local state = {
  projects = {},
  persist_bufs = true,
}

--- @param projects OptsProject[]
--- @return Project[]
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
  if opts.projects ~= nil and opts.projects ~= {} then
    state.projects = map_to_projects(opts.projects)
  end

  if opts.buffers ~= nil and opts.buffers.persist ~= nil then
    state.persist_bufs = opts.buffers.persist
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

--- Get project by path
--- @param path string
--- @return Project | nil
function M.get_project_by_path(path)
  local target = vim.fs.normalize(vim.fs.abspath(path))
  for i = 1, #state.projects do
    if vim.fs.normalize(vim.fs.abspath(state.projects[i].path)) == target then
      return state.projects[i]
    end
  end

  return nil
end

--- @return boolean
function M.are_bufs_persisted()
  return state.persist_bufs
end

return M
