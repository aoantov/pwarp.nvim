local config = require("pwarp.config")

local M = {}

--- @param projects Project[]
local function projects_to_view_elements(projects)
  local path_length_limit = 30
  local elements = {}

  for i=1,#projects do
    table.insert(elements, {
      name = projects[i].name .. ": " .. string.sub(projects[i].path, path_length_limit*-1),
      value = projects[i]
    })
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
    return
  end

  local projects = config.get_projects()
  local view_elements = projects_to_view_elements(projects)

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
