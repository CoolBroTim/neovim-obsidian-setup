#!/usr/bin/env bash
# ==============================================================================
# Universal Git Remote & Authentication Setup Wizard for Notes Vault
# Supports GitHub, GitLab, Codeberg, and custom Git servers (HTTPS, SSH, PAT)
# ==============================================================================

set -e

BOLD="\033[1m"
GREEN="\033[32m"
BLUE="\033[34m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

VAULT_DIR="${1:-$HOME/Notes}"
VAULT_DIR="${VAULT_DIR/#\~/$HOME}"

echo -e "${BLUE}${BOLD}"
echo "========================================================================"
echo "      🔗 GIT REMOTE & AUTHENTICATION SETUP WIZARD                       "
echo "========================================================================"
echo -e "${RESET}"

if [ ! -d "$VAULT_DIR" ]; then
  echo -e "${RED}Error: Vault directory '$VAULT_DIR' not found.${RESET}"
  exit 1
fi

cd "$VAULT_DIR"

# Ensure Git repo is initialized
if [ ! -d ".git" ]; then
  echo -e "${YELLOW}Initializing Git repository in $VAULT_DIR...${RESET}"
  git init
  git branch -M main
fi

# Set user name & email if not set globally
if [ -z "$(git config user.name)" ]; then
  read -r -p "$(echo -e "${BOLD}Enter your Git Name (e.g. John Doe): ${RESET}")" GIT_NAME
  git config user.name "${GIT_NAME:-User}"
fi

if [ -z "$(git config user.email)" ]; then
  read -r -p "$(echo -e "${BOLD}Enter your Git Email: ${RESET}")" GIT_EMAIL
  git config user.email "${GIT_EMAIL:-user@example.com}"
fi

echo -e "\nSelect your Git Remote Hosting Platform:"
echo "  1) GitHub (https://github.com)"
echo "  2) GitLab (https://gitlab.com)"
echo "  3) Codeberg (https://codeberg.org)"
echo "  4) Custom Remote URL (Any Git Server)"
echo "  5) Cancel / Skip for now"

read -r -p "$(echo -e "\n${BOLD}Select option [1-5]: ${RESET}")" PLATFORM_CHOICE

if [ "$PLATFORM_CHOICE" == "5" ]; then
  echo -e "${YELLOW}Git remote configuration skipped.${RESET}"
  exit 0
fi

# Ask for Remote URL
read -r -p "$(echo -e "\n${BOLD}Enter your Remote Repository URL (e.g. https://github.com/username/notes.git or git@github.com:username/notes.git): ${RESET}")" REMOTE_URL

if [ -z "$REMOTE_URL" ]; then
  echo -e "${RED}Remote URL cannot be empty.${RESET}"
  exit 1
fi

# Configure Remote URL
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE_URL"
git branch -M main

echo -e "\n${GREEN}✓ Remote URL configured: ${BOLD}$REMOTE_URL${RESET}\n"

# Authentication Method Prompt
echo "Select Authentication Method:"
echo "  1) Personal Access Token (PAT) / HTTPS (Recommended for quick setup)"
echo "  2) SSH Key (Recommended for seamless passwordless sync)"
echo "  3) GitHub CLI (gh auth login - GitHub only)"
echo "  4) Already configured / Skip authentication"

read -r -p "$(echo -e "\n${BOLD}Select authentication method [1-4]: ${RESET}")" AUTH_CHOICE

if [ "$AUTH_CHOICE" == "1" ]; then
  read -r -p "$(echo -e "${BOLD}Enter your Personal Access Token (PAT): ${RESET}")" PAT_TOKEN
  if [ -n "$PAT_TOKEN" ]; then
    # Inject PAT token into HTTPS URL if HTTPS
    if [[ "$REMOTE_URL" == https://* ]]; then
      TOKEN_URL="${REMOTE_URL#https://}"
      AUTH_REMOTE="https://${PAT_TOKEN}@${TOKEN_URL}"
      git remote set-url origin "$AUTH_REMOTE"
      echo -e "${GREEN}✓ Token authenticated remote URL configured securely.${RESET}"
    fi
    # Store credentials in git credential store
    git config credential.helper store
  fi

elif [ "$AUTH_CHOICE" == "2" ]; then
  SSH_KEY="$HOME/.ssh/id_ed25519"
  if [ ! -f "$SSH_KEY" ] && [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo -e "${YELLOW}No SSH key found. Generating a new ed25519 SSH key...${RESET}"
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$(git config user.email)" -f "$SSH_KEY" -N ""
  fi

  ACTUAL_KEY="$SSH_KEY"
  [ ! -f "$ACTUAL_KEY" ] && ACTUAL_KEY="$HOME/.ssh/id_rsa"

  echo -e "\n${GREEN}${BOLD}Your Public SSH Key:${RESET}"
  cat "${ACTUAL_KEY}.pub"
  echo -e "\n${YELLOW}👉 Copy the public SSH key above and paste it into your GitHub/GitLab SSH settings!${RESET}"

elif [ "$AUTH_CHOICE" == "3" ]; then
  if command -v gh >/dev/null 2>&1; then
    gh auth login
  else
    echo -e "${RED}GitHub CLI (gh) is not installed. Using standard Git auth.${RESET}"
  fi
fi

# Attempt initial push
echo -e "\n${BLUE}🚀 Testing Git connection and pushing initial commit...${RESET}"
git add -A
git commit -m "Initial notes sync" 2>/dev/null || true

if git push -u origin main; then
  echo -e "\n${GREEN}${BOLD}🎉 SUCCESS! Your notes vault is connected and synced with remote repository!${RESET}\n"
else
  echo -e "\n${YELLOW}⚠️ Push failed or requires authentication. You can run 'git push' manually once authenticated.${RESET}\n"
fi
