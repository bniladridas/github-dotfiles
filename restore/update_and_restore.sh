#!/bin/bash

# SPDX-License-Identifier: MIT

# Update and Restore Script
# This script updates the repository and restores dotfiles to the home directory.

set -e

echo "Updating repository..."
git pull

echo "Restoring dotfiles..."

# List of dotfiles to restore
dotfiles=(".gitconfig" ".pre-commit-config.yaml" ".yamllint")

for file in "${dotfiles[@]}"; do
  if [ -f "$file" ]; then
    cp "$file" ~/
    echo "Restored $file"
  fi
done

echo "Setting up Git hooks..."
git config --global core.hooksPath ~/github-dotfiles/git-hooks
chmod +x ~/github-dotfiles/git-hooks/*

echo "Restore complete!"
