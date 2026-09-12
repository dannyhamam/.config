#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/.config"

echo "====================================================="
echo "🚀 Bootstrapping development environment from $DOTFILES_DIR"
echo "====================================================="

# 0. Install system dependencies for Neovim (portable)
# NOTE: vim.pack auto-installs Neovim plugins, but external tools like
# the C compiler, make, ripgrep, and the tree-sitter CLI must come from the OS.
# Without these, nvim-treesitter fails with: ENOENT 'tree-sitter'
if ! command -v brew >/dev/null 2>&1; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# NOTE: brew 'tree-sitter' is only the library now, the CLI Neovim needs is 'tree-sitter-cli'
brew install neovim git ripgrep fd unzip make tree-sitter-cli
echo "✅ Installed Neovim system dependencies via Homebrew"

# 1. Symlink ~/.zshrc -> ~/.config/zsh/.zshrc
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "📦 Backing up existing non-symlink ~/.zshrc to ~/.zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
echo "✅ Linked ~/.zshrc -> ~/.config/zsh/.zshrc"

# 2. Link iTerm2 Dynamic Profile (Tokyo Night for 'main' profile)
ITERM_APP_SUPPORT="$HOME/Library/Application Support/iTerm2"
mkdir -p "$ITERM_APP_SUPPORT/DynamicProfiles"
mkdir -p "$DOTFILES_DIR/iterm2/DynamicProfiles"

if [ -f "$DOTFILES_DIR/iterm2/DynamicProfiles/main.json" ]; then
    ln -sf "$DOTFILES_DIR/iterm2/DynamicProfiles/main.json" "$ITERM_APP_SUPPORT/DynamicProfiles/main.json"
    echo "✅ Linked Tokyo Night 'main' Profile into iTerm2"
fi

# 3. Configure iTerm2 Split Pane & Default Profile
if command -v defaults >/dev/null 2>&1; then
    defaults write com.googlecode.iterm2 DimInactiveSplitPanes -bool true
    defaults write com.googlecode.iterm2 SplitPaneDimmingAmount -float 0.35
    defaults write com.googlecode.iterm2 ShowPaneTitles -bool true
    defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "main-tokyonight"
    echo "✅ Configured iTerm2 split-pane dimming, pane titles, and default 'main' profile"
fi

echo ""
echo "🎉 Setup complete! Open a new iTerm2 tab or run 'source ~/.zshrc'."
