#!/bin/bash

# Safe Homebrew install script for common development tools
# Installs frequently used packages for development

set -euo pipefail

echo "Installing common development tools via Homebrew..."

# Version control
brew install git

# Programming languages and runtimes
brew install python@3.12
brew install node
brew install rust
brew install go

# Package managers and tools
brew install npm
brew install yarn

# Development utilities
brew install jq
brew install tree
brew install wget

echo "Common development tools installed successfully."
echo "Note: Python is installed as python@3.12. Use 'python3' to run it."
