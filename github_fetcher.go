package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io" // Import the 'io' package for io.ReadAll
	"net/http"
	"net/url"
	"os"
	"strconv"
	"strings"
	"time"
)

// --- Data Structures ---

type Repository struct {
	ID              uint64 `json:"id"`
	FullName        string `json:"full_name"`
	StargazersCount uint64 `json:"stargazers_count"`
	HTMLURL         string `json:"html_url"`
}

type SearchResponse struct {
	Items []Repository `json:"items"`
}

// --- API Fetching Function ---

func fetchTopRepositories(category string, count int) ([]Repository, error) {
	baseURL := "https://api.github.com/search/repositories"

	params := url.Values{}
	params.Add("q", fmt.Sprintf("topic:%s", category))
	params.Add("sort", "stars")
	params.Add("order", "desc")
	params.Add("per_page", strconv.Itoa(count))

	u, err := url.Parse(baseURL)
	if err != nil {
		return nil, fmt.Errorf("failed to parse base URL: %w", err)
	}
	u.RawQuery = params.Encode()
	fullURL := u.String()

	fmt.Printf("Fetching repository info for category '%s'...\n", category)

	req, err := http.NewRequest("GET", fullURL, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("Accept", "application/vnd.github.v3+json")
	req.Header.Set("User-Agent", "go-github-repo-fetcher-example (YourAppNameOrUsername)") // CHANGE THIS

	client := &http.Client{
		Timeout: 20 * time.Second,
	}

	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to perform request: %w", err)
	}
	defer resp.Body.Close() // Ensure body is closed

	// Check the status code
	if resp.StatusCode != http.StatusOK {
		// Try to read body using standard library io.ReadAll
		bodyBytes, readErr := io.ReadAll(resp.Body)
		errorDetails := ""
		if readErr != nil {
			errorDetails = fmt.Sprintf("(could not read response body: %v)", readErr)
		} else {
			errorDetails = string(bodyBytes)
		}
		// Handle rate limit specifically? (Status 403)
		// if resp.StatusCode == http.StatusForbidden { ... }
		return nil, fmt.Errorf("GitHub API error: Status %s - %s", resp.Status, errorDetails)
	}

	// Decode the JSON response body if status is OK
	var searchResponse SearchResponse
	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&searchResponse); err != nil {
		// Note: If status was OK but decoding fails, the body might not be valid JSON
		return nil, fmt.Errorf("failed to decode JSON response: %w", err)
	}

	if len(searchResponse.Items) == 0 {
		return nil, fmt.Errorf("no repositories found for category '%s'", category)
	}

	return searchResponse.Items, nil // Success
}

// --- Main Execution Function ---

func main() {
	fmt.Println("Enter the GitHub repository category (e.g., ai, game, go):")

	reader := bufio.NewReader(os.Stdin)
	categoryInput, err := reader.ReadString('\n')
	if err != err { // Note: Corrected error check
		fmt.Fprintf(os.Stderr, "Error reading input: %v\n", err)
		os.Exit(1)
	}

	category := strings.TrimSpace(categoryInput)
	if category == "" {
		fmt.Fprintln(os.Stderr, "Error: Category cannot be empty.")
		os.Exit(1)
	}

	repositories, err := fetchTopRepositories(category, 10)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error fetching repositories: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("\n--- Top %d repositories for category '%s' by stars ---\n", len(repositories), category)
	for i, repo := range repositories {
		fmt.Printf("%2d. %-50s - Stars: %-8d - URL: %s\n",
			i+1,
			repo.FullName,
			repo.StargazersCount,
			repo.HTMLURL,
		)
	}
}

// NOTE: The custom SReadAll function has been removed.