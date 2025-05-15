# Mac Development Environment Setup

Automated setup scripts for a fresh macOS development environment.

## 🚀 Quick Setup

1. Clone this repository
2. Make the scripts executable:
   ```bash
   chmod +x *.sh
   ```
3. Run the setup script:
   ```bash
   ./setup_dev_environment.sh
   ```

## 📦 What Gets Installed

### Command Line Tools
- Homebrew (package manager)
- Git
- Node.js
- GitHub CLI (gh)
- GPG and pinentry-mac (for commit signing)
- Zsh with Oh My Zsh

### Applications
- Visual Studio Code
- Ghostty (terminal emulator)
- Readdle Spark (email client)

### Development Fonts
- Fira Code
- JetBrains Mono

## 🔧 Post-Setup Configuration

### 1. GPG Setup for Git Commit Signing

Run the GPG setup script:
```bash
./setup_gpg.sh
```

Then set up your GPG key:
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

### 2. Oh My Zsh Configuration

Edit `~/.zshrc` to add useful plugins:
```bash
# Recommended plugins
plugins=(
  git
  node
  npm
  docker
  zsh-syntax-highlighting
)

# Optional: Change theme
ZSH_THEME="agnoster"
```

Note: The setup script automatically adds useful aliases including:
- `bu` - shorthand for `brew update && brew upgrade`

### 3. Ghostty Configuration

Create or edit `