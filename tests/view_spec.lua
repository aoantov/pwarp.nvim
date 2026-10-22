describe("pwarp.view", function()
  local pickers = require("telescope.pickers")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local view = require("pwarp.view")

  local original_new = pickers.new
  local original_get_selected = action_state.get_selected_entry
  local original_close = actions.close
  local captured

  before_each(function()
    captured = nil
    pickers.new = function(_, spec)
      captured = spec
      return { find = function() end }
    end
  end)

  after_each(function()
    pickers.new = original_new
    action_state.get_selected_entry = original_get_selected
    actions.close = original_close
  end)

  it("opens a picker with the given title and mapped entries", function()
    view.show({
      title = "Projects",
      on_select = function() end,
      elements = { { name = "alpha", value = "/a" }, { name = "beta", value = "/b", ordinal = "zeta" } },
    })

    assert.is_not_nil(captured)
    assert.are_equal("Projects", captured.prompt_title)

    local entry_maker = captured.finder.entry_maker
    local first = entry_maker({ name = "alpha", value = "/a" })
    assert.are_equal("/a", first.value)
    assert.are_equal("alpha", first.display)
    assert.are_equal("alpha", first.ordinal)
    assert.are_equal("zeta", entry_maker({ name = "beta", value = "/b", ordinal = "zeta" }).ordinal)
  end)

  describe("select action", function()
    local function open(on_select)
      view.show({ title = "t", on_select = on_select, elements = {} })
      local replaced
      local map_actions = { select_default = {
        replace = function(_, fn)
          replaced = fn
        end,
      } }
      local original = actions.select_default
      actions.select_default = map_actions.select_default
      local result = captured.attach_mappings(1)
      actions.select_default = original
      return result, replaced
    end

    it("calls on_select with the selected entry and closes the prompt", function()
      local selected, closed
      actions.close = function(buf)
        closed = buf
      end
      action_state.get_selected_entry = function()
        return { value = "/a" }
      end

      local result, handler = open(function(entry)
        selected = entry
      end)
      handler()

      assert.is_true(result)
      assert.are_equal(1, closed)
      assert.are_equal("/a", selected.value)
    end)

    it("does not call on_select when nothing is selected", function()
      local called = false
      actions.close = function() end
      action_state.get_selected_entry = function()
        return nil
      end

      local _, handler = open(function()
        called = true
      end)
      handler()

      assert.is_false(called)
    end)
  end)
end)
