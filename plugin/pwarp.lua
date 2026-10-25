vim.api.nvim_create_user_command("Warp", function()
  require("pwarp").list()
end, {
  desc = "List all projects and warp to one",
})

vim.api.nvim_create_user_command("WarpTo", function(opts)
  require("pwarp").go_to(opts.args)
end, {
  nargs = 1,
  desc = "Warp to a specific project by name",
  complete = function(arg_lead)
    local projects = require("pwarp.manager").get_project_names()
    local matches = {}

    for _, project in ipairs(projects) do
      if project:find("^" .. arg_lead) then
        table.insert(matches, project)
      end
    end
    return matches
  end,
})
