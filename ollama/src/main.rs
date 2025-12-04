mod cli;
mod models;
mod ollama;

use clap::Parser;
use cli::{Cli, Commands};
use models::fetch_models;
use ollama::run_ollama_command;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cli = Cli::parse();

    match cli.command {
        Commands::List => {
            println!("Fetching available models...");
            let models = fetch_models().await?;
            println!("Available models:");
            for model in models {
                println!("- {}", model);
            }
        }
        Commands::Installed => {
            println!("Listing installed models...");
            run_ollama_command(&["list"])?;
        }
        Commands::Pull { model } => {
            println!("Pulling model: {}", model);
            run_ollama_command(&["pull", &model])?;
            println!("Model {} pulled successfully.", model);
        }
        Commands::Run { model } => {
            println!("Running model: {}", model);
            let system_prompt = "You are GitHub Dotfiles AI, a helpful, harmless, and honest AI assistant powered by Ollama. Always provide accurate and useful responses.";
            run_ollama_command(&["run", &model, "--system", system_prompt])?;
        }
        Commands::Remove { model } => {
            println!("Removing model: {}", model);
            run_ollama_command(&["rm", &model])?;
            println!("Model {} removed.", model);
        }
    }
    Ok(())
}
