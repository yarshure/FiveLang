use serde::Deserialize;
use reqwest::header::{ACCEPT, USER_AGENT}; // Import necessary headers
use reqwest::StatusCode;
use thiserror::Error;
// use url::Url; // Uncomment if using the Url type instead of String for html_url

// --- Data Structures ---

#[derive(Deserialize, Debug)] // Debug allows printing the struct easily
struct Repository {
    id: u64, // Using u64 for potentially large IDs
    #[serde(rename = "full_name")] // Map JSON key "full_name" to this field
    full_name: String,
    #[serde(rename = "stargazers_count")]
    stargazers_count: u64,
    #[serde(rename = "html_url")]
    html_url: String, // Using String for simplicity, could use url::Url
    // html_url: url::Url, // Alternative using the url crate
}

#[derive(Deserialize, Debug)]
struct SearchResponse {
    items: Vec<Repository>,
    // We might only care about 'items', but can add other fields like total_count if needed
    // total_count: u64,
    // incomplete_results: bool,
}

// --- Custom Error Type ---

#[derive(Error, Debug)]
enum AppError {
    #[error("Network request failed: {0}")]
    NetworkError(#[from] reqwest::Error), // Automatically converts reqwest errors

    #[error("Failed to parse JSON response: {0}")]
    JsonParseError(#[from] serde_json::Error), // Automatically converts serde_json errors

    #[error("GitHub API error: Status {status} - {message}")]
    ApiError {
        status: StatusCode,
        message: String,
    },

    #[error("No repositories found for category '{0}'")]
    NoRepositoriesFound(String),

    #[error("I/O error reading input: {0}")]
    InputError(#[from] std::io::Error),

    #[error("Input category cannot be empty")]
    InputEmptyError,
    // #[error("Failed to parse URL: {0}")] // Add if using url::Url
    // UrlParseError(#[from] url::ParseError),
}

// --- API Fetching Function ---

/// Fetches the top N starred repositories for a given category from GitHub.
async fn fetch_top_repositories(
    client: &reqwest::Client, // Pass client for reuse
    category: &str,
    count: u8, // u8 is enough for small counts like 10
) -> Result<Vec<Repository>, AppError> {
    let url = "https://api.github.com/search/repositories";

    let params = [
        ("q", format!("topic:{}", category)), // Build the query string
        ("sort", "stars".to_string()),
        ("order", "desc".to_string()),
        ("per_page", count.to_string()),
    ];

    println!("Fetching repository info for category '{}'...", category);

    let response = client
        .get(url)
        .query(&params)
        // GitHub API requires a User-Agent header
        .header(USER_AGENT, "rust-github-repo-fetcher-example (YourAppName)") // IMPORTANT: Set a User-Agent
        .header(ACCEPT, "application/vnd.github.v3+json")
        .send()
        .await?; // Propagate network errors

    let status = response.status();
    if !status.is_success() {
        // Try to read error message from response body
        let error_message = response
            .text() // Read body as text
            .await // Wait for body
            .unwrap_or_else(|_| "Could not read error body".to_string()); // Fallback message

        // Special handling for rate limits might go here if needed (check status == 403)

        return Err(AppError::ApiError {
            status,
            message: error_message,
        });
    }

    // Deserialize the JSON response directly if status is success
    let search_response = response
        .json::<SearchResponse>() // Deserialize into SearchResponse
        .await?; // Propagate JSON parsing errors or network errors during body read

    if search_response.items.is_empty() {
        return Err(AppError::NoRepositoriesFound(category.to_string()));
    }

    Ok(search_response.items)
}

// --- Main Execution Block ---

#[tokio::main] // Attribute to set up the Tokio runtime
async fn main() -> Result<(), AppError> { // Return Result to allow '?' for errors in main
    // Create a single reqwest client to be reused (good practice)
    let client = reqwest::Client::builder()
         // Optionally configure client (timeouts, etc.)
         // .timeout(std::time::Duration::from_secs(15))
        .build()?; // Propagate client build errors

    println!("Enter the GitHub repository category (e.g., ai, game, rust):");

    let mut category_input = String::new();
    std::io::stdin().read_line(&mut category_input)?; // Read input, propagate I/O errors

    let category = category_input.trim(); // Trim whitespace
    if category.is_empty() {
        return Err(AppError::InputEmptyError);
    }

    // Call the async function and await its result
    match fetch_top_repositories(&client, category, 10).await {
        Ok(repositories) => {
            println!(
                "\n--- Top {} repositories for category '{}' by stars ---",
                repositories.len(), // Use actual count returned
                category
            );
            for (index, repo) in repositories.iter().enumerate() {
                // Basic formatting, can be enhanced
                println!(
                    "{:>2}. {:<50} - Stars: {:<8} - URL: {}",
                    index + 1,
                    repo.full_name,
                    repo.stargazers_count,
                    repo.html_url // Access the field directly
                    // repo.html_url.as_str() // If using url::Url type
                );
            }
        }
        Err(e) => {
            // Print errors to stderr
            eprintln!("\nError fetching repositories: {}", e);
            // Optionally exit with non-zero status
             std::process::exit(1);
        }
    }

    Ok(()) // Indicate successful completion of main
}