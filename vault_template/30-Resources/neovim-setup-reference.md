# Neovim & Obsidian Note-Taking System Reference

This reference document records the architecture, configuration details, directory structure, automation scripts, interactive wizards, and shortcuts for your cross-platform note-taking environment.

---

## 📌 1. System Overview & Repositories

| Property | Value |
|---|---|
| **Main Desktop OS** | Arch Linux |
| **Mobile OS** | iPhone 13 (via Obsidian App + Obsidian Git) |
| **Future OS** | MacBook Pro (macOS 11 / Arch Linux) |
| **Vault Directory** | `/home/timothy/Notes` |
| **Personal Vault GitHub Repo** | `https://github.com/CoolBroTim/notes.git` (Private) |
| **Open-Source Setup GitHub Repo** | `https://github.com/CoolBroTim/neovim-obsidian-setup.git` (Public) |
| **One-Line Linux Installer** | `curl -sSL https://raw.githubusercontent.com/CoolBroTim/neovim-obsidian-setup/main/install.sh \| bash` |
| **Neovim Config Path** | `/home/timothy/.config/nvim` |

---

## 📁 2. Vault Structure (PARA Method)

```text
~/Notes/
├── 00-Inbox/        # Scratchpad for quick daily captures & unorganized thoughts
├── 10-Projects/     # Active projects with deadlines
├── 20-Areas/        # Long-term life responsibilities (Health, Finance, Arch, Work)
├── 30-Resources/    # References, manuals, cheat-sheets, guides
├── 40-Archive/      # Completed or inactive notes
├── Daily/           # Daily journal logs (YYYY-MM-DD.md)
├── Templates/       # Reusable note templates
└── scripts/         # Automation scripts (sort_notes.py, setup_git.sh)
```

> **Note:** Every folder contains a `.gitkeep` file so that empty directories remain visible on GitHub.

---

## ⌨️ 3. Complete Neovim Keymap Shortcuts

**Leader Key:** `<Space>` (Spacebar)

### Note-Taking, Git & AI Automation Shortcuts
| Shortcut | Action | Description |
|---|---|---|
| `<Space>h` | **Interactive Cheat Sheet** | Opens a floating window cheat sheet inside Neovim |
| `<Space>nd` | **Daily Note** | Auto-creates or opens today's daily note (`YYYY-MM-DD.md`) |
| `<Space>ft` | **Search Vault TODOs** | Search all `TODO:`, `FIXME:`, `NOTE:` tags across vault |
| `<Space>mp` | **Browser Preview** | Toggle live real-time browser preview |
| `<Space>gp` | **Git Sync** | Stages all changes (`git add -A`), commits, and pushes to GitHub |
| `<Space>gc` | **Configure Git Remote** | Opens split terminal running Git Remote & Authentication Setup Wizard |
| `<Space>ai` | **Run AI Sorter** | Categorizes `00-Inbox/` notes into PARA folders and pushes to GitHub |
| `<Space>ac` | **Configure AI Sorter** | Opens split terminal running AI Provider Setup Wizard |
| `<Space>ff` | **Find Note File** | Fuzzy search note filenames across vault with Telescope |
| `<Space>fg` | **Grep Text** | Live search for text/sentences inside all notes |
| `<Space>fb` | **Find Buffers** | Search open file buffers |
| `<Space>nn` | **New Note** | Prompt to create a new Obsidian note |
| `<Space>ns` | **Search Notes** | Search note titles via Obsidian plugin |
| `<Space>nt` | **Search Tags** | Search note tags (`#tag`) |
| `<Space>no` | **Open in Obsidian** | Open current note in official Obsidian GUI desktop app |
| `gcc` | **Comment Line** | Comment / Uncomment current line |
| `gf` | **Follow Wikilink** | Opens the note under cursor (`[[Note Name]]`) |
| `<Tab>` | **Toggle Checkbox** | Toggles `- [ ]` $\leftrightarrow$ `- [x]` |
| `<Space>w` / `Ctrl+s` | **Save File** | Manually saves file (also auto-saves on InsertLeave) |

---

### Essential Vim Movement & Editing

#### Navigation:
* `w` — Jump **forward** to the start of the next word.
* `b` — Jump **backward** to the start of the previous word.
* `e` — Jump to the **end** of the current word.
* `0` (Zero) — Jump to the **start** of the line.
* `$` — Jump to the **end** of the line.
* `gg` — Jump to the **very top** of the document.
* `G` — Jump to the **very bottom** of the document.
* `Ctrl + d` — Scroll **down** half a page.
* `Ctrl + u` — Scroll **up** half a page.

#### Editing & Deleting:
* `i` — Enter Insert mode at cursor.
* `a` — Enter Insert mode *after* cursor.
* `o` — Open a new line *below* current line and enter Insert mode.
* `O` — Open a new line *above* current line and enter Insert mode.
* `x` — Delete single character under cursor.
* `dw` — Delete word from cursor onwards.
* `dd` — Delete entire current line.
* `cw` — Change word (deletes word and enters Insert mode).
* `ciw` — Change *inner* word (works anywhere inside the word!).
* `ci"` — Change contents inside double quotes `""`.
* `u` — **Undo** last change.
* `Ctrl + r` — **Redo** last change.

