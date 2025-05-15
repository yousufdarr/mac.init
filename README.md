# macOS System Setup Script

This script automates the setup of a fresh macOS system with development tools, applications, and system configurations.

## 🚨 Security Warning

Before running this script, please be aware of the following security considerations:

1. **Never blindly run scripts from the internet** using `curl | bash`. This is dangerous because:
   - The connection could be intercepted (MITM attack)
   - The source could be compromised
   - The script could be modified during transfer

2. **Recommended Usage:**
   - Download the script first
   - Review the code thoroughly
   - Run it locally after verification

## 🚀 Usage

### Safe Method (Recommended)

```bash
# Download the script
curl -O https://your-domain.com/macos_setup.sh

# Review the script content
less macos_setup.sh

# Make it executable
chmod +x macos_setup.sh

# Run the script
./macos_setup.sh
```

### Direct Method (Not Recommended)

```bash
curl -fsSL https://your-domain.com/macos_setup.sh | bash
```

## ✨ Features

### Package Management
- Installs and configures Homebrew
- Configures necessary Homebrew taps:
  - homebrew/bundle
  - homebrew/core
  - homebrew/cask
  - mitchellh/ghostty
  - buo/cask-upgrade
  - homebrew/cask-fonts

### Development Tools
- Essential CLI tools:
  - git
  - node
  - zsh (with completions and syntax highlighting)
  - mas (Mac App Store CLI)
  - gh (GitHub CLI)
  - gnupg
  - pinentry-mac

### Applications
- Visual Studio Code
- Ghostty (terminal emulator)
- Readdle Spark (email client)

### Development Fonts
- Fira Code
- JetBrains Mono

### System Configuration
- Shows hidden files in Finder
- Sets optimal key repeat rates
- Configures Finder preferences
- Disables boot sound
- Shows file extensions globally
- Enables Finder status and path bars

### GPG Setup
- Configures GPG for secure commit signing
- Sets up pinentry-mac for password prompts
- Configures GPG agent with sensible cache timeouts
- Adds necessary environment variables to shell
- Provides guidance for key generation and management

## 🔧 Post-Setup Tasks

### 1. GPG Key Generation

After the script completes, you can set up your GPG key:

```bash
# Generate a new GPG key
gpg --full-generate-key
# Use RSA and RSA, 4096 bits, and your GitHub email

# List your key ID
gpg --list-secret-keys --keyid-format=long

# Configure Git
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true

# Export your public key for GitHub
gpg --armor --export YOUR_KEY_ID
```

Add to GitHub:
1. Copy the exported GPG key
2. Go to GitHub Settings → SSH and GPG keys
3. Click "New GPG key"
4. Paste your public key

### 2. Shell Configuration

The script configures Zsh with syntax highlighting. You may want to:
- Choose a different theme
- Add additional plugins
- Customize your prompt

## 💻 Compatibility

- Designed for macOS with Apple Silicon
- Compatible with Intel Macs (automatically detects architecture)
- Tested on macOS Sonoma (14.0) and later

## ⚠️ Notes

- Some changes require a system restart to take effect
- The script is idempotent (safe to run multiple times)
- Gatekeeper disable option is commented out by default for security
- Requires admin privileges for some operations (will prompt for sudo password)

## 🤝 Contributing

Feel free to fork and modify this script for your needs. If you make improvements, please consider submitting a pull request. 