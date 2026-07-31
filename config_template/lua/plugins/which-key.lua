return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    preset = "modern",
    spec = {
      { "<leader>f", group = "Find & Files" },
      { "<leader>n", group = "Notes & Obsidian" },
      { "<leader>g", group = "Git Synchronization" },
      { "<leader>a", group = "AI Automation" },
      { "<leader>c", group = "Code & Clear" },
      { "<leader>gp", desc = "Push Notes to Remote Git" },
      { "<leader>gc", desc = "Configure Git Remote & Auth" },
      { "<leader>ai", desc = "Sort Notes with AI" },
      { "<leader>ac", desc = "Configure AI Sorter Wizard" },
    },
  },
}
