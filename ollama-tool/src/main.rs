use clap::{Parser, Subcommand};
use reqwest;
use scraper::{Html, Selector};
use std::process::Command;
use tokio;

#[derive(Parser)]
#[command(name = "ollama-tool")]
#[command(about = "A tool to manage Ollama models")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// List available models from Ollama library
    List,
    /// Pull a model
    Pull { model: String },
    /// Run a model
    Run { model: String },
}

async fn fetch_models() -> Result<Vec<String>, Box<dyn std::error::Error>> {
    let url = "https://ollama.ai/library";
    let response = reqwest::get(url).await?;
    let body = response.text().await?;
    let document = Html::parse_document(&body);
    let selector = Selector::parse("a[href^='/library/']").unwrap();

    let mut models = Vec::new();
    for element in document.select(&selector) {
        if let Some(href) = element.value().attr("href") {
            if let Some(name) = href.strip_prefix("/library/") {
                if !name.contains('/') && !models.contains(&name.to_string()) {
                    models.push(name.to_string());
                }
            }
        }
    }
    models.sort();
    Ok(models)
}

fn run_ollama_command(args: &[&str]) -> Result<(), Box<dyn std::error::Error>> {
    let status = Command::new("ollama")
        .args(args)
        .status()?;
    if status.success() {
        Ok(())
    } else {
        Err(format!("Ollama command failed with exit code {}", status.code().unwrap_or(-1)).into())
    }
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
    }
    Ok(())
}
