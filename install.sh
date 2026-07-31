#!/usr/bin/env bash
# ==============================================================================
# Cross-Platform Neovim + Obsidian Note-Taking Setup Installer (Linux)
# Author: Timothy (CoolBroTim)
# Repository: https://github.com/CoolBroTim/neovim-obsidian-setup
# ==============================================================================

set -e

# Colors
BOLD="\033[1m"
GREEN="\033[32m"
BLUE="\033[34m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${BLUE}${BOLD}"
echo "========================================================================"
echo "      🚀 NEOVIM + OBSIDIAN CROSS-PLATFORM NOTE VAULT INSTALLER         "
echo "========================================================================"
echo -e "${RESET}"

# ------------------------------------------------------------------------------
# 1. User Preference Prompts
# ------------------------------------------------------------------------------

# Vault Location Prompt
DEFAULT_VAULT="$HOME/Notes"
read -r -p "$(echo -e "${BOLD}Where would you like to store your Notes vault? [Default: $DEFAULT_VAULT]: ${RESET}")" USER_VAULT
VAULT_PATH="${USER_VAULT:-$DEFAULT_VAULT}"
VAULT_PATH="${VAULT_PATH/#\~/$HOME}"

# Detect Terminal Emulator
DETECTED_TERM="terminal"
if command -v kitty >/dev/null 2>&1; then DETECTED_TERM="kitty";
elif command -v alacritty >/dev/null 2>&1; then DETECTED_TERM="alacritty";
elif command -v foot >/dev/null 2>&1; then DETECTED_TERM="foot";
elif command -v konsole >/dev/null 2>&1; then DETECTED_TERM="konsole";
elif command -v gnome-terminal >/dev/null 2>&1; then DETECTED_TERM="gnome-terminal";
fi

read -r -p "$(echo -e "${BOLD}Terminal emulator for desktop launchers [Detected: $DETECTED_TERM]: ${RESET}")" USER_TERM
TERM_EMULATOR="${USER_TERM:-$DETECTED_TERM}"

echo -e "\n${GREEN}✓ Installing vault at: ${BOLD}$VAULT_PATH${RESET}"
echo -e "${GREEN}✓ Using terminal launcher: ${BOLD}$TERM_EMULATOR${RESET}\n"

# ------------------------------------------------------------------------------
# 2. Dependency Checks & Installation
# ------------------------------------------------------------------------------
echo -e "${BLUE}🔍 Checking dependencies (neovim, fd, ripgrep, git, python3)...${RESET}"
mkdir -p "$HOME/.local/bin"

if ! command -v nvim >/dev/null 2>&1; then
  echo -e "${YELLOW}Installing Neovim binary release to ~/.local/bin...${RESET}"
  curl -sL https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz | tar -xz -C "$HOME/.local" --strip-components=1
fi

if ! command -v fd >/dev/null 2>&1; then
  echo -e "${YELLOW}Installing fd binary release to ~/.local/bin...${RESET}"
  curl -sL https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz | tar -xz -C /tmp && cp /tmp/fd-v10.2.0-x86_64-unknown-linux-musl/fd "$HOME/.local/bin/" && chmod +x "$HOME/.local/bin/fd"
fi

# Ensure ~/.local/bin in PATH
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------------------
# 3. Deploy Neovim Configuration
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/nvim"

if [ -d "$CONFIG_DIR" ]; then
  BACKUP_DIR="${CONFIG_DIR}.bak.$(date +%Y%m%d_%H%M%S)"
  echo -e "${YELLOW}Backing up existing Neovim config to: $BACKUP_DIR${RESET}"
  mv "$CONFIG_DIR" "$BACKUP_DIR"
fi

echo -e "${BLUE}📦 Deploying Neovim configuration...${RESET}"
mkdir -p "$CONFIG_DIR"
cp -r "$SCRIPT_DIR/config_template/"* "$CONFIG_DIR/"

# Replace hardcoded vault paths in Neovim configuration files
find "$CONFIG_DIR" -type f -exec sed -i "s|/home/timothy/Notes|$VAULT_PATH|g" {} +

# ------------------------------------------------------------------------------
# 4. Deploy Vault Directory Structure & Git Init
# ------------------------------------------------------------------------------
echo -e "${BLUE}📁 Initializing PARA Vault directory structure...${RESET}"
for folder in 00-Inbox 10-Projects 20-Areas 30-Resources 40-Archive Daily Templates scripts; do
  mkdir -p "$VAULT_PATH/$folder"
  touch "$VAULT_PATH/$folder/.gitkeep"
