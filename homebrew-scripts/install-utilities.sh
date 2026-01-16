#!/bin/bash

# Safe Homebrew install script for common utilities
# Installs useful command-line utilities

set -euo pipefail

echo "Installing common utilities via Homebrew..."

brew install htop
brew install tmux
brew install vim
brew install neovim
brew install curl
brew install git-lfs

echo "Common utilities installed successfully."
