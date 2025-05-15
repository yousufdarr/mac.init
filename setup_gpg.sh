#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "🔐 Setting up GPG and pinentry-mac..."

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

# Add GPG configuration to shell
cat >> ~/.zshrc << EOL

# GPG configuration
export GPG_TTY=\$(tty)
EOL

# Restart gpg-agent
gpgconf --kill gpg-agent

echo -e "${GREEN}✅ GPG configuration complete!${NC}"
echo "To create a new GPG key, run: gpg --full-generate-key"
echo "To list your GPG keys, run: gpg --list-secret-keys --keyid-format=long" 