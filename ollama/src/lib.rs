// SPDX-License-Identifier: MIT

//! # Ollama Tool Library
//!
//! Shared functions for the Ollama CLI tool.

use serde::{Deserialize, Serialize};
use thiserror::Error;

fn get_ollama_api_base() -> String {
    std::env::var("OLLAMA_API_BASE").unwrap_or_else(|_| "http://localhost:11434".to_string())
}

/// Request payload for Ollama generate API.
#[derive(Serialize)]
pub struct GenerateRequest {
    /// The model name to use for generation.
    pub model: String,
    /// The prompt text.
    pub prompt: String,
    /// The system prompt.
    pub system: String,
    /// Whether to stream the response.
    pub stream: bool,
}

/// Response payload from Ollama generate API.
#[derive(Deserialize)]
pub struct GenerateResponse {
    /// The generated response text.
    pub response: String,
}

/// Represents errors that can occur within the application.
#[derive(Debug, Error)]
pub enum Error {
    /// An error from the `reqwest` crate during an HTTP request.
    #[error("HTTP request failed: {0}")]
    Reqwest(#[from] reqwest::Error),
    /// An I/O error occurred.
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    /// An error occurred during JSON serialization or deserialization.
    #[error("JSON parsing error: {0}")]
    Serde(#[from] serde_json::Error),
    /// An external `ollama` command returned a non-zero exit status.
    #[error("Ollama command failed: {0}")]
    Command(String),
}

/// Generates a response from the Ollama API using the specified model and prompts.
///
/// # Arguments
///
/// * `model` - The name of the model to use.
/// * `prompt` - The user prompt.
/// * `system` - The system prompt.
///
/// # Errors
///
/// Returns an `Error` if the API request fails or the response cannot be parsed.
pub async fn generate_response(model: &str, prompt: &str, system: &str) -> Result<(), Error> {
    let client = reqwest::Client::new();
    let request = GenerateRequest {
        model: model.to_string(),
        prompt: prompt.to_string(),
        system: system.to_string(),
        stream: false,
    };

    let response = client
        .post(format!("{}/api/generate", get_ollama_api_base()))
        .json(&request)
        .send()
        .await?;

    let result: GenerateResponse = response.json().await?;
    println!("{}", result.response);
    Ok(())
}
