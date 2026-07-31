#!/usr/bin/env python3
"""
Universal AI Note Sorter for Obsidian / Neovim Vault (PARA Method)
Supports:
  1. Cloud API Key (Gemini, OpenAI, or Anthropic auto-detected)
  2. Google Antigravity CLI / Gemini 3.6 Flash
  3. Codex CLI (gpt-4o-mini lowest model)
  4. Claude Code CLI (claude-3-5-haiku lowest model)
  5. Ollama Local LLM (qwen2.5:0.5b / llama3.2)
  6. Rule-Based Fallback Classifier

Configuration stored in ~/.config/note-sorter/config.json
"""

import os
import sys
import shutil
import json
import subprocess
import urllib.request
from pathlib import Path

VAULT_DIR = Path("/home/timothy/Notes").expanduser()
INBOX_DIR = VAULT_DIR / "00-Inbox"
CONFIG_FILE = Path("~/.config/note-sorter/config.json").expanduser()

TARGET_DIRS = {
    "projects": VAULT_DIR / "10-Projects",
    "areas": VAULT_DIR / "20-Areas",
    "resources": VAULT_DIR / "30-Resources",
    "archive": VAULT_DIR / "40-Archive",
}

PROMPT_TEMPLATE = """You are a personal note organization assistant using the PARA Method.
Categorize the following note into EXACTLY ONE of these four categories:
- projects (active short-term goals, tasks, feature builds, deadlines)
- areas (long-term responsibilities, health, finance, system config, work)
- resources (guides, cheat-sheets, manuals, reference info, ideas, documentation)
- archive (completed, inactive, old notes)

Note Title: {title}
Note Snippet: {text}

Respond with ONLY the single category name in lowercase (projects, areas, resources, or archive).
"""

# ------------------------------------------------------------------------------
# Provider Callers
# ------------------------------------------------------------------------------

def call_antigravity(prompt: str) -> str:
    res = subprocess.run(
        ["agy", "run", "--model", "gemini-3.6-flash", prompt],
        capture_output=True, text=True, timeout=10
    )
    if res.returncode == 0:
        return res.stdout.strip().lower()
    raise RuntimeError("Antigravity CLI failed")

def call_codex_cli(prompt: str) -> str:
    # Use lowest / fastest model: gpt-4o-mini
    res = subprocess.run(
        ["codex", "exec", "--model", "gpt-4o-mini", prompt],
        capture_output=True, text=True, timeout=10
    )
    if res.returncode == 0:
        return res.stdout.strip().lower()
    raise RuntimeError("Codex CLI failed")

def call_claude_cli(prompt: str) -> str:
    # Use lowest / fastest model: claude-3-5-haiku
    res = subprocess.run(
        ["claude", "-p", "--model", "claude-3-5-haiku", prompt],
        capture_output=True, text=True, timeout=10
    )
    if res.returncode == 0:
        return res.stdout.strip().lower()
    raise RuntimeError("Claude Code CLI failed")

def call_gemini_api(prompt: str, api_key: str) -> str:
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={api_key}"
    payload = json.dumps({"contents": [{"parts": [{"text": prompt}]}]}).encode("utf-8")
    req = urllib.request.Request(url, data=payload, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=8) as response:
        result = json.loads(response.read().decode("utf-8"))
        return result['candidates'][0]['content']['parts'][0]['text'].strip().lower()

def call_openai_api(prompt: str, api_key: str) -> str:
    url = "https://api.openai.com/v1/chat/completions"
    payload = json.dumps({
        "model": "gpt-4o-mini",
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.1
    }).encode("utf-8")
    req = urllib.request.Request(url, data=payload, headers={
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    })
    with urllib.request.urlopen(req, timeout=8) as response:
        result = json.loads(response.read().decode("utf-8"))
        return result['choices'][0]['message']['content'].strip().lower()

