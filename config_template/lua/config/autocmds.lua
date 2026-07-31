local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local note_group = augroup("MarkdownAutoSave", { clear = true })

-- Auto-save Markdown files on InsertLeave or FocusLost
autocmd({ "InsertLeave", "FocusLost" }, {
  group = note_group,
  pattern = "*.md",
  callback = function()
    if vim.bo.modified and vim.bo.filetype == "markdown" then
      vim.cmd("silent! write")
    end
  end,
})

-- Silently pull GitHub updates on Neovim startup
autocmd("VimEnter", {
  group = augroup("GitAutoPull", { clear = true }),
  callback = function()
    vim.fn.jobstart({ "git", "-C", vim.fn.expand("~/Notes"), "pull", "--rebase" }, {
      detach = true,
      on_exit = function(_, code)
        if code == 0 then
          vim.schedule(function()
            vim.notify("Notes vault synced with GitHub", vim.log.levels.INFO, { title = "Git Auto-Pull" })
          end)
        end
      end,
    })
  end,
})
