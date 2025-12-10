// SPDX-License-Identifier: MIT

use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "github-dotfiles-ollama")]
#[command(about = "A tool to manage Ollama models")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// List available models from Ollama library
    List,
    /// List installed models
    Installed,
    /// Pull a model
    Pull { model: String },
    /// Run a model
    Run { model: String },
    /// Remove a model
    Remove { model: String },
    /// Generate response with custom prompt and system
    Generate {
        model: String,
        prompt: String,
        /// Custom system prompt
        #[arg(long)]
        system: Option<String>,
    },
}

#[cfg(test)]
mod tests {
    use super::*;
    use clap::CommandFactory;

    #[test]
    fn test_cli_app() {
        let mut app = Cli::command();
        let help = app.render_help();
        assert!(help.to_string().contains("github-dotfiles-ollama"));
        assert!(help.to_string().contains("manage Ollama models"));
    }

    #[test]
    fn test_parse_list() {
        let cli = Cli::parse_from(["test", "list"]);
        match cli.command {
            Commands::List => {}
            _ => panic!("Expected List"),
        }
    }

    #[test]
    fn test_parse_pull() {
        let cli = Cli::parse_from(["test", "pull", "llama2"]);
        match cli.command {
            Commands::Pull { model } => assert_eq!(model, "llama2"),
            _ => panic!("Expected Pull"),
        }
    }
}
