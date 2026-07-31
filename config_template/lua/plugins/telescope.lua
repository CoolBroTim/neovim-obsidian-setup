return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  cmd = "Telescope",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files cwd=/home/timothy/Notes<cr>", desc = "Find Notes Files" },
    { "<leader>fg", "<cmd>Telescope live_grep cwd=/home/timothy/Notes<cr>", desc = "Grep Text in Notes" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Open Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find Help Tags" },
  },
  opts = {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "truncate" },
      file_ignore_patterns = { "%.git/", "%.obsidian/" },
    },
  },
  config = function(_, opts)
    local p_ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if p_ok and parsers then
      parsers.ft_to_lang = function(ft)
        if not ft then return nil end
        return (vim.treesitter.language and vim.treesitter.language.get_lang and vim.treesitter.language.get_lang(ft)) or ft
      end
    end

    local c_ok, configs = pcall(require, "nvim-treesitter.configs")
    if c_ok and configs then
      configs.is_enabled = configs.is_enabled or function() return true end
      configs.get_module = configs.get_module or function() return {} end
    end

    require("telescope").setup(opts)
  end,
}
