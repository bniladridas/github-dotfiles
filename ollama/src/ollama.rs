use std::process::Command;

use crate::Error;

/// Runs an Ollama command with the given arguments.
///
/// # Errors
///
/// Returns an `Error::Command` if the command fails to execute or returns a non-zero
/// exit status. If the process is terminated by a signal on a Unix-like system,
/// this is reported as a failure with exit code -1.
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
