return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup", -- Centered floating popup command line (LazyVim style!)
      opts = {},
      format = {
        cmdline = { icon = " ", lang = "vim" },
        search_down = { icon = " ", lang = "regex" },
        search_up = { icon = " ", lang = "regex" },
        filter = { icon = " ", lang = "bash" },
        lua = { icon = " ", lang = "lua" },
        help = { icon = " ", lang = "vim" },
      },
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    views = {
      cmdline_popup = {
        position = {
          row = "40%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "NormalFloat",
            FloatBorder = "FloatBorder",
          },
        },
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
  },
}
