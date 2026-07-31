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
3. Optionally run the **Git Remote & Authentication Wizard** to connect your vault to GitHub/GitLab/Codeberg.
4. Back up any existing Neovim config.
5. Deploy the complete Pure Lua Neovim configuration and PARA vault structure.
6. Create the `notes` terminal alias and `Notes Vault` desktop launcher for **Rofi**, **Wofi**, and **Hyprlauncher**.

---

## 🎯 Post-Installation: Getting Started (Step-by-Step)

Follow these simple steps after running `install.sh`:

### 1. Launch Your Notes Vault
* **From Terminal:** Type `notes` and press Enter.
* **From App Launcher:** Open **Rofi**, **Wofi**, or **Hyprlauncher** and search for `Notes Vault`.

### 2. View the Built-In Cheat Sheet (`<Space>h`)
* Inside Neovim, press **`<Space>h`** anytime to open an interactive floating cheat sheet listing all shortcuts and navigation commands. Press `q` or `<Esc>` to close it.

### 3. Connect Git Remote & Auth (`<Space>gc`)
* Press **`<Space>gc`** to open the interactive Git Remote & Authentication Wizard in a split terminal.
* Supports **GitHub**, **GitLab**, **Codeberg**, and custom Git servers.
* Supports **Personal Access Tokens (PAT)**, **SSH Keys** (auto-generates ed25519 SSH keys), and **GitHub CLI (`gh`)**.

### 4. Configure Your AI Note Sorter (`<Space>ac`)
* Press **`<Space>ac`** to open the interactive AI Provider Setup Wizard in a split terminal.
* Select your preferred classification engine:
  * **Option 6 (Default):** Fast Rule-Based NLP Classifier (Zero setup required, works offline immediately).
  * **Option 1:** Cloud API Key (Paste your Google Gemini, OpenAI `gpt-4o-mini`, or Anthropic `claude-3-5-haiku` key).
  * **Option 2:** Google Antigravity CLI (`agy run --model gemini-3.6-flash`).
  * **Option 3:** Codex CLI (`codex exec --model gpt-4o-mini`).
  * **Option 4:** Claude Code CLI (`claude -p --model claude-3-5-haiku`).
  * **Option 5:** Ollama Local LLM (`qwen2.5:0.5b` or any model of your choice — 100% private offline AI).

### 5. Daily Note Workflow (`<Space>nd`)
* Press **`<Space>nd`** to instantly create or open today's daily journal log (`Daily/YYYY-MM-DD.md`) pre-populated with task checkboxes and notes sections.

### 6. Capture & AI Auto-Sorting (`<Space>ai`)
* Drop quick scratchpad notes, meeting logs, or code snippets in `00-Inbox/`.
* Press **`<Space>ai`** to automatically classify and move your inbox notes into PARA folders (`10-Projects/`, `20-Areas/`, `30-Resources/`, `40-Archive/`) and commit/push the updates to Git!

### 7. Git Synchronization (`<Space>gp`)
* Press **`<Space>gp`** anytime to stage, commit, and push all vault changes directly to your GitHub/GitLab remote repository.

---

## 📱 Mobile Sync Setup Guide (iPhone & Android)

Follow these 4 simple steps to connect your iPhone or Android phone to your Notes vault via GitHub:

### Step 1: Create a GitHub Personal Access Token (PAT)
1. On your computer, go to **GitHub.com** $\rightarrow$ Click your profile picture $\rightarrow$ **Settings**.
2. Scroll down on the left sidebar and click **Developer Settings**.
3. Click **Personal access tokens** $\rightarrow$ **Tokens (classic)** $\rightarrow$ **Generate new token (classic)**.
4. Note description: `Obsidian Mobile Sync`.
5. Expiration: `No expiration`.
6. Select scopes: Check the **`repo`** box (Full control of private repositories).
7. Click **Generate token** and **COPY THE TOKEN** (starts with `ghp_...`).

### Step 2: Create an Empty Vault on Mobile
1. Install **Obsidian** from the **Apple App Store** (iOS) or **Google Play Store** (Android).
2. Open Obsidian on your phone $\rightarrow$ Tap **Create new vault**.
3. Name your vault: **`Notes`**.
4. Tap **Create**.

### Step 3: Install the "Obsidian Git" Plugin
1. Inside Obsidian on your phone, open **Settings** (Gear icon in sidebar).
2. Go to **Community plugins** $\rightarrow$ Tap **Turn on community plugins**.
3. Tap **Browse** $\rightarrow$ Search for **`Obsidian Git`**.
4. Tap **Install**, then tap **Enable**.

### Step 4: Clone Your GitHub Repository via Command Palette
1. Open the Obsidian **Command Palette** on your phone (swipe down from top of note screen or tap ribbon icon).
2. Type and select: **`Obsidian Git: Clone an existing remote repository`**.
3. **Repository URL:** Paste your GitHub repository URL:
   `https://github.com/YOUR_USERNAME/notes.git`
4. When prompted, enter your **GitHub Username** and paste your **Personal Access Token** (`ghp_...`).
5. In Obsidian Settings $\rightarrow$ **Obsidian Git**:
   * Set **Vault backup interval (minutes):** `5`
   * Set **Auto Pull Interval (minutes):** `5`
   * Enable **Pull updates on startup**.

🎉 **You're all set!** Any note you write on your iPhone will automatically sync to your Arch Linux PC, and any note you edit in Neovim will sync to your phone!

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
* **🔗 Git Setup Wizard:** Press `<Space>gc` to configure remote repository URLs and PAT token / SSH key authentication.
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
| `<Space>gp` | **Git Sync** | Stage, commit, and push vault to GitHub/GitLab |
| `<Space>gc` | **Configure Git** | Open interactive Git Remote & Auth setup wizard |
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
└── scripts/         # Automation scripts (sort_notes.py, setup_git.sh)
```

---

## 📄 License

[MIT License](LICENSE) — Free for anyone to use, modify, and share!
