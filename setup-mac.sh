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

echo "Setting up Docker Hub..."
read -r -p "Do you want to log in to Docker Hub as 'harpertoken'? (y/N): " login_choice
if [[ "$login_choice" =~ ^[Yy]$ ]]; then
  read -r -p "Enter Docker Hub token: " docker_token
  if [ -n "$docker_token" ]; then
    echo "$docker_token" | docker login -u harpertoken --password-stdin
    echo "Logged in to Docker Hub as harpertoken."
  else
    echo "No token provided, skipped."
  fi
else
  echo "Skipped Docker Hub login."
fi

echo "Setting up Git config..."
if [ -f ~/GitHub-dotfiles/.gitconfig ]; then
  cp ~/GitHub-dotfiles/.gitconfig ~/.gitconfig
  echo "Git aliases configured."
else
  echo "Git config file not found; clone the repo first."
fi

echo "Configuring commit message scope brackets..."
read -r -p "Choose bracket type for commit scopes (1 for [], 2 for ()): " bracket_choice
if [ "$bracket_choice" = "1" ]; then
  sed -i '' 's/(\[.+?\]|\(.+?\))/(\[.+\])/g' ~/GitHub-dotfiles/git-hooks/pre-push
  echo "Set to [] brackets."
elif [ "$bracket_choice" = "2" ]; then
  sed -i '' 's/(\[.+?\]|\(.+?\))/(\(.+\))/g' ~/GitHub-dotfiles/git-hooks/pre-push
  echo "Set to () brackets."
else
  echo "Invalid choice, keeping default []."
fi

echo "Setup complete! Please restart your terminal or run 'source ~/.zprofile' to apply changes."
