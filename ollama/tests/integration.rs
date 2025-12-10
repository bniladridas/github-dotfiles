use github_dotfiles_ollama::generate_response;

#[tokio::test]
async fn test_generate_response_integration() {
    // Test error case when Ollama is not running
    let result = generate_response("test-model", "Hello", "You are helpful").await;
    // Should fail if Ollama not running
    assert!(result.is_err());
}
