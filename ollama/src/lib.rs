// SPDX-License-Identifier: MIT

//! # Ollama Tool Library
//!
//! Shared functions for the Ollama CLI tool.

use serde::{Deserialize, Serialize};
use thiserror::Error;

const OLLAMA_API_BASE: &str = "http://localhost:11434";

/// Request payload for Ollama generate API.
#[derive(Serialize)]
pub struct GenerateRequest<'a> {
    /// The model name to use for generation.
    pub model: &'a str,
    /// The prompt text.
    pub prompt: &'a str,
    /// The system prompt.
    pub system: &'a str,
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
        model,
        prompt,
        system,
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

#[cfg(test)]
mod tests {
    use super::*;
    use std::process::{Command, Output};

    fn run_cli(args: &[&str]) -> Output {
        Command::new("cargo")
            .args(["run", "--"].iter().chain(args.iter()).copied())
            .current_dir(env!("CARGO_MANIFEST_DIR"))
            .output()
            .unwrap_or_else(|e| panic!("Failed to run command with args {:?}: {}", args, e))
    }

    #[test]
    fn test_generate_request_serialization() {
        let request = GenerateRequest {
            model: "test-model",
            prompt: "Hello",
            system: "You are helpful",
            stream: false,
        };
        let json = serde_json::to_string(&request).unwrap();
        assert!(json.contains(r#""model":"test-model""#));
        assert!(json.contains(r#""prompt":"Hello""#));
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

    #[tokio::test]
    async fn test_generate_response_integration() {
        // Test error case when Ollama is not running
        let result = generate_response("test-model", "Hello", "You are helpful").await;
        // Should fail if Ollama not running
        assert!(result.is_err());
    }

    #[test]
    fn test_help_command() {
        let output = run_cli(&["--help"]);
        let stdout = String::from_utf8_lossy(&output.stdout);
        assert!(output.status.success());
        assert!(stdout.contains("Commands:"));
        assert!(stdout.contains("list"));
        assert!(stdout.contains("installed"));
    }

    #[test]
    fn test_installed_command() {
        let output = run_cli(&["installed"]);
        // Check that the command runs without unrecognized error
        let stderr = String::from_utf8_lossy(&output.stderr);
        assert!(!stderr.contains("unrecognized subcommand"));
        // Allow success or failure if Ollama not running
        assert!(
            output.status.success() || stderr.contains("ollama") || stderr.contains("connection")
        );
    }

    #[test]
    fn test_list_command() {
        let output = run_cli(&["list"]);
        let stderr = String::from_utf8_lossy(&output.stderr);
        assert!(!stderr.contains("unrecognized subcommand"));
        // May fail if no internet, but check it attempts
        let stdout = String::from_utf8_lossy(&output.stdout);
        assert!(
            output.status.success()
                || stdout.contains("NAME")
                || stderr.contains("network")
                || stderr.contains("ollama")
        );
    }

    #[test]
    fn test_pull_command() {
        // Test with invalid model to avoid downloading
        let output = run_cli(&["pull", "invalid-model-name"]);
        let stderr = String::from_utf8_lossy(&output.stderr);
        assert!(!stderr.contains("unrecognized subcommand"));
        // Should fail with error about model
        assert!(!output.status.success());
        assert!(stderr.contains("pull") || stderr.contains("model") || stderr.contains("ollama"));
    }

    #[test]
    fn test_run_command() {
        // Test run without model
        let output = run_cli(&["run", "nonexistent-model"]);
        let stderr = String::from_utf8_lossy(&output.stderr);
        assert!(!stderr.contains("unrecognized subcommand"));
        // Should fail
        assert!(!output.status.success());
    }

    #[test]
    fn test_remove_command() {
        let output = run_cli(&["remove", "nonexistent-model"]);
        let stderr = String::from_utf8_lossy(&output.stderr);
        assert!(!stderr.contains("unrecognized subcommand"));
        assert!(!output.status.success());
    }

    #[test]
    fn test_generate_command() {
        // Test generate with minimal args
        let output = run_cli(&["generate", "tinyllama:latest", "Hello"]);
        let stderr = String::from_utf8_lossy(&output.stderr);
        assert!(!stderr.contains("unrecognized subcommand"));
        // May fail if model not available, but check it attempts
        assert!(output.status.success() || stderr.contains("model") || stderr.contains("ollama"));
    }
}
