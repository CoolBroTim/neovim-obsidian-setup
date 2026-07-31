return {
  -- Completion Engine (blink.cmp)
  {
    "Saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },

  -- LSP Configuration & Mason auto-downloader
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "Saghen/blink.cmp",
    },
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "marksman" },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Setup marksman LSP for Markdown
      lspconfig.marksman.setup({
        capabilities = capabilities,
      })
    end,
  },
}
