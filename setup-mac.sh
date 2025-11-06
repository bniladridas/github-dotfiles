#!/bin/bash

# Mac Setup Script
# This script sets up a new Mac with Zsh, Homebrew, and opencode.

set -e

echo "Setting up Zsh prompt..."
touch ~/.zshrc
echo 'PS1="$ "' >> ~/.zshrc
# shellcheck disable=SC1090
source ~/.zshrc

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Configuring Homebrew in Zsh..."
# shellcheck disable=SC2016
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

echo "Installing Python..."
brew install python

echo "Installing Node.js and npm..."
brew install node

echo "Installing Ruby..."
brew install ruby

echo "Installing GitHub CLI..."
brew install gh

echo "Installing Docker CLI..."
brew install docker

echo "Setting up Git config..."
if [ -f ~/GitHub-dotfiles/.gitconfig ]; then
  cp ~/GitHub-dotfiles/.gitconfig ~/.gitconfig
  echo "Git aliases configured."
else
  echo "Git config file not found; clone the repo first."
fi

echo "Setup complete! Please restart your terminal or run 'source ~/.zprofile' to apply changes."
