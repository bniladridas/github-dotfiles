// SPDX-License-Identifier: MIT

mod cli;
mod models;
mod ollama;
mod prompts;

use clap::Parser;
use cli::{Cli, Commands};
use models::fetch_models;
use ollama::run_ollama_command;
use prompts::DEFAULT_SYSTEM_PROMPT;
use serde::{Deserialize, Serialize};
use thiserror::Error;

const OLLAMA_API_BASE: &str = "http://localhost:11434";

#[derive(Serialize)]
struct GenerateRequest {
    model: String,
    prompt: String,
    system: String,
    stream: bool,
}

#[derive(Deserialize)]
struct GenerateResponse {
    response: String,
}

#[derive(Debug, Error)]
pub enum Error {
    #[error("HTTP request failed: {0}")]
    Reqwest(#[from] reqwest::Error),
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("JSON parsing error: {0}")]
    Serde(#[from] serde_json::Error),
    #[error("Ollama command failed: {0}")]
    Command(String),
}

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

async fn generate_response(model: &str, prompt: &str, system: &str) -> Result<(), Error> {
    let client = reqwest::Client::new();
    let request = GenerateRequest {
        model: model.to_string(),
        prompt: prompt.to_string(),
        system: system.to_string(),
        stream: false,
    };

    let response = client
        .post(format!("{}/api/generate", OLLAMA_API_BASE))
        .json(&request)
        .send()
        .await?;

    let result: GenerateResponse = response.json().await?;
    println!("{}", result.response);
    Ok(())
}
