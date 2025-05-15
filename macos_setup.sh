#!/bin/bash

# ⚠️ SECURITY WARNING ⚠️
# Please review this script before running it via curl | bash
# Recommended: Download and inspect the script first, then run locally
# Running scripts directly from the internet can be dangerous

# Strict error handling
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging function
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Arrays of taps to add
TAPS=(
    "homebrew/bundle"
    "homebrew/core"
    "homebrew/cask"
    "mitchellh/ghostty"
    "buo/cask-upgrade"
    "homebrew/cask-fonts"
)

# Arrays of tools to install
CLI_TOOLS=(
    "git"
    "node"
    "zsh"
    "zsh-completions"
    "zsh-syntax-highlighting"
    "mas"
    "gh"
    "gnupg"
    "pinentry-mac"
)

GUI_APPS=(
    "visual-studio-code"
    "ghostty"
    "readdle-spark"
)

# Fonts to install
FONTS=(
    "font-fira-code"
    "font-jetbrains-mono"
)

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    log "${RED}Do not run this script as root/sudo${NC}"
    exit 1
fi

# Install Homebrew
install_homebrew() {
    log "Checking for Homebrew..."
    if ! command -v brew &>/dev/null; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Configure Homebrew PATH for Apple Silicon Macs
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        log "${GREEN}Homebrew already installed${NC}"
    fi
}

# Add Homebrew taps
add_taps() {
    log "Adding Homebrew taps..."
    for tap in "${TAPS[@]}"; do
        if ! brew tap | grep -q "^${tap}$"; then
            log "Tapping $tap..."
            brew tap "$tap"
        else
            log "${GREEN}$tap already tapped${NC}"
        fi
    done
}

# Install Command Line Tools
install_cli_tools() {
    log "Installing CLI tools..."
    for tool in "${CLI_TOOLS[@]}"; do
        if ! brew list "$tool" &>/dev/null; then
            log "Installing $tool..."
            brew install "$tool"
        else
            log "${GREEN}$tool already installed${NC}"
        fi
    done
}

# Install GUI Applications
install_gui_apps() {
    log "Installing GUI applications..."
    for app in "${GUI_APPS[@]}"; do
        if ! brew list --cask "$app" &>/dev/null; then
            log "Installing $app..."
            brew install --cask "$app"
        else
            log "${GREEN}$app already installed${NC}"
        fi
    done
}

# Install Fonts
install_fonts() {
    log "Installing fonts..."
    for font in "${FONTS[@]}"; do
        if ! brew list --cask "$font" &>/dev/null; then
            log "Installing $font..."
            brew install --cask "$font"
        else
            log "${GREEN}$font already installed${NC}"
        fi
    done
}

# Configure macOS Settings
configure_macos() {
    log "Configuring macOS settings..."
    
    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles YES
    
    # Set key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    
    # Optional: Disable Gatekeeper (commented out by default)
    # WARNING: This reduces system security. Only uncomment if you know what you're doing.
    # sudo spctl --master-disable
    
    # Disable boot sound
    sudo nvram SystemAudioVolume=" "
    
    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    
    # Show status bar in Finder
    defaults write com.apple.finder ShowStatusBar -bool true
    
    # Show path bar in Finder
    defaults write com.apple.finder ShowPathbar -bool true
    
    # Restart Finder to apply changes
    killall Finder
}

# Configure GPG and pinentry-mac
configure_gpg() {
    log "Configuring GPG and pinentry-mac..."
    
    # Create .gnupg directory with correct permissions
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg

    # Configure GPG to use pinentry-mac
    cat > ~/.gnupg/gpg-agent.conf << EOL
pinentry-program /opt/homebrew/bin/pinentry-mac
default-cache-ttl 3600
max-cache-ttl 7200
EOL

    # Configure GPG to use UTF-8
    cat > ~/.gnupg/gpg.conf << EOL
use-agent
utf8-strings
EOL

    # Add GPG configuration to shell if not already present
    if ! grep -q "export GPG_TTY" "${ZDOTDIR:-$HOME}/.zshrc"; then
        echo -e "\n# GPG configuration\nexport GPG_TTY=\$(tty)" >> "${ZDOTDIR:-$HOME}/.zshrc"
    fi

    # Restart gpg-agent
    gpgconf --kill gpg-agent

    log "${GREEN}GPG configuration complete!${NC}"
    log "To create a new GPG key, run: gpg --full-generate-key"
    log "To list your GPG keys, run: gpg --list-secret-keys --keyid-format=long"
}

# Main execution
main() {
    log "${YELLOW}Starting macOS setup...${NC}"
    
    # Ensure system is up to date
    log "Checking for system updates..."
    softwareupdate --install --all
    
    # Install and configure components
    install_homebrew
    add_taps
    install_cli_tools
    install_gui_apps
    install_fonts
    configure_macos
    configure_gpg
    
    log "${GREEN}✅ Setup complete!${NC}"
    log "${YELLOW}Note: Some changes may require a system restart to take effect${NC}"
}

# Execute main function
main 