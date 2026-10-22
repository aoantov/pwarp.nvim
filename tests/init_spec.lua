describe("pwarp", function()
  local pwarp = require("pwarp")
  local test_projects = {
    {
      name = "test",
      path = "/home",
    },
  }

  before_each(function()
    pwarp.setup({
      projects = {},
    })
  end)

  describe("config", function()
    local config = require("pwarp.config")
    it("when opts are nil, should not throw error and not setup", function()
      pwarp.setup()
      local projects = config.get_projects()
      assert.are_equal(0, #projects)
    end)
    it("when opts are {}, should not throw error and not setup", function()
      pwarp.setup({})
      local projects = config.get_projects()
      assert.are_equal(0, #projects)
    end)
    it("when opts have projects, should setup the projects in state", function()
      pwarp.setup({ projects = { { name = "test", path = "/home" } } })
      local projects = config.get_projects()
      assert.are_equal(1, #projects)
    end)
    it("when opts have projects,but config file is provided, config file has priority", function()
      local success = pcall(function()
        pwarp.setup({
          projects = test_projects,
          config = "./tests/cfg/cfg.json",
        })
      end)

      assert.are_equal(true, success)
      local expected_projects = config.get_projects()

      success = pcall(function()
        pwarp.setup({
          projects = test_projects,
          config = "./tests/cfg/cfg.json",
        })
      end)

      local projects = config.get_projects()
      assert.are_equal(true, success)
      assert.are_equal(#expected_projects, #projects)
    end)
  end)

  describe("general", function()
    it("when opts have projects,but is malformed, should throw error", function()
      local success = pcall(function()
        pwarp.setup({ projects = { { path = "/home" } } })
      end)
      assert.are_equal(false, success)
    end)
    it("when opts have projects,but path is malformed, should throw error", function()
      local success = pcall(function()
        pwarp.setup({ projects = { { name = "test", path = "fafs" } } })
      end)
      assert.are_equal(false, success)
    end)
    it("when config file path is not valid, should throw exception", function()
      local success = pcall(function()
        pwarp.setup({ config = "./tests/does_not_exist.json" })
      end)
      assert.are_equal(false, success)
    end)
  end)

  describe("manager", function()
    local manager = require("pwarp.manager")
    it("when get project names from manager, should return valid list", function()
      pwarp.setup({ projects = test_projects })

      local project_names = manager.get_project_names()

      assert.are_equal(1, #project_names)
      assert.are_equal("test", project_names[1])
    end)
  end)

  describe("session", function()
    local session = require("pwarp.session")
    local store_path = vim.fs.joinpath(vim.fn.stdpath("data"), "pwarp_buffers.json")
    local test_file_path = vim.fs.joinpath(vim.fn.getcwd(), "tests", "cfg", "cfg.json")

    function delete_open_bufs()
      for _, open_buf in ipairs(vim.api.nvim_list_bufs()) do
        vim.api.nvim_buf_delete(open_buf, { force = true })
      end
    end

    before_each(function()
      vim.fn.delete(store_path)
    end)

    it("when save session, should remember buffers", function()
      pwarp.setup({ projects = test_projects })

      local buf = vim.api.nvim_create_buf(true, false) -- (listed, scratch)
      vim.api.nvim_buf_set_name(buf, test_file_path)
      vim.api.nvim_set_current_buf(buf)

      session.save(test_projects[1])

      delete_open_bufs()
      session.restore(test_projects[1])

      local actual_buf_count = #vim.api.nvim_list_bufs()
      local actual_buf_path = vim.api.nvim_buf_get_name(0)

      delete_open_bufs()
      session.reset()
      session.restore(test_projects[1])

      assert.are_equal(2, actual_buf_count)
      assert.are_equal(test_file_path, actual_buf_path)
      assert.are_equal(1, #vim.api.nvim_list_bufs())
    end)
  end)
end)
