use std::process::Command;

use crate::Error;

pub fn run_ollama_command(args: &[&str]) -> Result<(), Error> {
    let status = Command::new("ollama").args(args).status()?;
    if status.success() {
        Ok(())
    } else {
        Err(Error::Command(format!(
            "Ollama command failed with exit code {}",
            status.code().unwrap_or(-1)
        )))
    }
}
