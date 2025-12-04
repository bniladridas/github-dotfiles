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
    Run {
        model: String,
        /// Custom system prompt
        #[arg(long)]
        system: Option<String>,
    },
    /// Remove a model
    Remove { model: String },
}
