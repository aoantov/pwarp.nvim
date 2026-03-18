return {
  -- nui.nvim can be lazy loaded
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim" },
  {
    dir = "~/projects/pwarp.nvim",
    lazy = false,
    opts = {
      projects = {
        { name = "Playground", path = "~/projects/playground" },
        { name = "Jirarc", path = "~/projects/jirarc" },
        { name = "GSRunner", path = "~/projects/gs-runner" },
        { name = "Lazyvim", path = "~/lazynvim" },
        { name = "PWarp", path = "~/projects/pwarp.nvim" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
  },
}
