#!/bin/bash

# Safe Homebrew install script for common utilities
# Installs useful command-line utilities

set -euo pipefail

echo "Installing common utilities via Homebrew..."

brew install htop \
    tmux \
    vim \
    neovim \
    curl \
    git-lfs

echo "Common utilities installed successfully."
