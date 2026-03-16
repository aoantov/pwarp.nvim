local Config = require("pjswitch.config")

local M = {}

--- @alias OptsProject {name: string, path: string}
--- @class Opts
--- @field enabled boolean
--- @field projects OptsProject[]
--- @param opts? Opts
function M.setup(opts)
  Config.setup(opts)
end

-- List configured projects
function M.list()
  if Config.are_projects_empty() then
    return
  end

  local projects = Config.get_projects()

  print("Not implemented")
  -- View.present(projects)
end

-- Move to project with the given name
--- @param name string
function M.goto(name)
  local project = Config.get_project(name)
  if project == nil then
    print("Cannot find project with name" .. name)
    return
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- TODO: change to store previous buffers per project
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.cmd("cd " .. project.path)
end

return M
