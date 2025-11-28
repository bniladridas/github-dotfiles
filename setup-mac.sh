#!/bin/bash

# SPDX-License-Identifier: MIT

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

echo "Installing Cocoapods..."
brew install cocoapods

echo "Installing Rust..."
brew install rust

echo "Installing Go..."
brew install go

echo "Installing LLVM..."
brew install llvm

echo "Installing GitHub CLI..."
brew install gh

echo "Installing GitLab CLI..."
brew install glab

echo "Installing pipx..."
brew install pipx

echo "Installing pre-commit..."
export PATH="$HOME/.local/bin:$PATH"
pipx install pre-commit

echo "Installing shellcheck..."
brew install shellcheck

echo "Installing actionlint..."
brew install actionlint

echo "Installing yamllint..."
brew install yamllint

echo "Installing Flutter..."
brew install flutter

echo "Installing Dart SDK..."
brew install dart-sdk

echo "Installing Docker CLI..."
brew install docker

echo "Installing QEMU..."
brew install qemu

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
if [ -f ~/github-dotfiles/.gitconfig ]; then
  cp ~/github-dotfiles/.gitconfig ~/.gitconfig
  echo "Git aliases configured."
else
  echo "Git config file not found; clone the repo first."
fi

echo "Setting up Git hooks..."
git config --global core.hooksPath ~/github-dotfiles/git-hooks
chmod +x ~/github-dotfiles/git-hooks/*

echo "Verifying Git hooks setup..."
git config --global core.hooksPath

echo "Configuring commit message scope brackets..."
read -r -p "Choose bracket type for commit scopes (1 for [], 2 for ()): " bracket_choice
if [ "$bracket_choice" = "1" ]; then
  sed -i '' 's/(\[.+?\]|\(.+?\))/(\[.+\])/g' ~/github-dotfiles/git-hooks/pre-push
  echo "Set to [] brackets."
elif [ "$bracket_choice" = "2" ]; then
  sed -i '' 's/(\[.+?\]|\(.+?\))/(\(.+\))/g' ~/github-dotfiles/git-hooks/pre-push
  echo "Set to () brackets."
else
  echo "Invalid choice, keeping default []."
fi

echo "Activating dotfiles CLI..."
cd ~/github-dotfiles
dart pub global activate --source path .
echo "export PATH=\"\$PATH:\$HOME/.pub-cache/bin\"" >> ~/.zshrc

echo "Setup complete! Please restart your terminal or run 'source ~/.zshrc' to apply changes."
