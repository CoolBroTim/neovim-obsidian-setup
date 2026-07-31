return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>nn", "<cmd>ObsidianNew<cr>", desc = "New Obsidian Note" },
    { "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian Notes" },
    { "<leader>nt", "<cmd>ObsidianTags<cr>", desc = "Search Obsidian Tags" },
    { "<leader>no", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian App" },
    { "<leader>nl", "<cmd>ObsidianLink<cr>", desc = "Link Text to Note" },
    { "<leader>nT", "<cmd>ObsidianTemplate<cr>", desc = "Insert Obsidian Template" },
  },
  opts = {
    workspaces = {
      {
        name = "Notes",
        path = "/home/timothy/Notes",
      },
    },
    daily_notes = {
      folder = "Daily",
      date_format = "%Y-%m-%d",
      template = nil,
    },
    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 2,
    },
    new_notes_location = "notes_subdir",
    notes_subdir = "00-Inbox",
    wiki_link_func = "use_alias_only",
    preferred_link_style = "wiki",

    -- Keep human-readable titles as filenames
    note_id_func = function(title)
      if title ~= nil then
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        return tostring(os.time())
      end
    end,

    -- Basic UI concealment for wikilinks
    ui = {
      enable = true,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
      },
    },
  },
}
