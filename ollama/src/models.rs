use scraper::{Html, Selector};

pub async fn fetch_models() -> Result<Vec<String>, Box<dyn std::error::Error>> {
    let url = "https://ollama.ai/library";
    let response = reqwest::get(url).await?;
    let body = response.text().await?;
    let document = Html::parse_document(&body);
    let selector = Selector::parse("a[href^='/library/']").unwrap();

    let mut models = Vec::new();
    for element in document.select(&selector) {
        if let Some(href) = element.value().attr("href")
            && let Some(name) = href.strip_prefix("/library/")
            && !name.contains('/')
            && !models.contains(&name.to_string())
        {
            models.push(name.to_string());
        }
    }
    models.sort();
    Ok(models)
}
