local GeneralUtils = require("pjswitch.util.general")

local M = {}

local function are_opts_present(opts)
  return opts ~= nil
end

local function are_opts_disabled(opts)
  return opts.enabled == false
end

local function validate_projects(projects)
  if projects == nil then
    error("Invalid projects")
  end

  for index = 1, #projects do
    if projects[index].name == nil or projects[index].path == nil then
      error("Invalid project")
    end

    if not GeneralUtils.does_path_exist(projects[index].path) then
      error("Invalid project")
    end
  end
end

--- @param opts Opts
function M.validate_opts(opts)
  if are_opts_disabled(opts) or not are_opts_present(opts) then
    return
  end

  validate_projects(opts.projects)
end

return M
