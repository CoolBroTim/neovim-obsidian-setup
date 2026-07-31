local M = {}

local help_text = [=[
==============================================================================
               NEOVIM & OBSIDIAN QUICK CHEAT SHEET (<Space>h)
==============================================================================

  NOTE-TAKING & OBSIDIAN SHORTCUTS
  --------------------------------------------------------------------------
  <Space>nd     Create or Open TODAY'S DAILY NOTE (Auto-saved)
  <Space>gp     PUSH note commits directly to GitHub remote
  <Space>ff     Find Note File by name (Telescope fuzzy finder)
  <Space>fg     Find Text / Live Grep across all notes in vault
  <Space>ft     Search all TODO:, FIXME:, NOTE: tasks across vault
  <Space>mp     Toggle LIVE BROWSER MARKDOWN PREVIEW
  <Space>nn     Create a NEW Note (prompts for title)
  <Space>ns     Search Note Titles (Obsidian search)
  <Space>nt     Search Note Tags (Obsidian tags)
  <Space>no     Open current note in Obsidian Desktop GUI App
  <Space>ai     Run Gemini AI script to auto-sort notes & auto-push to GitHub
  gf            Follow Wikilink under cursor (e.g. opens [[My Note]])
  <Tab>         Toggle Markdown Checkbox ([ ] <-> [x])
  gcc           Comment / Uncomment line (adds <!-- comment -->)

  ESSENTIAL VIM NAVIGATION (Beyond hjkl)
  --------------------------------------------------------------------------
  w             Jump FORWARD to start of next word
  b             Jump BACKWARD to start of previous word
  e             Jump to END of current word
  0 (Zero)      Jump to START of line
  $             Jump to END of line
  gg            Jump to TOP of document
  G             Jump to BOTTOM of document
  Ctrl + d      Scroll DOWN half a page
  Ctrl + u      Scroll UP half a page

  EDITING & DELETING SHORTCUTS
  --------------------------------------------------------------------------
  i             Enter Insert mode at cursor
  a             Enter Insert mode AFTER cursor
  o             Open a new line BELOW and enter Insert mode
  O             Open a new line ABOVE and enter Insert mode
  x             Delete single character under cursor
  dw            Delete current word
  dd            Delete entire line
  cw            Change word (deletes word and enters Insert mode)
  ciw           Change INNER word (works anywhere inside the word!)
  ci"           Change content inside double quotes
  u             UNDO last change
  Ctrl + r      REDO last change

  COPY, PASTE & VISUAL SELECTION
  --------------------------------------------------------------------------
  v             Start Visual selection (select character by character)
  V             Start Visual Line selection (select line by line)
  y             Yank (copy) selected text
  p             Paste copied text AFTER cursor
  P             Paste copied text BEFORE cursor
  Esc           Return to Normal mode

==============================================================================
                    Press <Esc> or 'q' to close this window
==============================================================================
]=]

function M.show()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.split(help_text, "\n")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = math.min(84, vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Neovim & Obsidian Cheat Sheet ",
    title_pos = "center",
  })

  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"

  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command("HelpSheet", M.show, {})

return M
