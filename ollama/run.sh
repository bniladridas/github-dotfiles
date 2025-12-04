#!/bin/bash

# SPDX-License-Identifier: MIT

# Script to build and run the Ollama tool

set -e

TOOL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
EXE="$TOOL_DIR/target/release/github-dotfiles-ollama"

# Build if executable doesn't exist or is outdated
if [ ! -f "$EXE" ] || [ "$TOOL_DIR/src/main.rs" -nt "$EXE" ]; then
    echo "Building Ollama..."
    cd "$TOOL_DIR"
    cargo build --release
fi

# Run the tool with passed arguments
"$EXE" "$@"
