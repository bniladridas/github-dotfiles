# GitHub Dotfiles

This repository provides a comprehensive toolkit for developers, including global Git hooks for consistent commit standards and author identity, automated Mac setup scripts with robust error handling and logging for essential development tools (Python, Node.js, Rust, Go, Flutter, Ollama, Gemini CLI, KiloCode CLI, etc.), security scanning bots (CodeQL and Trivy) for vulnerability detection, a Dart-based CLI with help and testing, a Rust-based Ollama model manager, and automated version bump system. It ensures secure, standardized, and efficient development workflows across projects.

## Stacked Development Workflow

This repository includes tools for stacked development using Sapling, Graphite, and ReviewStack.

### Workflow Example

```bash
# Setup (one-time)
./sapling-setup.sh
npm install -g @withgraphite/graphite-cli

# Create stack
sl clone https://github.com/owner/repo.git
cd repo
sl goto main

sl commit -m "feat: add database schema"
sl commit -m "feat: add API endpoints"
sl commit -m "feat: add frontend components"

# View stack
sl ssl                                # Show smartlog
sl web                                # Launch browser UI

# Submit as PRs
gt auth
gt repo init
gt submit --stack

# Review
./bin/reviewstack --current
./bin/reviewstack https://github.com/owner/repo/pull/123

# Update
sl goto <commit-hash>
sl amend
gt sync --restack

# Navigate
sl next 2 / sl prev
gt up / gt down
```

### Tools

- **Sapling**: Local stack management, no staging area
- **Graphite**: GitHub PR creation for stacks
- **ReviewStack**: Stack-aware code review

### ReviewStack Shortcuts

- `Shift + N/P` - Navigate PRs
- `Ctrl + .` - Toggle timeline
- `Alt + A/R/C` - Approve/Request/Comment

## Installation

Choose your preferred installation method:

### Option 1: Direct Bash (Recommended)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/bniladridas/github-dotfiles/main/setup-mac.sh)"
```

### Option 2: Homebrew
```bash
brew tap bniladridas/dotfiles https://github.com/bniladridas/github-dotfiles
brew install dotfiles
```

### Option 3: UV (Python Package Manager)
```bash
uv tool install git+https://github.com/bniladridas/github-dotfiles.git
```

### Option 4: Manual Clone
```bash
git clone https://github.com/bniladridas/github-dotfiles.git ~/github-dotfiles
cd ~/github-dotfiles
./setup-mac.sh
```

## Usage

### Authentication

Login with your GitHub account to access premium features:

```bash
# Login with GitHub OAuth
./auth/login.sh login

# Check login status
./auth/login.sh whoami

# Logout
./auth/login.sh logout
```

### Sync & Premium Features (Requires Login)

After logging in, access advanced features:

```bash
# Sync dotfiles across machines
./sync/dotfiles-sync.sh push    # Backup to GitHub
./sync/dotfiles-sync.sh pull    # Restore from GitHub

# Premium tools
./sync/dotfiles-sync.sh premium # Show available features
```

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

### Sapling

Sapling SCM provides an intuitive alternative to Git with superior stacked commit workflows, built-in undo operations, and a web-based interface for managing commit stacks.

```bash
./sapling-setup.sh                       # Install and configure Sapling
sl clone <repo>                          # Clone repository
sl commit -m "message"                   # Create commit (no staging area)
sl web                                   # Launch browser-based UI
sl ssl                                   # Show smartlog with PR status
sl undo -i                               # Interactive undo with preview
sl absorb                                # Auto-absorb changes into stack
```

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

For PR reviews, visit https://app.graphite.com or use [ReviewStack](https://reviewstack.dev) for enhanced stacked PR review experience. For advanced usage, see [Graphite docs](https://graphite.dev/docs).

**ReviewStack Usage**: Replace `github.com` with `reviewstack.dev` in any PR URL for stack-aware review interface with side-by-side diff/timeline view.

```bash
# Quick ReviewStack access
./bin/reviewstack https://github.com/owner/repo/pull/123  # Convert and open URL
./bin/reviewstack --current                               # Open current branch's PR
```

### KiloCode CLI

This repository uses KiloCode CLI for code review, ensuring consistent style and quality in pull requests.

```bash
kilocode review <pr-url>  # Review a pull request
kilocode style check      # Check code style
```

### Updating and Restoring Dotfiles

To update the repository and restore the latest dotfiles to your home directory:

```bash
cd ~/github-dotfiles
./restore/update_and_restore.sh
```

This script pulls the latest changes and copies `.gitconfig`, `.pre-commit-config.yaml`, and `.yamllint` to `~/`.

### Initial Mac Setup

For a new Mac, run the setup script to install actionlint, Brev, Cocoapods, codex, Docker CLI, Flutter, GitHub CLI, GitLab CLI, Go, Homebrew, KiloCode CLI, Kimi CLI, Kiro CLI, LLVM, mole, Node.js, Ollama, opencode, Python, QEMU, Ruby, Rust, yamllint, Zsh, and configure Git hooks globally. It also offers to log in to Docker Hub:

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
