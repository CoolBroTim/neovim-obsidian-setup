#!/usr/bin/env python3
"""
AI Note Sorter for Obsidian / Neovim Vault (PARA Method)
Powered by Gemini 3.6 Flash AI & Fallback NLP Classification.
Scans 00-Inbox/ for notes and categorizes them into 10-Projects, 20-Areas, 30-Resources, or 40-Archive.
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

TARGET_DIRS = {
    "projects": VAULT_DIR / "10-Projects",
    "areas": VAULT_DIR / "20-Areas",
    "resources": VAULT_DIR / "30-Resources",
    "archive": VAULT_DIR / "40-Archive",
}

def call_gemini_ai(title: str, text: str) -> str:
    """
    Asks Gemini 3.6 Flash to classify the note into one of the 4 PARA categories.
    """
    prompt = f"""You are a personal note organization assistant using the PARA Method.
Categorize the following note into EXACTLY ONE of these four categories:
- projects (active short-term goals or tasks)
- areas (long-term responsibilities, health, finance, system config, work)
- resources (guides, cheat-sheets, manuals, reference info, ideas)
- archive (completed, inactive, or old notes)

Note Title: {title}
Note Snippet: {text[:500]}

Respond with ONLY the single category name in lowercase (projects, areas, resources, or archive).
"""
    # 1. Try Antigravity / Gemini CLI if available
    try:
        res = subprocess.run(
            ["agy", "run", "--model", "gemini-3.6-flash", prompt],
            capture_output=True,
            text=True,
            timeout=10
        )
        if res.returncode == 0 and res.stdout.strip().lower() in TARGET_DIRS:
            return res.stdout.strip().lower()
    except Exception:
        pass

    # 2. Try GEMINI_API_KEY environment variable if present
    api_key = os.environ.get("GEMINI_API_KEY")
    if api_key:
        try:
            url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={api_key}"
            payload = json.dumps({"contents": [{"parts": [{"text": prompt}]}]}).encode("utf-8")
            req = urllib.request.Request(url, data=payload, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=5) as response:
                result = json.loads(response.read().decode("utf-8"))
                cat = result['candidates'][0]['content']['parts'][0]['text'].strip().lower()
                if cat in TARGET_DIRS:
                    return cat
        except Exception:
            pass

    # 3. Fallback: Fast Local Keyword Classifier
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

def main():
    if not INBOX_DIR.exists():
        print("Inbox folder does not exist.")
        return

    inbox_files = [f for f in INBOX_DIR.glob("*.md") if f.is_file()]
    if not inbox_files:
        print("📥 00-Inbox is clean! No unorganized notes found.")
        return

    print(f"🔍 Found {len(inbox_files)} note(s) in 00-Inbox to organize:\n")

    moved_count = 0
    for note in inbox_files:
        title = note.stem
        text = note.read_text(encoding="utf-8", errors="ignore")
        
        category = call_gemini_ai(title, text)
        dest_dir = TARGET_DIRS[category]
        dest_path = dest_dir / note.name

        counter = 1
        while dest_path.exists():
            dest_path = dest_dir / f"{note.stem}-{counter}{note.suffix}"
            counter += 1

        shutil.move(str(note), str(dest_path))
        rel_dest = dest_path.relative_to(VAULT_DIR)
        print(f"  🤖 Gemini AI -> Moved '{note.name}' -> {rel_dest}")
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
