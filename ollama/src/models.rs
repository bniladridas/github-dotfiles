// SPDX-License-Identifier: MIT

use scraper::{Html, Selector};

use crate::Error;

const OLLAMA_LIBRARY_URL: &str = "https://ollama.ai/library";

pub async fn fetch_models() -> Result<Vec<String>, Error> {
    let url = OLLAMA_LIBRARY_URL;
    let response = reqwest::get(url).await?;
    let body = response.text().await?;
    let document = Html::parse_document(&body);
    let selector = Selector::parse("a[href^='/library/']").unwrap();

    let mut models = Vec::new();
    for element in document.select(&selector) {
        if let Some(href) = element.value().attr("href") {
            if let Some(name) = href.strip_prefix("/library/") {
                if !name.contains('/') && !models.contains(&name.to_string()) {
                    models.push(name.to_string());
                }
            }
        }
    }
    models.sort();
    Ok(models)
}
