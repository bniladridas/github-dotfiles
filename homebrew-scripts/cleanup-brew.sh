#!/bin/bash

# Safe Homebrew cleanup script
# Removes old versions and unused dependencies

set -euo pipefail

echo "Cleaning up Homebrew..."

# Remove old versions of formulae
brew cleanup

# Remove formulae that are no longer needed
brew autoremove

echo "Homebrew cleanup completed successfully."
