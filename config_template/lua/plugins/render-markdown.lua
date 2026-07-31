return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = { "markdown" },
    heading = {
      enabled = true,
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      enabled = true,
      sign = false,
      style = "full",
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = " " },
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
  },
  ft = { "markdown" },
}
