#!/bin/bash

# GitHub OAuth authentication for dotfiles
AUTH_DIR="$HOME/.dotfiles"
TOKEN_FILE="$AUTH_DIR/token"
USER_FILE="$AUTH_DIR/user"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

github_login() {
  # Check for required dependencies
  if ! command -v jq &> /dev/null; then
    log "ERROR: jq is required but not installed"
    exit 1
  fi

  mkdir -p "$AUTH_DIR"

  log "Opening GitHub OAuth login..."

  # For now, use GitHub personal access token flow
  echo "Please create a GitHub Personal Access Token:"
  echo "1. Go to: https://github.com/settings/tokens"
  echo "2. Click 'Generate new token (classic)'"
  echo "3. Select scopes: repo, user:email"
  echo "4. Copy the generated token"
  echo ""

  open "https://github.com/settings/tokens" 2>/dev/null || \
  xdg-open "https://github.com/settings/tokens" 2>/dev/null || \
  echo "Visit: https://github.com/settings/tokens"

  echo "Enter your GitHub token:"
  read -r -s token

  if [ -n "$token" ]; then
    # Validate token with GitHub API
    USER_INFO=$(curl -s -H "Authorization: token $token" https://api.github.com/user)

      USERNAME=$(echo "$USER_INFO" | jq -r '.login')
      if [ -n "$USERNAME" ] && [ "$USERNAME" != "null" ]; then
        echo "$token" > "$TOKEN_FILE"
        echo "$USERNAME" > "$USER_FILE"
        chmod 600 "$TOKEN_FILE" "$USER_FILE"
        log "Successfully logged in as $USERNAME!"
    else
      log "ERROR: Invalid GitHub token"
      exit 1
    fi
  else
    log "ERROR: No token provided"
    exit 1
  fi
}

logout() {
  if [ -f "$TOKEN_FILE" ]; then
    rm -f "$TOKEN_FILE" "$USER_FILE"
    log "Successfully logged out!"
  else
    log "Not currently logged in"
  fi
}

whoami() {
  if [ -f "$TOKEN_FILE" ] && [ -f "$USER_FILE" ]; then
    USERNAME=$(cat "$USER_FILE")
    TOKEN_PREVIEW=$(head -c 8 "$TOKEN_FILE")
    log "Logged in as $USERNAME (token: ${TOKEN_PREVIEW}...)"
  else
    log "Not logged in"
    exit 1
  fi
}

case "$1" in
  login)
    github_login
    ;;
  logout)
    logout
    ;;
  whoami)
    whoami
    ;;
  *)
    echo "Usage: $0 {login|logout|whoami}"
    echo "  login   - Authenticate with GitHub"
    echo "  logout  - Remove stored credentials"
    echo "  whoami  - Show current login status"
    exit 1
    ;;
esac
