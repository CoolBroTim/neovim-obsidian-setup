return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      enabled = true,
      default_prompt = "Input:",
      title_pos = "center",
      border = "rounded",
      win_options = {
        winblend = 10,
      },
    },
    select = {
      enabled = true,
      backend = { "telescope", "builtin" },
    },
  },
}
