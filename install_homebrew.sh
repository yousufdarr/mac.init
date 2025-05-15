#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "🍺 Starting Homebrew installation..."

# Check if Homebrew is already installed
if command -v brew &>/dev/null; then
    echo -e "${RED}Homebrew is already installed!${NC}"
    exit 0
fi

# Install Xcode Command Line Tools if not installed
if ! command -v xcode-select &>/dev/null; then
    echo "📦 Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⏳ Waiting for Xcode Command Line Tools installation..."
    echo "Please complete the installation window that has opened..."
    read -p "Press enter once installation is complete..."
fi

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH for Apple Silicon Macs
if [[ $(uname -m) == 'arm64' ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo -e "${GREEN}✅ Homebrew installation complete!${NC}" 