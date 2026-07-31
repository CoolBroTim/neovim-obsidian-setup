# 🚀 Neovim + Obsidian Cross-Platform Note-Taking Setup

A fast, modular, 100% Pure Lua **Neovim** configuration paired with **Obsidian** for cross-platform note-taking (Linux, macOS, iOS, Android).

All notes are stored as plain Markdown (`.md`) files in a Git repository, ensuring complete data ownership with zero subscription fees or proprietary lock-in.

---

## ⚡ Quick One-Line Installation (Linux)

Open your terminal and run:

```bash
curl -sSL https://raw.githubusercontent.com/CoolBroTim/neovim-obsidian-setup/main/install.sh | bash
```

The interactive installer will:
1. Ask where you want your Notes vault stored (Default: `~/Notes`).
2. Ask for your preferred terminal emulator (`kitty`, `alacritty`, `foot`, etc.).
3. Back up any existing Neovim config.
4. Deploy the complete Pure Lua Neovim configuration and PARA vault structure.
5. Create the `notes` terminal alias and `Notes Vault` desktop launcher for **Rofi**, **Wofi**, and **Hyprlauncher**.

---

## ✨ Features Breakdown

* **⚡ Ultra-Fast Startup:** Powered by `lazy.nvim` with lazy-loading (<15ms startup time).
* **🎨 Centered Floating Cmdline:** Centered floating `:` command line and `/` search box via `noice.nvim` + `nui.nvim` (LazyVim style).
* **📖 Visual Markdown Rendering:** In-buffer styling for headings, checkboxes (`[ ]` / `[x]`), callouts (`> [!NOTE]`), and code block borders via `render-markdown.nvim`.
* **💎 Obsidian Integration:** Wikilinks (`[[Link]]`), tags, daily note generator (`<Space>nd`), and open in Obsidian GUI (`<Space>no`) via `obsidian.nvim`.
* **🧠 LSP & Completion:** Powered by `blink.cmp` and `marksman` Markdown Language Server for auto-completion and link verification.
* **🏷️ Task Badges & Search:** Color-coded `TODO:`, `FIXME:`, `NOTE:`, and `WARNING:` badges with fuzzy search across vault tasks (`<Space>ft`).
* **🌐 Live Browser Preview:** Press `<Space>mp` to launch real-time Markdown preview in your web browser.
* **🤖 AI Note Sorter:** Press `<Space>ai` to automatically organize `00-Inbox/` notes into PARA folders and commit/push to Git.
* **🚀 Instant Git Sync:** Press `<Space>gp` to stage all additions, edits, and deletions, commit them, and push to GitHub.
* **📜 Interactive Cheat Sheet:** Press `<Space>h` anytime inside Neovim for a floating shortcut helper window.

---

## ⌨️ Neovim Keymaps Reference

**Leader Key:** `<Space>` (Spacebar)

| Shortcut | Action | Description |
|---|---|---|
| `<Space>h` | **Cheat Sheet** | Interactive floating shortcut helper |
| `<Space>nd` | **Daily Note** | Create / Open today's note (`YYYY-MM-DD.md`) |
| `<Space>ft` | **Search TODOs** | Fuzzy search all `TODO:`, `FIXME:`, `NOTE:` tasks across vault |
| `<Space>mp` | **Browser Preview** | Toggle live browser preview |
| `<Space>gp` | **Git Sync** | Stage, commit, and push vault to GitHub |
| `<Space>ai` | **AI Sorter** | Categorize `00-Inbox/` notes into PARA folders & push to GitHub |
| `<Space>ff` | **Find File** | Fuzzy search note filenames in vault |
| `<Space>fg` | **Grep Text** | Live search text inside notes |
| `<Space>nn` | **New Note** | Prompt to create a new Obsidian note |
| `<Space>no` | **Open in Obsidian** | Open current note in official Obsidian GUI app |
| `gcc` | **Comment Line** | Toggle line comment (`<!-- comment -->`) |
| `gf` | **Follow Link** | Follow `[[Wikilink]]` under cursor |
| `<Tab>` | **Toggle Checkbox** | Toggle `- [ ]` $\leftrightarrow$ `- [x]` |

---

## 📁 PARA Vault Directory Structure

```text
~/Notes/
├── 00-Inbox/        # Scratchpad for quick daily captures & unorganized thoughts
├── 10-Projects/     # Active projects with deadlines
├── 20-Areas/        # Long-term life responsibilities (Health, Finance, Work)
├── 30-Resources/    # References, manuals, cheat-sheets, guides
├── 40-Archive/      # Completed or inactive notes
├── Daily/           # Daily journal logs (YYYY-MM-DD.md)
├── Templates/       # Reusable note templates
└── scripts/         # Automation scripts (sort_notes.py)
```

---

## 📱 Mobile Syncing (iPhone / Android)

1. Connect your local vault to a private GitHub repository:
   ```bash
   cd ~/Notes
   git remote add origin git@github.com:YOUR_USERNAME/notes.git
   git push -u origin main
   ```
2. Open **Obsidian** on iOS/Android.
3. Install the **Obsidian Git** community plugin.
4. Add your GitHub remote URL & Personal Access Token. Set Auto-Pull/Push to `5` minutes.

---

## 📄 License

[MIT License](LICENSE) — Feel free to use, modify, and share!
