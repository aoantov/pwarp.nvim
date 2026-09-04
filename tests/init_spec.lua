describe("pwarp", function()
  local config = require("pwarp.config")
  local pwarp = require("pwarp")
  local stub = require("luassert.stub")

  before_each(function()
    -- reset state
    pwarp.setup({
      enabled = true,
      projects = {},
    })
  end)
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
  it("when opts are {enabled = false}, should not throw error and not setup", function()
    pwarp.setup({ enabled = false })
    local projects = config.get_projects()
    assert.are_equal(0, #projects)
  end)
  it("when opts are {enabled = true}, should not throw error and not setup", function()
    pwarp.setup({})
    local projects = config.get_projects()
    assert.are_equal(0, #projects)
  end)
  it("when opts have projects, should setup the projects in state", function()
    pwarp.setup({ projects = { { name = "test", path = "/home" } } })
    local projects = config.get_projects()
    assert.are_equal(1, #projects)
  end)
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
  it("when opts have projects,but config file is provided, config file has priority", function()
    local success = pcall(function()
      pwarp.setup({
        projects = {
          {
            name = "Some",
            path = "./tests",
          },
        },
        config = "./tests/cfg/cfg.json",
      })
    end)

    assert.are_equal(true, success)
    local expected_projects = config.get_projects()

    success = pcall(function()
      pwarp.setup({
        projects = {
          {
            name = "Some",
            path = "./tests",
          },
        },
        config = "./tests/cfg/cfg.json",
      })
    end)

    local projects = config.get_projects()
    assert.are_equal(true, success)
    assert.are_equal(#expected_projects, #projects)
  end)
  it("when config file path is not valid, should throw exception", function()
    local success = pcall(function()
      pwarp.setup({ config = "./tests/does_not_exist.json" })
    end)
    assert.are_equal(false, success)
  end)
  it("when disabled by config, should not setup projects", function()
    local success = pcall(function()
      pwarp.setup({ config = "./tests/cfg/disabled_cfg.json" })
    end)
    local projects = config.get_projects()

    assert.are_equal(true, success)
    assert.are_equal(0, #projects)
  end)
  -- TODO: add go_to tests
end)
