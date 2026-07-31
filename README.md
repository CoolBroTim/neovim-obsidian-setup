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
2. Ask for your preferred terminal emulator (`kitty`, `alacritty`, `foot`, `konsole`, etc.).
3. Back up any existing Neovim config.
4. Deploy the complete Pure Lua Neovim configuration and PARA vault structure.
5. Create the `notes` terminal alias and `Notes Vault` desktop launcher for **Rofi**, **Wofi**, and **Hyprlauncher**.

---

## 🎯 Post-Installation: Getting Started (Step-by-Step)

Follow these simple steps after running `install.sh`:

### 1. Launch Your Notes Vault
* **From Terminal:** Type `notes` and press Enter.
* **From App Launcher:** Open **Rofi**, **Wofi**, or **Hyprlauncher** and search for `Notes Vault`.

### 2. View the Built-In Cheat Sheet (`<Space>h`)
* Inside Neovim, press **`<Space>h`** anytime to open an interactive floating cheat sheet listing all shortcuts and navigation commands. Press `q` or `<Esc>` to close it.

### 3. Configure Your AI Note Sorter (`<Space>ac`)
* Press **`<Space>ac`** to open the interactive AI Provider Setup Wizard in a split terminal window.
* Select your preferred classification engine:
  * **Option 6 (Default):** Fast Rule-Based NLP Classifier (Zero setup required, works offline immediately).
  * **Option 1:** Cloud API Key (Paste your Google Gemini, OpenAI `gpt-4o-mini`, or Anthropic `claude-3-5-haiku` key).
  * **Option 2:** Google Antigravity CLI (`agy run --model gemini-3.6-flash`).
  * **Option 3:** Codex CLI (`codex exec --model gpt-4o-mini`).
  * **Option 4:** Claude Code CLI (`claude -p --model claude-3-5-haiku`).
  * **Option 5:** Ollama Local LLM (`qwen2.5:0.5b` or any model of your choice — 100% private offline AI).

### 4. Daily Note Workflow (`<Space>nd`)
* Press **`<Space>nd`** to instantly create or open today's daily journal log (`Daily/YYYY-MM-DD.md`) pre-populated with task checkboxes and notes sections.

### 5. Capture & AI Auto-Sorting (`<Space>ai`)
* Drop quick scratchpad notes, meeting logs, or code snippets in `00-Inbox/`.
* Press **`<Space>ai`** to automatically classify and move your inbox notes into PARA folders (`10-Projects/`, `20-Areas/`, `30-Resources/`, `40-Archive/`) and commit/push the updates to Git!

### 6. Git Synchronization (`<Space>gp`)
* Press **`<Space>gp`** anytime to stage, commit, and push all vault changes directly to your GitHub/GitLab remote repository.

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
* **⚙️ AI Provider Wizard:** Press `<Space>ac` to switch between Gemini, OpenAI, Claude, Antigravity, Ollama, or local rule-based sorting.
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
| `<Space>ai` | **Run AI Sorter** | Categorize `00-Inbox/` notes into PARA folders & push to GitHub |
| `<Space>ac` | **Configure AI Sorter** | Open wizard split terminal to select AI provider / API key |
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

## 📱 Mobile Syncing (iPhone / Android / Obsidian Desktop)

1. Connect your local vault to a private GitHub repository:
   ```bash
   cd ~/Notes
   git remote add origin git@github.com:YOUR_USERNAME/notes.git
   git push -u origin main
   ```
2. Open **Obsidian Desktop**: Click "Open folder as vault" and select `~/Notes`.
3. Open **Obsidian Mobile** on iOS/Android:
   * Install the **Obsidian Git** community plugin.
   * Add your GitHub remote URL & Personal Access Token.
   * Set Auto-Pull/Push interval to `5` minutes.

---

## 📄 License

[MIT License](LICENSE) — Free for anyone to use, modify, and share!
