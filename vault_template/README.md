# Welcome to Your Cross-Platform Notes Vault

This repository contains your notes stored in standard plain Markdown (`.md`) format.

---

## 📁 Directory Layout (PARA Method)

- `00-Inbox/` — Quick captures, raw notes, unorganized thoughts.
- `10-Projects/` — Active projects and short-term goals.
- `20-Areas/` — Ongoing responsibilities (Health, Finance, Arch Linux, macOS).
- `30-Resources/` — Cheat-sheets, references, articles.
- `40-Archive/` — Completed or inactive notes.
- `Daily/` — Daily journal logs (`YYYY-MM-DD.md`).
- `Templates/` — Templates for new notes.
- `scripts/` — Automation scripts (`sort_notes.py`, `setup_git.sh`).

---

## 🚀 Ways to Launch Your Vault

1. **Application Launchers (Rofi / Wofi / Hyprlauncher / App Menu):**
   * Search for **"Notes Vault"** in your application launcher and press Enter!
2. **Terminal Shortcut:**
   * Open any terminal and type: `notes`
3. **From Neovim:**
   * Run `nvim` in your vault directory.

---

## 🎯 How to Use Key Features

### 1. Automatic Background Syncing & Remote Setup
* **Automatic Pull on Startup:** Neovim automatically runs `git pull --rebase` in the background when it opens, pulling down any notes edited on your iPhone/mobile.
* **Configure Git Remote & Auth (`<Space>gc`):** Press **`<Space>gc`** to open the interactive setup wizard split terminal to connect your vault to GitHub, GitLab, Codeberg, or custom Git servers via PAT tokens, SSH keys, or GitHub CLI (`gh`).
* **Pushing Updates (`<Space>gp`):** Press **`<Space>gp`** anytime to stage all new notes, edits, and deletions, commit them, and push directly to your remote repository.

---

### 2. AI Note Sorter & Provider Wizard
* **Run AI Sorter (`<Space>ai`):** Place unorganized scratchpad notes in `00-Inbox/` and press **`<Space>ai`**. The sorter categorizes your notes into PARA folders and automatically commits and pushes them to Git.
* **Configure AI Provider (`<Space>ac`):** Press **`<Space>ac`** anytime to open the interactive AI Provider Setup Wizard in a split terminal window. Switch between:
  * **Option 6 (Default):** Fast Rule-Based NLP Classifier (Zero setup required, works offline).
  * **Option 1:** Cloud API Key (Gemini, OpenAI `gpt-4o-mini`, or Anthropic `claude-3-5-haiku`).
  * **Option 2:** Google Antigravity CLI (`agy run --model gemini-3.6-flash`).
  * **Option 3:** Codex CLI (`codex exec --model gpt-4o-mini`).
  * **Option 4:** Claude Code CLI (`claude -p --model claude-3-5-haiku`).
  * **Option 5:** Ollama Local LLM (`qwen2.5:0.5b` or any model of your choice — 100% private offline AI).

---

### 3. Task Tracking & TODO Badges (`TODO:`, `FIXME:`, `NOTE:`)
You can tag tasks anywhere inside your notes using special keywords. Neovim will highlight them with colored badges:
- `TODO: Fix terminal setup` $\rightarrow$ Highlights in cyan badge
- `FIXME: Correct Git URL` $\rightarrow$ Highlights in red badge
- `NOTE: Read Arch Linux docs` $\rightarrow$ Highlights in blue badge
- `WARNING: Check disk space` $\rightarrow$ Highlights in yellow badge

* **Search All Tasks:** Press **`<Space>ft`** inside Neovim to bring up a fuzzy search list of all `TODO:`, `FIXME:`, and `NOTE:` tags across your entire vault!

---

### 4. Daily Note Workflow (`<Space>nd`)
* Press **`<Space>nd`** to instantly create or open today's daily journal log (`Daily/YYYY-MM-DD.md`) pre-populated with task checkboxes and notes sections.

---

### 5. Live Browser Markdown Preview
* Press **`<Space>mp`** inside Neovim while editing any Markdown note.
* It will open a live rendering of your note in your web browser that updates instantaneously as you type.

---

### 6. Quick Commenting
* Press **`gcc`** on any line (or **`gc`** on a selected block in visual mode) to quickly comment out text (`<!-- comment -->`).

---

## ⌨️ Quick Neovim Shortcuts Reference

**Leader Key:** `<Space>` (Spacebar)

| Shortcut | Action | Description |
|---|---|---|
| `<Space>h` | **Help Cheat Sheet** | Open interactive floating help sheet |
| `<Space>nd` | **Daily Note** | Create or open today's daily note |
| `<Space>ft` | **Search TODOs** | Search all `TODO:`, `FIXME:`, `NOTE:` tags across vault |
| `<Space>mp` | **Browser Preview** | Toggle live browser preview of current note |
| `<Space>gp` | **Git Sync** | Stage, commit, and push vault to GitHub/GitLab |
| `<Space>gc` | **Configure Git** | Open interactive Git Remote & Auth setup wizard |
| `<Space>ai` | **Run AI Sorter** | Categorize `00-Inbox/` notes into PARA folders & push to GitHub |
| `<Space>ac` | **Configure AI Sorter** | Open wizard split terminal to select AI provider / API key |
| `<Space>ff` | **Find File** | Fuzzy search note files in vault |
| `<Space>fg` | **Grep Text** | Live search text inside notes |
| `<Space>nn` | **New Note** | Prompt to create a new Obsidian note |
| `<Space>no` | **Open in Obsidian** | Open current note in official Obsidian GUI app |
| `gcc` | **Comment Line** | Toggle line comment (`<!-- comment -->`) |
| `gf` | **Follow Link** | Follow `[[Wikilink]]` under cursor |
| `<Tab>` | **Toggle Checkbox** | Toggle `- [ ]` $\leftrightarrow$ `- [x]` |
