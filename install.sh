#!/usr/bin/env bash
# Installer script for cronminder plugin
# Usage: curl -sSL https://raw.githubusercontent.com/aaronbronow/cronminder/main/install.sh | bash
set -euo pipefail

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}⚡ Installing cronminder plugin...${NC}"

SHELL_NAME=$(basename "${SHELL:-zsh}")
OMZ_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ "$SHELL_NAME" == "zsh" ]] && [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${CYAN}Oh My Zsh environment detected.${NC}"
    PLUGIN_DIR="$OMZ_DIR/plugins/cronminder"
    IS_OMZ=true
else
    echo -e "${CYAN}Generic shell environment detected.${NC}"
    PLUGIN_DIR="$HOME/.cronminder"
    IS_OMZ=false
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$PLUGIN_DIR" != "$SCRIPT_DIR" ]; then
    mkdir -p "$(dirname "$PLUGIN_DIR")"
    rm -rf "$PLUGIN_DIR"
    ln -s "$SCRIPT_DIR" "$PLUGIN_DIR"
    echo -e "${GREEN}✓ Created symlink: $PLUGIN_DIR -> $SCRIPT_DIR${NC}"
fi

RC_FILE="$HOME/.zshrc"
if [ -f "$RC_FILE" ]; then
    if grep -q "cronminder" "$RC_FILE"; then
        echo -e "${GREEN}✓ cronminder is already enabled in $RC_FILE!${NC}"
    else
        echo -e "${YELLOW}! Remember to add cronminder to your plugins list in $RC_FILE:${NC}"
        echo -e "  plugins=(... ${CYAN}cronminder${NC})"
    fi
fi

echo -e "\n${GREEN}✓ Installation complete! Run ${BLUE}source $RC_FILE${NC}${GREEN} to reload.${NC}\n"
