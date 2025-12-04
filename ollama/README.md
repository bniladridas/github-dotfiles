# Ollama Tool

A Rust-based CLI tool for managing Ollama models. It fetches the latest available models from Ollama's online library, enables downloading specific models, and provides an interface to run them interactively.

## Prerequisites

- Rust installed (via setup script)
- Ollama installed and running (`brew services start ollama`)

## Installation

Clone the repository and build the tool:

```bash
git clone https://github.com/bniladridas/github-dotfiles.git
cd github-dotfiles/ollama-tool
cargo build --release
```

## Usage

Use the provided script to automatically build and run the tool.

<!-- prettier-ignore -->
```bash
# Show help
./target/release/github-dotfiles-ollama --help

# List all available models from Ollama's library
./target/release/github-dotfiles-ollama list

# Download a model (e.g., tinyllama)
./target/release/github-dotfiles-ollama pull tinyllama

# Run a downloaded model interactively
./target/release/github-dotfiles-ollama run tinyllama
```

The script builds the tool if needed and passes arguments to it.

### Commands

- `list`: Fetches and displays available models from ollama.ai/library
- `installed`: Lists locally installed models
- `pull <model>`: Downloads the specified model using Ollama CLI
- `run <model>`: Launches the model in interactive chat mode with a helpful system prompt
- `remove <model>`: Removes the specified model from local storage

## Handling Errors

If Ollama is not running, `pull` and `run` commands will fail with an error message. Ensure Ollama is started with `brew services start ollama`.

Common errors:

| Error | Cause | Solution |
|-------|-------|----------|
| "Ollama command failed" | Ollama not running | Start Ollama service |
| "Model not found" | Invalid model name | Check spelling or list available models |
| Network error | Internet connection | Retry or check connection |

## Advanced Usage

### Custom Model Selection

Use `list` to browse models, then `pull` specific ones. Models are pulled in the background and may take time for large models.

### Integration with Scripts

The tool can be integrated into automation scripts:

```bash
#!/bin/bash
MODEL="llama2"
./target/release/ollama-tool pull $MODEL
./target/release/ollama-tool run $MODEL
```

## Features

- **Model Discovery**: Dynamically fetches model list from ollama.ai/library
- **Seamless Download**: Integrates with Ollama CLI for reliable model pulling
- **Interactive Running**: Launches models in chat mode
- **Error Handling**: Provides clear feedback for failed operations

## Example Workflow

1. List models: `./target/release/ollama-tool list`
2. Choose a model (e.g., `llama2`)
3. Pull it: `./target/release/ollama-tool pull llama2`
4. Run it: `./target/release/ollama-tool run llama2`