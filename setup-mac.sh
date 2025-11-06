#!/bin/bash

# Mac Setup Script
# This script sets up a new Mac with Zsh, Homebrew, and opencode.

set -e

echo "Setting up Zsh prompt..."
touch ~/.zshrc
echo 'PS1="$ "' >> ~/.zshrc
source ~/.zshrc

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Configuring Homebrew in Zsh..."
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Verifying Homebrew installation..."
brew --version

echo "Setting Zsh as default shell..."
chsh -s /bin/zsh

echo "Verifying installations..."
zsh --version
brew --version
echo "Current shell: $SHELL"

echo "Installing opencode..."
brew install opencode

echo "Setup complete! Please restart your terminal or run 'source ~/.zprofile' to apply changes."