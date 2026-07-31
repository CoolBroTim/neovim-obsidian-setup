return {
  "nvim-treesitter/nvim-treesitter",
  version = "^0.9.0",
  build = ":TSUpdate",
  lazy = false,
  opts = {
    ensure_installed = { "markdown", "markdown_inline", "bash", "lua", "python", "yaml", "json" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "markdown" },
    },
    indent = { enable = true },
  },
  config = function(_, opts)
    local p_ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if p_ok and parsers then
      parsers.ft_to_lang = function(ft)
        if not ft then return nil end
        return (vim.treesitter.language and vim.treesitter.language.get_lang and vim.treesitter.language.get_lang(ft)) or ft
      end
    end

    local status, configs = pcall(require, "nvim-treesitter.configs")
    if status and configs then
      configs.is_enabled = configs.is_enabled or function() return true end
      configs.get_module = configs.get_module or function() return {} end
      configs.setup(opts)
    end
  end,
}
