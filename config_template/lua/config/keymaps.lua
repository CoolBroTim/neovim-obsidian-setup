local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Toggle Cheat Sheet Help Window (<Space>h)
keymap("n", "<leader>h", function()
  require("config.cheat_sheet").show()
end, vim.tbl_extend("force", opts, { desc = "Toggle Help Cheat Sheet" }))

-- File Browser
keymap("n", "<leader>e", "<cmd>Explore<CR>", vim.tbl_extend("force", opts, { desc = "Explore Files" }))

-- Clear Search Highlights
keymap("n", "<leader>ch", "<cmd>nohlsearch<CR>", vim.tbl_extend("force", opts, { desc = "Clear Search Highlights" }))

-- DAILY NOTE SHORTCUT (<Space>nd)
-- Automatically creates/opens today's note (named YYYY-MM-DD.md in ~/Notes/Daily/)
keymap("n", "<leader>nd", function()
  local daily_dir = vim.fn.expand("~/Notes/Daily")
  if vim.fn.isdirectory(daily_dir) == 0 then
    vim.fn.mkdir(daily_dir, "p")
  end
  local date_str = os.date("%Y-%m-%d")
  local file_path = daily_dir .. "/" .. date_str .. ".md"
  
  -- Create file with header if it doesn't exist yet
  if vim.fn.filereadable(file_path) == 0 then
    local f = io.open(file_path, "w")
    if f then
      f:write("# Daily Note: " .. date_str .. "\n\n## Tasks\n- [ ] \n\n## Notes\n\n")
      f:close()
    end
  end
  
  vim.cmd("edit " .. vim.fn.fnameescape(file_path))
  vim.notify("Opened Daily Note: " .. date_str, vim.log.levels.INFO)
end, vim.tbl_extend("force", opts, { desc = "Create / Open Today's Daily Note" }))

-- Quick save shortcut (<Space>w or Ctrl+s)
keymap("n", "<leader>w", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Save File" }))
keymap("n", "<C-s>", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Save File" }))

-- Search TODOs across vault (<Space>ft)
keymap("n", "<leader>ft", "<cmd>TodoTelescope<CR>", vim.tbl_extend("force", opts, { desc = "Search Vault TODOs" }))

-- Toggle Live Browser Markdown Preview (<Space>mp)
keymap("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", vim.tbl_extend("force", opts, { desc = "Toggle Live Browser Preview" }))

-- Git Sync Shortcut (<Space>gp) -> Stages all additions/deletions, commits, and pushes to GitHub
keymap("n", "<leader>gp", "<cmd>!git -C /home/timothy/Notes add -A && (git -C /home/timothy/Notes commit -m 'Sync notes' || true) && git -C /home/timothy/Notes push<CR>", vim.tbl_extend("force", opts, { desc = "Commit and Push Notes to GitHub" }))

-- Run Gemini AI Note Sorting Script (<Space>ai)
keymap("n", "<leader>ai", "<cmd>!/home/timothy/Notes/scripts/sort_notes.py<CR>", vim.tbl_extend("force", opts, { desc = "Sort Notes with AI" }))

-- Configure AI Sorter Provider Wizard (<Space>ac) -> Opens split terminal in insert mode
keymap("n", "<leader>ac", function()
  vim.cmd("split | terminal python3 /home/timothy/Notes/scripts/sort_notes.py --config")
  vim.cmd("startinsert")
end, vim.tbl_extend("force", opts, { desc = "Configure AI Sorter Wizard" }))
