local config = require("pwarp.config")

local M = {}

--- @return boolean
local function is_session_enabled()
  return config.are_bufs_retained()
end

-- TODO: revisit this function for improvement on location
local function setup_session_autocmds()
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("PWarp", { clear = true }),
    callback = function()
      require("pwarp.manager").save_current()
    end,
    desc = "Save the current project on exit",
  })

  vim.api.nvim_create_user_command("WarpBuffReset", function()
    require("pwarp.manager").reset_store()
  end, {
    desc = "Reset the buffer store for all projects",
  })
end

--- @param opts? Opts
function M.setup(opts)
  config.setup(opts)

  if is_session_enabled() then
    setup_session_autocmds()
  end
end

--- @param project Project
--- @return string
local function generate_view_element_name(project)
  local elem_path = string.sub(project.path, -30)
  if #elem_path < #project.path then
    elem_path = "..." .. elem_path
  end

  return project.name .. ": " .. elem_path
end

--- @param projects Project[]
--- @return ViewElement[]
local function get_view_elements_from(projects)
  local cwd = vim.fn.getcwd()

  local elements = {}
  local element_name
  for i = 1, #projects do
    if cwd ~= vim.fs.abspath(projects[i].path) then
      element_name = generate_view_element_name(projects[i])
      table.insert(elements, {
        name = element_name,
        value = projects[i],
        ordinal = projects[i].name .. " " .. projects[i].path,
      })
    end
  end

  return elements
end

local function close_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

--- @param project Project
local function switch_project(project)
  local session
  if is_session_enabled() then
    -- Load the session module first as it fails to find it when moving to another project
    session = require("pwarp.session")
  end

  close_buffers()
  vim.cmd.cd(vim.fn.fnameescape(project.path))

  if is_session_enabled() then
    session.restore(project)
    local current_project = config.get_project_by_path(vim.fn.getcwd())

    if current_project ~= nil then
      session.save(current_project)
    end
  end
end

function M.save_current()
  local current_project = config.get_project_by_path(vim.fn.getcwd())

  if current_project ~= nil then
    require("pwarp.session").save(current_project)
  end
end

function M.reset_store()
  require("pwarp.session").reset()
end

-- List projects
function M.list()
  local projects = config.get_projects()
  local view_elements = get_view_elements_from(projects)

  if #view_elements == 0 then
    vim.notify("No projects to show", vim.log.levels.INFO)
    return
  end

  require("pwarp.view").show({
    title = "Projects",
    elements = view_elements,
    on_select = function(element)
      switch_project(element.value)
    end,
  })
end

-- Get project names
--- @return string[]
function M.get_project_names()
  local projects = config.get_projects()
  local names = {}
  for _, project in ipairs(projects) do
    table.insert(names, project.name)
  end

  return names
end

-- Jump to project with the provided name
--- @param name string
function M.go_to(name)
  local project = config.get_project(name)

  if project == nil then
    vim.notify("Project not found: " .. name, vim.log.levels.ERROR)
    return
  end

  switch_project(project)
end

return M
