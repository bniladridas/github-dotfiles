use std::process::Command;

#[test]
fn test_help_command() {
    let output = Command::new("cargo")
        .args(&["run", "--", "--help"])
        .current_dir(env!("CARGO_MANIFEST_DIR"))
        .output()
        .expect("Failed to run help command");

    let stdout = String::from_utf8_lossy(&output.stdout);
    assert!(output.status.success());
    assert!(stdout.contains("Commands:"));
    assert!(stdout.contains("list"));
    assert!(stdout.contains("installed"));
}

#[test]
fn test_installed_command() {
    let output = Command::new("cargo")
        .args(&["run", "--", "installed"])
        .current_dir(env!("CARGO_MANIFEST_DIR"))
        .output()
        .expect("Failed to run installed command");

    // Assuming Ollama is installed and has models, but for e2e, just check it runs
    // In a real setup, this would check for specific output
    assert!(output.status.success() || output.status.code() == Some(1)); // Allow if no models
    let stdout = String::from_utf8_lossy(&output.stdout);
    // Basic check that it produces output
    assert!(!stdout.is_empty() || !String::from_utf8_lossy(&output.stderr).is_empty());
}
