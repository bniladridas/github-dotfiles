# GitHub Dotfiles

This repository provides a comprehensive toolkit for developers, including global Git hooks for consistent commit standards and author identity, automated Mac setup scripts with robust error handling and logging for essential development tools (Python, Node.js, Rust, Go, Flutter, Ollama, etc.), security scanning bots (CodeQL and Trivy) for vulnerability detection, a Dart-based CLI with help and testing, a Rust-based Ollama model manager, and automated version bump system. It ensures secure, standardized, and efficient development workflows across projects.

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
dotfiles --help    # Show help
dotfiles update    # Update repository
dotfiles restore   # Restore dotfiles
dotfiles setup     # Run Mac setup (macOS only)
dotfiles version   # Show version
```

**Note**: The `export PATH` command temporarily adds Dart's global executables to your PATH. Add it to your shell config file (`.zshrc`, `.bashrc`, etc.) to make it permanent.

### Mole

Deep clean and optimize your Mac with mole, a unified toolkit for cleaning caches, uninstalling apps, and system optimization.

```bash
mo                           # Interactive menu
mo clean                     # Deep cleanup
mo uninstall                 # Remove apps + leftovers
mo optimize                  # Refresh caches & services
mo analyze                   # Visual disk explorer
mo status                    # Live system health dashboard
mo purge                     # Clean project build artifacts

mo touchid                   # Configure Touch ID for sudo
mo update                    # Update Mole
mo remove                    # Remove Mole from system
mo --help                    # Show help
mo --version                 # Show installed version

mo clean --dry-run           # Preview the cleanup plan
mo clean --whitelist         # Manage protected caches
mo uninstall --force-rescan  # Rescan applications and refresh cache
mo optimize --whitelist      # Manage protected optimization rules
```

### Ollama

Rust CLI for managing Ollama models. Run with `./bin/ollama-tool` or see [ollama/README.md](./ollama/README.md) for details.

### Graphite

Graphite revolutionizes Git workflows with stacked pull requests, enabling faster reviews and parallel development by breaking large changes into manageable, interdependent PRs.

Key commands:

```bash
gt branch create <feature-name>              # Create a stacked branch
gt create --all --message "feat: <summary>"  # Stage and commit all changes
gt submit --stack --reviewers <user1>,<user2>  # Submit entire stack with reviewers
gt sync --restack                        # Sync and restack branches
gt up 2                                  # Navigate up 2 branches in stack
gt down                                  # Move down the stack
gt stack                                 # View current stack structure
gt repo sync                             # Sync all branches in repo
```

For PR reviews, visit https://app.graphite.com. For advanced usage, see [Graphite docs](https://graphite.dev/docs).

### Updating and Restoring Dotfiles

To update the repository and restore the latest dotfiles to your home directory:

```bash
cd ~/github-dotfiles
./restore/update_and_restore.sh
```

This script pulls the latest changes and copies `.gitconfig`, `.pre-commit-config.yaml`, and `.yamllint` to `~/`.

### Initial Mac Setup

For a new Mac, run the setup script to install actionlint, Cocoapods, Docker CLI, Flutter, GitHub CLI, GitLab CLI, Go, Homebrew, Kiro CLI, LLVM, mole, Node.js, Ollama, opencode, Python, QEMU, Ruby, Rust, yamllint, Zsh, and configure Git hooks globally. It also offers to log in to Docker Hub:

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

- **Code quality assurance**: Pre-commit hooks enforce linting, formatting, and testing across `Python`, `Rust`, `C++`, `Bash`, `YAML`, `Docker`, `GitHub Actions`, and `Dart`.
- **Commit standards**: Validates conventional commit messages and author identity for consistent history.
- **Security scanning**: Automated `CodeQL` and `Trivy` checks safeguard against vulnerabilities on every push and PR.
- **AI model management**: `Rust`-based `Ollama` tool for seamless model fetching, downloading, and execution.
- **Git workflow enhancement**: `Graphite` enables efficient stacked pull requests for parallel development and faster reviews.
- **Automated testing**: Comprehensive `Dart` CLI unit tests run in CI for reliability.
- **Version automation**: `Dart`-powered bot handles semantic versioning and release workflows via `GitHub Actions`.

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
