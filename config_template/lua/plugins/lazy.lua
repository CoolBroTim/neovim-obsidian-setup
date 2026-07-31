-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins from plugins directory
require("lazy").setup({
  spec = {
    { import = "plugins.colorscheme" },
    { import = "plugins.icons" },
    { import = "plugins.telescope" },
    { import = "plugins.treesitter" },
    { import = "plugins.obsidian" },
    { import = "plugins.render-markdown" },
    { import = "plugins.lsp" },
    { import = "plugins.which-key" },
    { import = "plugins.lualine" },
    { import = "plugins.autopairs" },
    { import = "plugins.dressing" },
    { import = "plugins.noice" },
    { import = "plugins.todo-comments" },
    { import = "plugins.comment" },
    { import = "plugins.markdown-preview" },
  },
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { "tokyonight" },
  },
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
