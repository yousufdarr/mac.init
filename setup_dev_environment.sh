#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "🚀 Setting up development environment..."

# 1. Install Homebrew
./install_homebrew.sh

# 2. Install Oh My Zsh
echo "💻 Installing Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${RED}Oh My Zsh is already installed!${NC}"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Install all tools from Brewfile
echo "📦 Installing development tools from Brewfile..."
brew bundle

# 4. Configure zsh-syntax-highlighting
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    echo "source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
fi

# 5. Add useful aliases
echo "🔧 Adding useful aliases..."
if ! grep -q "alias bu=" "${ZDOTDIR:-$HOME}/.zshrc"; then
    echo -e "\n# Useful aliases\nalias bu=\"brew update && brew upgrade\"" >> ${ZDOTDIR:-$HOME}/.zshrc
    echo -e "${GREEN}Added brew update alias (bu)${NC}"
fi

# 6. Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
fi

echo -e "${GREEN}✅ Development environment setup complete!${NC}"
echo "🎉 Please restart your terminal to apply all changes." 