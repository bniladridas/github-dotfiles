#!/bin/bash

# Dotfiles sync functionality (requires authentication)
AUTH_DIR="$HOME/.dotfiles"
TOKEN_FILE="$AUTH_DIR/token"
USER_FILE="$AUTH_DIR/user"
SYNC_REPO="dotfiles-sync"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

check_auth() {
  if [ ! -f "$TOKEN_FILE" ] || [ ! -f "$USER_FILE" ]; then
    log "ERROR: Not logged in. Run './auth/login.sh login' first"
    exit 1
  fi
}

sync_push() {
  check_auth
  
  USERNAME=$(cat "$USER_FILE")
  TOKEN=$(cat "$TOKEN_FILE")
  
  log "Syncing dotfiles to GitHub..."
  
  # Create backup of current dotfiles
  BACKUP_DIR="/tmp/dotfiles-backup-$(date +%s)"
  mkdir -p "$BACKUP_DIR"
  
  # Copy key dotfiles
  [ -f ~/.gitconfig ] && cp ~/.gitconfig "$BACKUP_DIR/"
  [ -f ~/.zshrc ] && cp ~/.zshrc "$BACKUP_DIR/"
  [ -f ~/.bashrc ] && cp ~/.bashrc "$BACKUP_DIR/"
  [ -f ~/.vimrc ] && cp ~/.vimrc "$BACKUP_DIR/"
  
  # Create or update sync repository
  if ! gh repo view "$USERNAME/$SYNC_REPO" &>/dev/null; then
    log "Creating sync repository..."
    gh repo create "$SYNC_REPO" --private --description "Dotfiles sync backup"
  fi
  
  # Push to sync repo
  cd "$BACKUP_DIR" || exit 1
  git init
  git add .
  git commit -m "sync: backup dotfiles $(date)"
  git remote add origin "https://github.com/$USERNAME/$SYNC_REPO.git"
  git push -u origin main --force
  
  log "Dotfiles synced to github.com/$USERNAME/$SYNC_REPO"
  rm -rf "$BACKUP_DIR"
}

sync_pull() {
  check_auth
  
  USERNAME=$(cat "$USER_FILE")
  
  log "Restoring dotfiles from GitHub..."
  
  # Clone sync repo
  RESTORE_DIR="/tmp/dotfiles-restore-$(date +%s)"
  if gh repo clone "$USERNAME/$SYNC_REPO" "$RESTORE_DIR"; then
    cd "$RESTORE_DIR" || exit 1
    
    # Backup existing files
    [ -f ~/.gitconfig ] && cp ~/.gitconfig ~/.gitconfig.backup
    [ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup
    
    # Restore files
    [ -f .gitconfig ] && cp .gitconfig ~/
    [ -f .zshrc ] && cp .zshrc ~/
    [ -f .bashrc ] && cp .bashrc ~/
    [ -f .vimrc ] && cp .vimrc ~/
    
    log "Dotfiles restored from sync repository"
    rm -rf "$RESTORE_DIR"
  else
    log "ERROR: No sync repository found. Run 'sync push' first"
    exit 1
  fi
}

premium_tools() {
  check_auth
  
  USERNAME=$(cat "$USER_FILE")
  log "Premium tools for $USERNAME:"
  echo "  ✓ Advanced linting with custom rules"
  echo "  ✓ Team configuration sharing"
  echo "  ✓ Automated backup scheduling"
  echo "  ✓ Cross-platform sync"
  echo ""
  echo "Run 'dotfiles premium enable' to activate"
}

case "$1" in
  push)
    sync_push
    ;;
  pull)
    sync_pull
    ;;
  premium)
    premium_tools
    ;;
  *)
    echo "Usage: $0 {push|pull|premium}"
    echo "  push     - Backup dotfiles to GitHub"
    echo "  pull     - Restore dotfiles from GitHub"
    echo "  premium  - Show premium features"
    echo ""
    echo "Note: Requires authentication (./auth/login.sh login)"
    exit 1
    ;;
esac
