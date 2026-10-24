return {
  { "nvim-lua/plenary.nvim", lazy = false },
  { "nvim-telescope/telescope.nvim" },
  {
    dir = "../pwarp.nvim",
    keys = {
      {
        "<leader>sp",
        function()
          require("pwarp").list()
        end,
        desc = "List projects",
      },
    },
    lazy = false,
    opts = {
      projects = {},
      retain_bufs = true,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
  },
}
