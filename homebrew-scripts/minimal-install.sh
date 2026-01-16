#!/bin/bash

# Minimal Homebrew Install Script
# This script demonstrates a basic, safe Homebrew installation example.
# It installs only the essential Git version control system, which is fundamental for development workflows.
# Unlike the other scripts that install multiple packages, this focuses on a single, core tool to illustrate minimal dependency management.
# In software engineering, minimalism in tooling reduces complexity, potential conflicts, and maintenance overhead.
# By starting with Git, this script ensures version control is available before adding more tools, following the principle of progressive enhancement.
# Reference: Homebrew's philosophy emphasizes simplicity and safety, aligning with this minimal approach to avoid overwhelming new users.
# This prevents "bandwidth noise" by providing a focused, educational example rather than a bloated installation.

set -euo pipefail

echo "Installing minimal essential tool: Git"
brew install git

echo "Minimal installation completed. Git is now available for version control."
