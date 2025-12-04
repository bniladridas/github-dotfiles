#!/bin/bash

# SPDX-License-Identifier: MIT

# Custom linting script for the repo

set -e

echo "Running yamllint on YAML files..."
yamllint .github/workflows/*.yml .github/actions/**/*.yml .github/dependabot.yml

echo "Running actionlint on workflows..."
actionlint .github/workflows/*.yml

echo "Running shellcheck on shell scripts..."
find . -name "*.sh" -type f -exec shellcheck {} +

echo "Running cargo fmt check..."
cargo fmt --manifest-path ollama/Cargo.toml --check

echo "Running cargo check..."
cargo check --manifest-path ollama/Cargo.toml

echo "Running cargo clippy..."
cargo clippy --manifest-path ollama/Cargo.toml -- -D warnings -D missing_docs

echo "Linting complete!"