done

# Copy scripts
cp -r "$SCRIPT_DIR/vault_template/scripts/"* "$VAULT_PATH/scripts/"
chmod +x "$VAULT_PATH/scripts/"*.py "$VAULT_PATH/scripts/"*.sh 2>/dev/null || true
find "$VAULT_PATH/scripts" -type f -exec sed -i "s|/home/timothy/Notes|$VAULT_PATH|g" {} +

# Initialize Git repository
if [ ! -d "$VAULT_PATH/.git" ]; then
  cd "$VAULT_PATH"
  git init
  cat << 'EOF' > "$VAULT_PATH/.gitignore"
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/appearance.json
.obsidian/hotkeys.json
.DS_Store
*.tmp
*.swp
*.swo
EOF
  git add -A
  git commit -m "Initial commit: PARA Vault structure" || true
fi

# ------------------------------------------------------------------------------
# 5. Git Remote & Authentication Setup Wizard
# ------------------------------------------------------------------------------
read -r -p "$(echo -e "${BOLD}Would you like to connect your Notes vault to GitHub/GitLab/Codeberg now? [y/N]: ${RESET}")" SETUP_GIT_CHOICE
if [[ "$SETUP_GIT_CHOICE" =~ ^[Yy]$ ]]; then
  bash "$VAULT_PATH/scripts/setup_git.sh" "$VAULT_PATH"
fi

# ------------------------------------------------------------------------------
# 6. Deploy Aliases & Desktop Launcher
# ------------------------------------------------------------------------------
echo -e "${BLUE}🖥️ Configuring terminal aliases & application launcher...${RESET}"

# Bash / Zsh alias
ALIAS_CMD="alias notes='cd $VAULT_PATH && nvim'"
grep -q "$ALIAS_CMD" "$HOME/.bashrc" 2>/dev/null || echo -e "\nexport PATH=\"\$HOME/.local/bin:\$PATH\"\n$ALIAS_CMD" >> "$HOME/.bashrc"
if [ -f "$HOME/.zshrc" ]; then
  grep -q "$ALIAS_CMD" "$HOME/.zshrc" 2>/dev/null || echo -e "\nexport PATH=\"\$HOME/.local/bin:\$PATH\"\n$ALIAS_CMD" >> "$HOME/.zshrc"
fi
if [ -d "$HOME/.config/fish" ]; then
  mkdir -p "$HOME/.config/fish"
  grep -q "alias notes" "$HOME/.config/fish/config.fish" 2>/dev/null || echo -e "\nalias notes='cd $VAULT_PATH && nvim'\nfish_add_path ~/.local/bin" >> "$HOME/.config/fish/config.fish"
fi

# Desktop Entry for Rofi / Wofi / Hyprlauncher
mkdir -p "$HOME/.local/share/applications"
cat << EOF > "$HOME/.local/share/applications/notes.desktop"
[Desktop Entry]
Type=Application
Name=Notes Vault
GenericName=Markdown Note Taking Vault
Comment=Open Neovim Notes Vault
Exec=$TERM_EMULATOR --title "Notes Vault" bash -c "cd $VAULT_PATH && ~/.local/bin/nvim"
Icon=text-x-generic
Terminal=false
Categories=Utility;TextEditor;Office;
Keywords=notes;vault;obsidian;neovim;markdown;
EOF

update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

# ------------------------------------------------------------------------------
# 7. Pre-sync Neovim Plugins
# ------------------------------------------------------------------------------
echo -e "${BLUE}⚡ Initializing Neovim plugins headlessly...${RESET}"
"$HOME/.local/bin/nvim" --headless "+Lazy! sync" +qa >/dev/null 2>&1 || true

echo -e "\n${GREEN}${BOLD}========================================================================"
echo "🎉 INSTALLATION COMPLETE!"
echo "========================================================================"
echo -e "${RESET}"
echo -e "• Launch from terminal: ${BOLD}notes${RESET}"
echo -e "• Launch from Rofi/Wofi: ${BOLD}Notes Vault${RESET}"
echo -e "• Vault location: ${BOLD}$VAULT_PATH${RESET}"
echo -e "• Press ${BOLD}<Space>h${RESET} inside Neovim anytime for the Cheat Sheet!\n"
