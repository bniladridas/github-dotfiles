#!/bin/bash

# Safe Homebrew update script
# Updates Homebrew formulae and upgrades installed packages

set -euo pipefail

echo "Updating Homebrew..."
brew update

echo "Upgrading installed packages..."
brew upgrade

echo "Homebrew update and upgrade completed successfully."
