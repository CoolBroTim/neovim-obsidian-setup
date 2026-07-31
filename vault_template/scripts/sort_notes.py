#!/usr/bin/env python3
"""
AI Note Sorter for Obsidian / Neovim Vault (PARA Method)
Scans 00-Inbox/ for notes and categorizes them into 10-Projects, 20-Areas, 30-Resources, or 40-Archive.
"""

import os
import sys
import shutil
import subprocess
from pathlib import Path

VAULT_DIR = Path("/home/timothy/Notes").expanduser()
INBOX_DIR = VAULT_DIR / "00-Inbox"

TARGET_DIRS = {
    "projects": VAULT_DIR / "10-Projects",
    "areas": VAULT_DIR / "20-Areas",
    "resources": VAULT_DIR / "30-Resources",
    "archive": VAULT_DIR / "40-Archive",
}

def analyze_note(file_path: Path) -> str:
    text = file_path.read_text(encoding="utf-8", errors="ignore").lower()
    title = file_path.stem.lower()

    project_keywords = ["todo", "task", "deadline", "project", "fix", "feature", "roadmap", "milestone", "build", "v1", "v2"]
    area_keywords = ["health", "finance", "budget", "fitness", "workout", "routine", "arch", "linux", "macos", "config", "system", "maintenance", "journal"]
    resource_keywords = ["cheat", "sheet", "guide", "reference", "manual", "docs", "recipe", "book", "article", "idea", "summary", "link", "concept"]
    archive_keywords = ["done", "completed", "old", "backup", "deprecated", "archive", "2023", "2024", "2025"]

    scores = {
        "projects": sum(2 for k in project_keywords if k in title) + sum(1 for k in project_keywords if k in text),
        "areas": sum(2 for k in area_keywords if k in title) + sum(1 for k in area_keywords if k in text),
        "resources": sum(2 for k in resource_keywords if k in title) + sum(1 for k in resource_keywords if k in text),
        "archive": sum(2 for k in archive_keywords if k in title) + sum(1 for k in archive_keywords if k in text),
    }

    best_cat = max(scores, key=scores.get)
    if scores[best_cat] == 0:
        best_cat = "resources"
    return best_cat

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
        category = analyze_note(note)
        dest_dir = TARGET_DIRS[category]
        dest_path = dest_dir / note.name

        counter = 1
        while dest_path.exists():
            dest_path = dest_dir / f"{note.stem}-{counter}{note.suffix}"
            counter += 1

        shutil.move(str(note), str(dest_path))
        rel_dest = dest_path.relative_to(VAULT_DIR)
        print(f"  ✓ Moved '{note.name}' -> {rel_dest}")
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
