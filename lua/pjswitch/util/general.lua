local M = {}

--- Check if provided folder/file exists
--- @param path string
--- @return boolean
function M.does_path_exist(path)
  local stat = vim.uv.fs_stat(vim.fs.abspath(path))

  if stat then
    return true
  end
  return false
end

--- @param params table<any,string>
function M.check_types(params)
  for value, expectedType in pairs(params) do
    if type(value) ~= expectedType then
      error("Invalid parameter type")
    end
  end
end

return M
