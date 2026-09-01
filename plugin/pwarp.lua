vim.api.nvim_create_user_command("Warp", function()
  require("pwarp").list()
end, {})

vim.api.nvim_create_user_command("WarpTo", function(opts)
  require("pwarp").go_to(opts.args)
end, { nargs = 1 })
