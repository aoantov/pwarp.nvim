local config = require("pwarp.config")

local M = {}

--- @param project Project
local function generate_view_element_name(project)
  local elem_path = string.sub(project.path,-30)
  if #elem_path < #project.path then
    elem_path = '...' .. elem_path
  end

  return project.name .. ": " .. elem_path
end

--- @param projects Project[]
local function get_view_elements_from(projects)
  local cwd = vim.fn.getcwd()

  local elements = {}
  local element_name
  for i=1, #projects do
    if cwd ~= vim.fs.abspath(projects[i].path) then
      element_name = generate_view_element_name(projects[i])
      table.insert(elements, {
        name = element_name,
        value = projects[i],
        ordinal = projects[i].name
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

--- @param path string
local function close_buffs_and_goto(path)
  close_buffers()
  vim.cmd("cd " .. path)
end

-- List projects
function M.list()
  if config.are_projects_empty() then
    print('No projects to list')

    return
  end

  local projects = config.get_projects()
  local view_elements = get_view_elements_from(projects)

  require("pwarp.view").show({
    title = "Projects",
    elements = view_elements,
    on_select = function (element)
      close_buffs_and_goto(element.value.path)
    end
  })
end

-- Jump to project with the provided name
--- @param name string
function M.goto(name)
  local project = config.get_project(name)

  if project == nil then
    print("No project named '" .. name .. "'")
    return
  end

  close_buffs_and_goto(project.path)
end


return M
