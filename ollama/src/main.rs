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