def call_anthropic_api(prompt: str, api_key: str) -> str:
    url = "https://api.anthropic.com/v1/messages"
    payload = json.dumps({
        "model": "claude-3-5-haiku-20241022",
        "max_tokens": 10,
        "messages": [{"role": "user", "content": prompt}]
    }).encode("utf-8")
    req = urllib.request.Request(url, data=payload, headers={
        "Content-Type": "application/json",
        "x-api-key": api_key,
        "anthropic-version": "2023-06-01"
    })
    with urllib.request.urlopen(req, timeout=8) as response:
        result = json.loads(response.read().decode("utf-8"))
        return result['content'][0]['text'].strip().lower()

def call_ollama(prompt: str, model_name: str = "qwen2.5:0.5b") -> str:
    url = "http://localhost:11434/api/generate"
    payload = json.dumps({
        "model": model_name,
        "prompt": prompt,
        "stream": False
    }).encode("utf-8")
    req = urllib.request.Request(url, data=payload, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=8) as response:
        result = json.loads(response.read().decode("utf-8"))
        return result['response'].strip().lower()

def call_rule_based(title: str, text: str) -> str:
    text_lower = text.lower()
    title_lower = title.lower()

    project_keywords = ["todo", "task", "deadline", "project", "fix", "feature", "roadmap", "milestone", "build", "v1", "v2"]
    area_keywords = ["health", "finance", "budget", "fitness", "workout", "routine", "arch", "linux", "macos", "config", "system", "maintenance", "journal"]
    resource_keywords = ["cheat", "sheet", "guide", "reference", "manual", "docs", "recipe", "book", "article", "idea", "summary", "link", "concept"]
    archive_keywords = ["done", "completed", "old", "backup", "deprecated", "archive", "2023", "2024", "2025"]

    scores = {
        "projects": sum(2 for k in project_keywords if k in title_lower) + sum(1 for k in project_keywords if k in text_lower),
        "areas": sum(2 for k in area_keywords if k in title_lower) + sum(1 for k in area_keywords if k in text_lower),
        "resources": sum(2 for k in resource_keywords if k in title_lower) + sum(1 for k in resource_keywords if k in text_lower),
        "archive": sum(2 for k in archive_keywords if k in title_lower) + sum(1 for k in archive_keywords if k in text_lower),
    }

    best_cat = max(scores, key=scores.get)
    return best_cat if scores[best_cat] > 0 else "resources"

# ------------------------------------------------------------------------------
# Setup Wizard & Configuration
# ------------------------------------------------------------------------------

def detect_api_provider(api_key: str) -> str:
    if api_key.startswith("AIza"):
        return "gemini"
    elif api_key.startswith("sk-ant"):
        return "anthropic"
    elif api_key.startswith("sk-"):
        return "openai"
    return "gemini"

def run_setup_wizard() -> dict:
    print("\n========================================================================")
    print("      🤖 AI NOTE SORTER INITIAL SETUP WIZARD                           ")
    print("========================================================================\n")
    print("Please choose your preferred AI Provider for note classification:\n")
    print("  1) Cloud API Key (Gemini / OpenAI / Anthropic)")
    print("  2) Google Antigravity CLI / Gemini 3.6 Flash (agy)")
    print("  3) Codex CLI (codex --model gpt-4o-mini)")
    print("  4) Claude Code CLI (claude --model claude-3-5-haiku)")
    print("  5) Ollama Local LLM (qwen2.5:0.5b / llama3.2 - 100% Private Offline AI)")
    print("  6) Fast Rule-Based NLP Classifier (No API key, zero requirements)\n")

    choice = input("Select option [1-6, default 2]: ").strip() or "2"
    config = {}

    if choice == "1":
        api_key = input("\nEnter your Cloud API Key: ").strip()
        provider = detect_api_provider(api_key)
        
        provider_names = {
            "gemini": "Google Gemini API (Gemini 1.5 Flash)",
            "openai": "OpenAI API (GPT-4o-mini)",
            "anthropic": "Anthropic Claude API (Claude 3.5 Haiku)"
        }
        print(f"\n✓ Detected Provider: {provider_names.get(provider, 'Gemini API')}")
        
        config["provider"] = provider
        config["api_key"] = api_key

    elif choice == "2":
        config["provider"] = "antigravity"
    elif choice == "3":
        config["provider"] = "codex"
    elif choice == "4":
        config["provider"] = "claude"
    elif choice == "5":
        config["provider"] = "ollama"
        model_name = input("Enter Ollama model name [default: qwen2.5:0.5b]: ").strip() or "qwen2.5:0.5b"
        config["ollama_model"] = model_name
    else:
        config["provider"] = "local"

    CONFIG_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(CONFIG_FILE, "w") as f:
        json.dump(config, f, indent=2)

    print(f"\n✅ Configuration saved to {CONFIG_FILE}\n")
    return config

