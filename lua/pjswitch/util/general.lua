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

return M
