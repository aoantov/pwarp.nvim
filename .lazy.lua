return {
  { "nvim-lua/plenary.nvim", lazy = false },
  { "nvim-telescope/telescope.nvim" },
  {
    dir = "../pwarp.nvim",
    lazy = false,
    opts = {
      projects = {},
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
  },
}
