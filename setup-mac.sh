#!/bin/bash

# SPDX-License-Identifier: MIT

# Mac Setup Script
# This script sets up a new Mac with Zsh, Homebrew, and opencode.

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Logging function
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

echo "Setting up Zsh prompt..."
touch ~/.zshrc
echo 'PS1="$ "' >> ~/.zshrc
# shellcheck disable=SC1090
source ~/.zshrc

log "Installing Homebrew..."
if ! command -v brew &> /dev/null; then
  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    log "Homebrew installed successfully."
  else
    log "ERROR: Failed to install Homebrew."
    exit 1
  fi
else
  log "Homebrew already installed, skipping."
fi

log "Configuring Homebrew in Zsh..."
# shellcheck disable=SC2016
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

log "Verifying Homebrew installation..."
if brew --version &> /dev/null; then
  log "Homebrew verified."
else
  log "ERROR: Homebrew verification failed."
  exit 1
fi

log "Setting Zsh as default shell..."
if chsh -s /bin/zsh; then
  log "Zsh set as default shell."
else
  log "ERROR: Failed to set Zsh as default shell."
  exit 1
fi

log "Verifying installations..."
if zsh --version &> /dev/null && brew --version &> /dev/null; then
  log "Installations verified."
  echo "Current shell: $SHELL"
else
  log "ERROR: Installation verification failed."
  exit 1
fi

echo "Installing opencode..."
brew install opencode

echo "Installing Kiro CLI..."
KIRO_INSTALL_SCRIPT=$(mktemp)
if curl -fsSL https://cli.kiro.dev/install -o "$KIRO_INSTALL_SCRIPT"; then
  bash "$KIRO_INSTALL_SCRIPT"
  rm "$KIRO_INSTALL_SCRIPT"
  log "Kiro CLI installed successfully."
else
  log "ERROR: Failed to download or install Kiro CLI."
  exit 1
fi

echo "Installing Ollama..."
brew install ollama

echo "Building Ollama..."
cd "$SCRIPT_DIR/ollama"
if cargo build --release; then
  log "Ollama built successfully."
else
  log "ERROR: Failed to build Ollama."
  exit 1
fi

log "Installing Python..."
if brew install python; then
  log "Python installed."
else
  log "ERROR: Failed to install Python."
  exit 1
fi

log "Installing Node.js and npm..."
if brew install node; then
  log "Node.js and npm installed."
else
  log "ERROR: Failed to install Node.js."
  exit 1
fi

echo "Installing Ruby..."
read -r -p "Choose Ruby installation method (1 for direct brew install, 2 for rbenv): " ruby_choice
case "$ruby_choice" in
  2)
    log "Installing rbenv..."
    if ! brew install rbenv; then
      log "ERROR: Failed to install rbenv."
      exit 1
    fi
    # Add rbenv to zsh for future sessions
    # shellcheck disable=SC2016
    echo 'eval "$(rbenv init -)"' >> ~/.zshrc
    # Initialize rbenv for the current script session
    eval "$(rbenv init -)"

    log "Installing Ruby 3.2.2 with rbenv (this may take a while)..."
    if rbenv install 3.2.2; then
      rbenv global 3.2.2
      log "Ruby 3.2.2 installed and set as global via rbenv."
    else
      log "ERROR: Failed to install Ruby 3.2.2 with rbenv."
      exit 1
    fi
    ;;
  *)
    if [ "$ruby_choice" != "1" ]; then
      echo "Invalid choice, installing Ruby directly."
    fi
    if brew install ruby; then
      log "Ruby installed directly via Homebrew."
    else
      log "ERROR: Failed to install Ruby."
      exit 1
    fi
    ;;
esac

echo "Installing Cocoapods..."
brew install cocoapods

echo "Installing Rust..."
brew install rust

echo "Installing Go..."
brew install go

echo "Installing LLVM..."
brew install llvm

log "Installing GitHub CLI..."
if brew install gh; then
  log "GitHub CLI installed."
else
  log "ERROR: Failed to install GitHub CLI."
  exit 1
fi

echo "Installing GitLab CLI..."
brew install glab

log "Installing GitLab Runner..."
if brew install gitlab-runner; then
  log "GitLab Runner installed successfully."
else
  log "ERROR: Failed to install GitLab Runner."
  exit 1
fi

log "Installing Graphite..."
if brew install withgraphite/tap/graphite; then
  log "Graphite installed successfully."
else
  log "ERROR: Failed to install Graphite."
  exit 1
fi

echo "Installing pipx..."
brew install pipx

log "Installing pre-commit..."
export PATH="$HOME/.local/bin:$PATH"
if pipx install pre-commit; then
  log "Pre-commit installed."
else
  log "ERROR: Failed to install pre-commit."
  exit 1
fi

echo "Installing shellcheck..."
brew install shellcheck

echo "Installing actionlint..."
brew install actionlint

echo "Installing yamllint..."
brew install yamllint

echo "Installing mole..."
if brew install tw93/tap/mole; then
  log "Mole installed successfully."
else
  log "ERROR: Failed to install mole."
  exit 1
fi

log "Installing Flutter..."
if brew install flutter; then
  log "Flutter installed."
else
  log "ERROR: Failed to install Flutter."
  exit 1
fi

log "Installing Dart SDK..."
if brew install dart-sdk; then
  log "Dart SDK installed."
else
  log "ERROR: Failed to install Dart SDK."
  exit 1
fi

log "Installing Dart dependencies..."
cd "$SCRIPT_DIR"
if dart pub get; then
  log "Dart dependencies installed."
else
  log "ERROR: Failed to install Dart dependencies."
  exit 1
fi

echo "Installing Docker CLI..."
brew install docker

echo "Installing QEMU..."
brew install qemu

echo "Setting up Docker Hub..."
read -r -p "Do you want to log in to Docker Hub? (y/N): " login_choice
if [[ "$login_choice" =~ ^[Yy]$ ]]; then
  read -r -p "Enter Docker Hub username: " docker_username
  read -r -s -p "Enter Docker Hub token: " docker_token
  if [ -n "$docker_username" ] && [ -n "$docker_token" ]; then
    echo "$docker_token" | docker login -u "$docker_username" --password-stdin
    echo "Logged in to Docker Hub as $docker_username."
  else
    echo "Username or token not provided, skipped."
  fi
else
  echo "Skipped Docker Hub login."
fi

echo "Setting up Git config..."
if [ -f "$SCRIPT_DIR/.gitconfig" ]; then
  cp "$SCRIPT_DIR/.gitconfig" ~/.gitconfig
  echo "Git aliases configured."
else
  echo "Git config file not found; clone the repo first."
fi

echo "Setting up Git hooks..."
git config --global core.hooksPath "$SCRIPT_DIR/git-hooks"
chmod +x "$SCRIPT_DIR/git-hooks"/*

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

log "Activating dotfiles CLI..."
cd "$SCRIPT_DIR"
if dart pub global activate --source path .; then
  log "Dotfiles CLI activated."
else
  log "ERROR: Failed to activate dotfiles CLI."
  exit 1
fi
echo "export PATH=\"\$PATH:\$HOME/.pub-cache/bin\"" >> ~/.zshrc

echo "Setup complete! Please restart your terminal or run 'source ~/.zshrc' to apply changes."