def load_config() -> dict:
    if not CONFIG_FILE.exists():
        return run_setup_wizard()
    try:
        with open(CONFIG_FILE, "r") as f:
            return json.load(f)
    except Exception:
        return run_setup_wizard()

def classify_note(title: str, text: str, config: dict) -> str:
    prompt = PROMPT_TEMPLATE.format(title=title, text=text[:500])
    provider = config.get("provider", "antigravity")

    try:
        if provider == "antigravity":
            cat = call_antigravity(prompt)
        elif provider == "codex":
            cat = call_codex_cli(prompt)
        elif provider == "claude":
            cat = call_claude_cli(prompt)
        elif provider == "gemini":
            cat = call_gemini_api(prompt, config.get("api_key", ""))
        elif provider == "openai":
            cat = call_openai_api(prompt, config.get("api_key", ""))
        elif provider == "anthropic":
            cat = call_anthropic_api(prompt, config.get("api_key", ""))
        elif provider == "ollama":
            cat = call_ollama(prompt, config.get("ollama_model", "qwen2.5:0.5b"))
        else:
            cat = call_rule_based(title, text)

        for target in TARGET_DIRS:
            if target in cat:
                return target
    except Exception as e:
        print(f"⚠️ Provider '{provider}' encountered: {e}. Falling back to local classifier...")

    return call_rule_based(title, text)

# ------------------------------------------------------------------------------
# Main Execution
# ------------------------------------------------------------------------------

def main():
    config = load_config()

    if not INBOX_DIR.exists():
        print("Inbox folder does not exist.")
        return

    inbox_files = [f for f in INBOX_DIR.glob("*.md") if f.is_file()]
    if not inbox_files:
        print("📥 00-Inbox is clean! No unorganized notes found.")
        return

    print(f"🔍 Found {len(inbox_files)} note(s) in 00-Inbox to organize [Provider: {config.get('provider', 'local')}]:\n")

    moved_count = 0
    for note in inbox_files:
        title = note.stem
        text = note.read_text(encoding="utf-8", errors="ignore")
        
        category = classify_note(title, text, config)
        dest_dir = TARGET_DIRS[category]
        dest_path = dest_dir / note.name

        counter = 1
        while dest_path.exists():
            dest_path = dest_dir / f"{note.stem}-{counter}{note.suffix}"
            counter += 1

        shutil.move(str(note), str(dest_path))
        rel_dest = dest_path.relative_to(VAULT_DIR)
        print(f"  🤖 [{config.get('provider', 'local').upper()}] Moved '{note.name}' -> {rel_dest}")
        moved_count += 1

    try:
        subprocess.run(["git", "add", "."], cwd=VAULT_DIR, check=True)
        subprocess.run(["git", "commit", "-m", f"AI Auto-Sorter: organized {moved_count} note(s)"], cwd=VAULT_DIR, check=True)
        print(f"\n✅ Successfully organized and committed {moved_count} note(s) to Git!")
        
        print("🚀 Pushing updates to GitHub...")
        subprocess.run(["git", "push"], cwd=VAULT_DIR, check=True)
        print("🎉 Successfully pushed to GitHub!")
    except Exception as e:
        print(f"\n⚠️ Organized files, but Git operation encountered: {e}")

if __name__ == "__main__":
    main()
