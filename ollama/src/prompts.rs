// SPDX-License-Identifier: MIT

/// Default system prompt for AI generations.
pub const DEFAULT_SYSTEM_PROMPT: &str = "You are an AI assistant. Respond helpfully.";

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_default_system_prompt() {
        assert!(!DEFAULT_SYSTEM_PROMPT.is_empty());
        assert!(DEFAULT_SYSTEM_PROMPT.contains("AI assistant"));
    }
}
