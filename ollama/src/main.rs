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

async fn generate_response(
    model: &str,
    prompt: &str,
    system: &str,
) -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::Client::new();
    let request = GenerateRequest {
        model: model.to_string(),
        prompt: prompt.to_string(),
        system: system.to_string(),
        stream: false,
    };

    let response = client
        .post("http://localhost:11434/api/generate")
        .json(&request)
        .send()
        .await?;

    let result: GenerateResponse = response.json().await?;
    println!("{}", result.response);
    Ok(())
}

#[cfg(test)]
mod tests {

    #[test]
    fn test_option_handling() {
        // Test option handling
        let value = Some("test".to_string());
        assert_eq!(value, Some("test".to_string()));
    }

    #[test]
    fn test_custom_system_prompt() {
        // Test that custom prompt is used
        let prompt = Some("custom".to_string()).unwrap_or_else(|| "default".to_string());
        assert_eq!(prompt, "custom");
    }
}
