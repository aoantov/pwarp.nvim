local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

local M = {}

--- @alias ActionOpts {on_select: function}
--- @param opts ActionOpts
local function create_select_action(opts)
  return function(prompt_buf)
    actions.select_default:replace(function()
      actions.close(prompt_buf)
      local selected_element = action_state.get_selected_entry()

      if selected_element ~= nil then
        opts.on_select(selected_element)
      end
    end)
    return true
  end
end

--- @alias ViewDropdownOpts {attach_actions: function, title: string, elements: ViewElement[] }
--- @param opts ViewDropdownOpts
local function create_dropdown(opts)
  return function()
    local ts_opts = require("telescope.themes").get_dropdown({})

    pickers
      .new(ts_opts, {
        attach_mappings = opts.attach_actions,
        prompt_title = opts.title,
        finder = finders.new_table({
          results = opts.elements,
          entry_maker = function(element)
            return {
              value = element.value,
              display = element.name,
              ordinal = element.ordinal or element.name,
            }
          end,
        }),
        sorter = conf.generic_sorter(opts),
      })
      :find()
  end
end

--- @alias ViewElement {name: string, value: unknown, ordinal?: string}
--- @alias ViewOpts {title: string, on_select: function, elements: ViewElement[]}
--- @param opts ViewOpts
--- TODO: change it so that it does not create the objects every call
function M.show(opts)
  local attach_actions = create_select_action({
    on_select = opts.on_select,
  })

  local show_dropdown = create_dropdown({
    title = opts.title,
    attach_actions = attach_actions,
    elements = opts.elements,
  })

  show_dropdown()
end

return M
