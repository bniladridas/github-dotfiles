use std::process::Command;

pub fn run_ollama_command(args: &[&str]) -> Result<(), Box<dyn std::error::Error>> {
    let status = Command::new("ollama").args(args).status()?;
    if status.success() {
        Ok(())
    } else {
        Err(format!(
            "Ollama command failed with exit code {}",
            status.code().unwrap_or(-1)
        )
        .into())
    }
}
