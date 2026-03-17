local config = require("pjswitch.config")

local M = {}

--- @param projects Project[]
local function projects_to_view_elements(projects)
  local view_elements = {}
  for i=1,#projects do
    table.insert(view_elements, {
      name = projects[i].name,
      value = projects[i]
    })
  end

  return view_elements
end

local function clean_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

--- @param path string
local function move_to(path)
  vim.cmd("cd " .. path)
end

-- List projects
function M.list()
  if config.are_projects_empty() then
    return
  end

  local projects = config.get_projects()
  local view_elements = projects_to_view_elements(projects)

  require("pjswitch.view").show({
    title = "Projects",
    elements = view_elements,
    on_select = function (element)
      clean_buffers()
      move_to(element.value.path)

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

  clean_buffers()
  move_to(project.path)
end

return M
