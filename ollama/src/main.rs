mod cli;
mod models;
mod ollama;
mod prompts;

use crate::prompts::DEFAULT_SYSTEM_PROMPT;
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
        Commands::Run { model, system } => {
            println!("Running model: {}", model);
            let system_prompt = system.unwrap_or_else(|| DEFAULT_SYSTEM_PROMPT.to_string());
            run_ollama_command(&["run", &model, "--system", &system_prompt])?;
        }
        Commands::Remove { model } => {
            println!("Removing model: {}", model);
            run_ollama_command(&["rm", &model])?;
            println!("Model {} removed.", model);
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {

    #[test]
    fn test_default_system_prompt() {
        // Test that default prompt is used when None
        let prompt =
            None::<String>.unwrap_or_else(|| crate::prompts::DEFAULT_SYSTEM_PROMPT.to_string());
        assert_eq!(prompt, crate::prompts::DEFAULT_SYSTEM_PROMPT);
    }

    #[test]
    fn test_custom_system_prompt() {
        // Test that custom prompt is used
        let prompt = Some("custom".to_string()).unwrap_or_else(|| "default".to_string());
        assert_eq!(prompt, "custom");
    }
}
