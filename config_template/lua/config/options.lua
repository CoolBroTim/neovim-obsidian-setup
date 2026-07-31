local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance & Colors
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = true

-- Conceal level for Obsidian wikilinks and rendering (shows [[Link]] nicely)
opt.conceallevel = 2

-- System integration & History
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300

-- Split windows naturally
opt.splitbelow = true
opt.splitright = true

-- Telescope Treesitter compatibility shim for Neovim 0.10+
local ok_parsers, ts_parsers = pcall(require, "nvim-treesitter.parsers")
if ok_parsers and ts_parsers and not ts_parsers.ft_to_lang then
  ts_parsers.ft_to_lang = vim.treesitter.language.get_lang or function(ft) return ft end
end
