local M = {}

local store_path = vim.fs.joinpath(vim.fn.stdpath("data"), "pwarp_buffers.json")

--- @alias SessionStore  table<string, {files: string[], current?: string}>
--- @return SessionStore
local function read_store()
  local file = io.open(store_path, "r")

  if file == nil then
    return {}
  end

  local content = file:read("*a")
  file:close()

  local ok, decoded = pcall(vim.json.decode, content)
  if not ok or type(decoded) ~= "table" then
    return {}
  end

  return decoded
end

--- @param store SessionStore
local function write_store(store)
  local file = io.open(store_path, "w")
  if file == nil then
    return
  end

  file:write(vim.json.encode(store))
  file:close()
end

--- @param project Project
local function get_key(project)
  return project.name
end

-- Save listed file buffers of the rurrent session for the project
--- @param project Project
function M.save(project)
  local files = {}
  local current = vim.api.nvim_buf_get_name(0)

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and name ~= "" and vim.uv.fs_stat(name) ~= nil then
      table.insert(files, name)
    end
  end

  local store = read_store()
  local key = get_key(project)
  store[key] = nil

  if #files > 0 then
    store[key] = { files = files, current = current }
  end

  write_store(store)
end

--- @param project Project
function M.restore(project)
  local entry = read_store()[get_key(project)]
  if entry == nil then
    return
  end

  for _, file in ipairs(entry.files or {}) do
    if vim.uv.fs_stat(file) ~= nil then
      vim.cmd.badd(vim.fn.fnameescape(file))
    end
  end

  if entry.current and vim.uv.fs_stat(entry.current) ~= nil then
    vim.cmd.edit(vim.fn.fnameescape(entry.current))
  end
end

return M
