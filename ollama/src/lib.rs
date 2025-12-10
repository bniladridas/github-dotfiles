// SPDX-License-Identifier: MIT

//! # Ollama Tool Library
//!
//! Shared functions for the Ollama CLI tool.

use serde::{Deserialize, Serialize};
use thiserror::Error;

const OLLAMA_API_BASE: &str = "http://localhost:11434";

#[derive(Serialize)]
pub struct GenerateRequest {
    pub model: String,
    pub prompt: String,
    pub system: String,
    pub stream: bool,
}

#[derive(Deserialize)]
pub struct GenerateResponse {
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

pub async fn generate_response(model: &str, prompt: &str, system: &str) -> Result<(), Error> {
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