#### Selection & Copy/Paste:
* `v` — Character visual selection mode.
* `V` — Line visual selection mode.
* `y` — Yank (copy) selected text.
* `p` — Paste copied text after cursor.
* `Esc` — Return to Normal mode.

---

## 🎨 4. Installed Neovim Plugins & Configuration

| Plugin | Purpose |
|---|---|
| **`lazy.nvim`** | Plugin manager with fast lazy-loading (<15ms startup) |
| **`tokyonight.nvim`** | Dark color scheme (Storm style) |
| **`epwalsh/obsidian.nvim`** | Vault management, wikilinks, daily notes, tag search |
| **`MeanderingProgrammer/render-markdown.nvim`** | Pretty rendered headers, checkboxes, callouts, and code blocks |
| **`folke/noice.nvim` + `nui.nvim`** | Centered floating `:` command line and `/` search box |
| **`folke/which-key.nvim`** | Interactive `<Space>` shortcut helper popup |
| **`nvim-lualine/lualine.nvim`** | Sleek status bar matching Tokyonight theme |
| **`nvim-tree/nvim-web-devicons`** | File and vault icons |
| **`windwp/nvim-autopairs`** | Auto-closes quotes `""`, brackets `()`, and `[[]]` wikilinks |
| **`stevearc/dressing.nvim`** | Floating rounded UI input popups |
| **`folke/todo-comments.nvim`** | Highlight `TODO:`, `FIXME:`, `NOTE:` badges & fuzzy search tasks (`<Space>ft`) |
| **`numToStr/Comment.nvim`** | Quick line commenting (`gcc`) |
| **`iamcco/markdown-preview.nvim`** | Live real-time browser preview (`<Space>mp`) |
| **`nvim-telescope/telescope.nvim`** | Fuzzy finder over notes and vault files |
| **`nvim-treesitter/nvim-treesitter`** | High-performance syntax parser (v0.9.3 stable) |
| **`Saghen/blink.cmp` + `marksman`** | Auto-completion engine and Markdown Language Server |

---

## 🤖 5. Universal AI Note Sorter (`scripts/sort_notes.py`)

* **Location:** `/home/timothy/Notes/scripts/sort_notes.py`
* **Trigger Sorter:** `<Space>ai` (or `python3 ~/Notes/scripts/sort_notes.py`).
* **Trigger Setup Wizard:** `<Space>ac` (or `python3 ~/Notes/scripts/sort_notes.py --config`).
* **Supported AI Providers:**
  1. **Cloud API Key:** Auto-detects Gemini, OpenAI (`gpt-4o-mini`), or Anthropic (`claude-3-5-haiku`).
  2. **Google Antigravity CLI:** Calls `agy run --model gemini-3.6-flash`.
  3. **Codex CLI:** Calls `codex exec --model gpt-4o-mini`.
  4. **Claude Code CLI:** Calls `claude -p --model claude-3-5-haiku`.
  5. **Ollama Local LLM:** Calls local Ollama server (`http://localhost:11434`) using `qwen2.5:0.5b` or custom local model.
  6. **Rule-Based NLP Classifier:** Default zero-dependency local classifier.
* **Behavior:** Categorizes `00-Inbox/` files into PARA folders and automatically commits and pushes to Git.

---

## 🔗 6. Git Remote & Auth Setup Wizard (`scripts/setup_git.sh`)

* **Location:** `/home/timothy/Notes/scripts/setup_git.sh`
* **Trigger:** `<Space>gc` inside Neovim (or `bash ~/Notes/scripts/setup_git.sh` in terminal).
* **Supported Features:**
  * Interactive platform selection (GitHub, GitLab, Codeberg, custom servers).
  * HTTPS PAT Token configuration.
  * SSH Key auto-generation (`ed25519`).
  * GitHub CLI (`gh`) login integration.

---

## 📱 7. Mobile Sync Setup Guide (iPhone & Android)

1. **Create GitHub PAT:** On GitHub.com $\rightarrow$ Developer Settings $\rightarrow$ Personal Access Tokens (classic) $\rightarrow$ Generate classic token with `repo` scope.
2. **Create Vault:** Open Obsidian on phone $\rightarrow$ Create new vault named `Notes`.
3. **Install Plugin:** Settings $\rightarrow$ Community Plugins $\rightarrow$ Install & enable **Obsidian Git**.
4. **Clone Repository:**
   * Open Obsidian **Command Palette** (swipe down from top of note screen).
   * Select **`Obsidian Git: Clone an existing remote repository`**.
   * Enter URL: `https://github.com/CoolBroTim/notes.git`
   * Enter Username: `CoolBroTim` and paste PAT token (`ghp_...`).
   * Set Auto Pull & Push intervals to `5` minutes in Obsidian Git settings.
