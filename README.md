# GitHub Dotfiles

This repository contains global Git hooks for maintaining consistent commit standards and author identity across your projects.

## Features

- **Pre-commit checks**: Runs pre-commit hooks if available (includes Python linting with black/flake8/pylint/mypy, C++ formatting/linting with clang-format and clang-tidy, Rust formatting/linting/compilation with rustfmt/clippy/cargo-check, and general checks).
- **YAML linting**: Runs yamllint on YAML files if available.
- **Commit message validation**: Ensures messages follow conventional commit format (lowercase, ≤40 chars, proper type).
- **Author identity verification**: Checks that commits are authored by "Niladri Das" with email "bniladridas@users.noreply.github.com".

## Setup

### Initial Mac Setup

For a new Mac, first run the setup script to install Zsh, Homebrew, and opencode:

1. Open Terminal and run:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/bniladridas/GitHub-dotfiles/main/setup-mac.sh)"
   ```

   Or download and run the script manually.

2. Restart your terminal or run `source ~/.zprofile` to apply changes.

### Git Hooks Setup

To set up the Git hooks:

1. Clone this repository to your home directory:

   ```bash
   git clone https://github.com/bniladridas/GitHub-dotfiles.git ~/GitHub-dotfiles
   ```

2. Make the pre-push hook executable:

   ```bash
   chmod +x ~/GitHub-dotfiles/git-hooks/pre-push
   ```

3. Configure Git to use these hooks globally:

   ```bash
   git config --global core.hooksPath ~/GitHub-dotfiles/git-hooks
   ```

4. Set your Git author identity:

   ```bash
   git config --global user.name "Niladri Das"
   git config --global user.email "bniladridas@users.noreply.github.com"
   ```

5. (Optional) Install and set up pre-commit for enhanced checks:

   ```bash
   pip install pre-commit
   pre-commit install  # In each project repo
   ```

   - **yamllint**: `pip install yamllint` or `brew install yamllint`

## Usage

Once set up, the pre-push hook will automatically run before any `git push` operation, validating your commits. If any checks fail, the push will be blocked with an error message.

## Troubleshooting

- If the hook doesn't run, ensure `core.hooksPath` is set correctly: `git config --global core.hooksPath`
- For private repositories, ensure your GitHub token has `repo` scope if using HTTPS authentication.