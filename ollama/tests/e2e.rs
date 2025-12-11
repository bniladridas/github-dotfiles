use std::process::{Command, Output};

fn run_cli(args: &[&str]) -> Output {
    Command::new("cargo")
        .args(["run", "--"].iter().chain(args.iter()).copied())
        .current_dir(env!("CARGO_MANIFEST_DIR"))
        .output()
        .unwrap_or_else(|e| panic!("Failed to run command with args {:?}: {}", args, e))
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
    assert!(output.status.success() || stderr.contains("ollama") || stderr.contains("connection"));
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
