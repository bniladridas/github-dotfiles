// SPDX-License-Identifier: MIT

//! # Ollama Tool
//!
//! A command-line tool for managing Ollama models.

mod cli;
mod models;
mod ollama;
mod prompts;

use clap::Parser;
use cli::{Cli, Commands};
use github_dotfiles_ollama::{generate_response, Error};
use models::fetch_models;
use ollama::run_ollama_command;
use prompts::DEFAULT_SYSTEM_PROMPT;


/// Main entry point for the Ollama CLI tool.
///
/// Parses command-line arguments and executes the corresponding subcommand.
///
/// # Errors
///
/// Returns an `Error` if any of the subcommands fail during execution.
#[tokio::main]
async fn main() -> Result<(), Error> {
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
            run_ollama_command(&["run", &model])?;
        }
        Commands::Remove { model } => {
            println!("Removing model: {}", model);
            run_ollama_command(&["rm", &model])?;
            println!("Model {} removed.", model);
        }
        Commands::Generate {
            model,
            prompt,
            system,
        } => {
            println!("Generating response with model: {}", model);
            let system_prompt = system.unwrap_or_else(|| DEFAULT_SYSTEM_PROMPT.to_string());
            generate_response(&model, &prompt, &system_prompt).await?;
        }
    }
    Ok(())
}



#[cfg(test)]
mod tests {
    use github_dotfiles_ollama::*;

    #[test]
    fn test_generate_request_serialization() {
        let request = GenerateRequest {
            model: "test-model".to_string(),
            prompt: "Hello".to_string(),
            system: "You are helpful".to_string(),
            stream: false,
        };
        let json = serde_json::to_string(&request).unwrap();
        assert!(json.contains("test-model"));
        assert!(json.contains("Hello"));
    }

    #[test]
    fn test_generate_response_deserialization() {
        let json = r#"{"response": "Hi there!"}"#;
        let response: GenerateResponse = serde_json::from_str(json).unwrap();
        assert_eq!(response.response, "Hi there!");
    }

    #[test]
    fn test_error_display() {
        let error = Error::Command("test error".to_string());
        assert!(error.to_string().contains("test error"));
    }
}
