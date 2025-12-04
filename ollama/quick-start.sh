#!/bin/bash

# SPDX-License-Identifier: MIT

# Quick start script for Ollama tool
# Installs, builds, pulls lightest model, and runs it

set -e

echo "Starting Ollama quick start..."

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "Ollama not installed. Please run setup-mac.sh first or install Ollama manually."
    exit 1
fi

# Check if Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo "Starting Ollama..."
    brew services start ollama
    # Wait for Ollama service to be ready
    echo "Waiting for Ollama to start..."
    while ! curl -s http://localhost:11434/api/version > /dev/null; do
        sleep 1
    done
    echo "Ollama is ready."
fi

# Build the tool
echo "Building Ollama tool..."
cd "$(dirname "$0")"
./run.sh --help > /dev/null  # This builds if needed

# Pull the lightest model
LIGHT_MODEL="tinyllama"
echo "Pulling lightest model: $LIGHT_MODEL"
./run.sh pull "$LIGHT_MODEL"

# Run the model
echo "Running $LIGHT_MODEL..."
./run.sh run "$LIGHT_MODEL"
