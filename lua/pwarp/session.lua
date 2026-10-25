local M = {}

--- @alias SessionStore  table<string, {files: string[], current?: string}>
local session_state = {}

local store_path = vim.fs.joinpath(vim.fn.stdpath("data"), "pwarp_buffers.json")

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

local function reset_store()
  local code = vim.fn.delete(store_path)

  if code == 0 then
    vim.notify("Session store reset: success", vim.log.levels.INFO)
  else
    vim.notify("Session store reset: failed", vim.log.levels.ERROR)
  end
end

local function save_store()
  write_store(session_state)
end

--- @param project Project
--- @return string
local function gen_key(project)
  return project.name
end

--- @param buf number
--- @return boolean
local function is_buf_valid(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  return vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and name ~= "" and vim.uv.fs_stat(name) ~= nil
end

--- @param project Project
local function save_project(project)
  local files = {}
  local current = vim.api.nvim_buf_get_name(0)

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if is_buf_valid(buf) then
      table.insert(files, name)
    end
  end

  local key = gen_key(project)

  session_state[key] = { files = files, current = current }
end

local function save_current_project()
  local project = require("pwarp.config").get_project_by_path(vim.fn.getcwd())
  if project ~= nil then
    save_project(project)
  end
end

--- @param project Project
local function restore_project(project)
  local entry = session_state[gen_key(project)]
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

local function restore_current_project()
  local project = require("pwarp.config").get_project_by_path(vim.fn.getcwd())
  if project ~= nil then
    restore_project(project)
  end
end

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("PWarp", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      save_current_project()
      save_store()
    end,
    desc = "Save the current project on exit",
  })

  vim.api.nvim_create_autocmd("UIEnter", {
    group = group,
    callback = function()
      restore_current_project()
    end,
    desc = "Restore the current project on enter",
  })

  vim.api.nvim_create_user_command("WarpBuffReset", function()
    session_state = {}
    reset_store()
  end, {
    desc = "Reset the buffer store for all projects",
  })
end

--- @alias SessionOpts {store_path?: string} | nil
--- @param opts SessionOpts
function M.setup(opts)
  if opts and opts.store_path then
    store_path = opts.store_path
  end

  session_state = read_store()
  setup_autocmds()
end

--- @param project Project
function M.save(project)
  save_project(project)
end

--- @param project Project
function M.restore(project)
  restore_project(project)
end

function M.reset()
  session_state = {}
  reset_store()
end

return M
