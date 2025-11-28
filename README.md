# GitHub Dotfiles

This repository provides a comprehensive toolkit for developers, including global Git hooks for consistent commit standards and author identity, automated Mac setup scripts for essential development tools (Python, Node.js, Rust, Go, Flutter, etc.), security scanning bots (CodeQL and Trivy) for vulnerability detection, and a Dart-based version bump system. It ensures secure, standardized, and efficient development workflows across projects.

## Installation

Clone this repository to your home directory:

```bash
git clone https://github.com/bniladridas/github-dotfiles.git ~/github-dotfiles
```

## Usage

### Dart CLI Tool

Install Dart SDK, then use the CLI tool for managing dotfiles:

```bash
# Activate the CLI globally
dart pub global activate --source path .

# Add to PATH (add this to your ~/.zshrc or ~/.bashrc for permanent access)
export PATH="$PATH:$HOME/.pub-cache/bin"

# Now you can use the commands:
dotfiles update    # Update repository
dotfiles restore   # Restore dotfiles
dotfiles setup     # Run Mac setup (macOS only)
dotfiles version   # Show version
```

**Note**: The `export PATH` command temporarily adds Dart's global executables to your PATH. Add it to your shell config file (`.zshrc`, `.bashrc`, etc.) to make it permanent.

### Updating and Restoring Dotfiles

To update the repository and restore the latest dotfiles to your home directory:

```bash
cd ~/github-dotfiles
./restore/update_and_restore.sh
```

This script pulls the latest changes and copies `.gitconfig`, `.pre-commit-config.yaml`, and `.yamllint` to `~/`.

### Initial Mac Setup

For a new Mac, run the setup script to install Zsh, Homebrew, Python, Node.js, Ruby, Cocoapods, Rust, Go, Flutter, LLVM, GitHub CLI, GitLab CLI, actionlint, yamllint, Docker CLI, QEMU, opencode, and configure Git hooks globally. It also offers to log in to Docker Hub as 'harpertoken':

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/bniladridas/github-dotfiles/main/setup-mac.sh)"
```

Or download and run the script manually.

Restart your terminal or run `source ~/.zprofile` to apply changes.

### Git Hooks Setup

The setup script automatically configures Git to use the hooks globally and makes them executable. If setting up manually:

1. Make the hooks executable:

    ```bash
    chmod +x ~/github-dotfiles/git-hooks/*
    ```

2. Configure Git to use these hooks globally:

    ```bash
    git config --global core.hooksPath ~/github-dotfiles/git-hooks
    ```

3. Verify the hooks setup:

    ```bash
    git config --global core.hooksPath
    ```

4. Set your Git author identity:

    ```bash
    git config --global user.name "Niladri Das"
    git config --global user.email "bniladridas@users.noreply.github.com"
    ```

5. The setup script automatically configures useful Git aliases from `.gitconfig` and lets you choose the bracket type for commit scopes.

   Available aliases:
   - `git track <branch>`: Set upstream to origin/<branch>
   - `git untrack <branch>`: Unset upstream for <branch>
   - `git branches`: List all branches (local and remote)
   - `git status`: Short status
   - `git lg`: Log with graph
   - `git co <branch>`: Checkout
   - `git ci`: Commit
   - `git st`: Status

4. (Optional) Install and set up pre-commit for enhanced checks:

   ```bash
   pip install pre-commit
   pre-commit install  # In each project repo
   ```

## Features

- **Pre-commit checks**: Runs pre-commit hooks on push (includes Python linting with black/flake8/mypy/bandit/safety, C++ formatting/linting with clang-format and clang-tidy, Rust formatting/linting/compilation with rustfmt/clippy, Bash linting with shellcheck, Dockerfile linting with hadolint, YAML linting with yamllint, GitHub Actions linting with actionlint, and general checks).
- **YAML linting**: Runs check-yaml from pre-commit.
- **Commit message validation**: Commit-msg hook ensures messages start with conventional type and are lowercase ≤60 chars. Pre-push hook enforces stricter format with scope, ≤40 chars.
- **Author identity verification**: Checks that commits are authored by "Niladri Das" with email "bniladridas@users.noreply.github.com".
- **Automated vulnerability scanning**: CodeQL and Trivy bots scan every push and PR for security issues, ensuring robust protection.
- **Version management**: Dart-powered version bump bot automates semantic versioning updates for the package.

## Handling errors

When the hook fails, it will block the push with an error message. Common issues:

- Pre-commit not installed: Install with `pip install pre-commit`
- Commit message format invalid: Use `type(scope): description` (lowercase, ≤40 chars)
- Author identity mismatch: Ensure Git config matches the expected values

## Advanced Usage

### Customizing hooks

You can modify the `pre-push` hook in `git-hooks/pre-push` to add custom checks.

### Accessing raw hook output

The hook outputs detailed messages for each check. Run `git push` to see the validation in action.

## Docker Images

Pre-built Docker images are available for containerized use:

- **Docker Hub**: `docker pull harpertoken/dotfiles:latest`
- **GHCR**: `docker pull ghcr.io/bniladridas/github-dotfiles:latest`

## Requirements

- macOS
- Git
- Python 3.12+ (installed via setup script)
- Node.js (installed via setup script)
- Dart SDK (for version bump functionality)

## Contributing

See [the contributing documentation](./CONTRIBUTING.md).

## License

[MIT license](./LICENSE)
