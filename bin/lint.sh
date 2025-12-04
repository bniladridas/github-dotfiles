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

echo "Linting complete!"
