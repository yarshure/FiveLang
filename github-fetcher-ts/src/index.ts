// Use require for node-fetch v2 (CommonJS)
const fetch = require('node-fetch');
// Import specific types if needed (Response might conflict with DOM types)
// import { Response as FetchResponse } from 'node-fetch';

// Import readline for user input
import * as readline from 'readline';
import { URL, URLSearchParams } from 'url'; // Use Node's built-in URL handling

// --- Interfaces for Type Safety ---

// Describes the structure of a repository object from the GitHub API
// Using snake_case to match the JSON keys directly for simplicity with fetch().json()
interface Repository {
    id: number;
    full_name: string;
    stargazers_count: number;
    html_url: string;
    description: string | null; // Optional description
}

// Describes the structure of the GitHub API search response
interface SearchResponse {
    total_count: number;
    incomplete_results: boolean;
    items: Repository[];
}

// --- Custom Error Class ---
class ApiError extends Error {
    constructor(message: string, public status?: number, public details?: string) {
        super(message);
        this.name = 'ApiError';
    }
}

// --- API Fetching Function ---

/**
 * Fetches the top N starred repositories for a given category from GitHub.
 * @param category The category (topic) to search for.
 * @param count The number of results to return.
 * @returns A Promise resolving to an array of Repository objects.
 */
async function fetchTopRepositories(category: string, count: number): Promise<Repository[]> {
    const baseURL = 'https://api.github.com/search/repositories';

    // Build URL safely
    const params = new URLSearchParams({
        q: `topic:${category}`,
        sort: 'stars',
        order: 'desc',
        per_page: count.toString(),
    });

    const url = new URL(baseURL);
    url.search = params.toString();

    console.log(`Workspaceing repository info for category '${category}'...`);

    const headers = {
        'Accept': 'application/vnd.github.v3+json',
        // IMPORTANT: Set a descriptive User-Agent header
        'User-Agent': 'typescript-github-repo-fetcher-example (YourAppNameOrUsername)',
    };

    try {
        // Type assertion needed because require returns 'any'
        const response = await (fetch as typeof globalThis.fetch)(url.toString(), { headers });

        if (!response.ok) {
            // Try to get more details from the error response body
            const errorBody = await response.text();
            // Handle rate limit specifically? Check response.status === 403
            // Check response.headers.get('x-ratelimit-remaining') === '0'
            throw new ApiError(
                `GitHub API error`,
                response.status,
                errorBody || response.statusText
            );
        }

        // Parse JSON - Use type assertion here
        const data = (await response.json()) as SearchResponse;

        if (!data || !data.items) {
             throw new Error('Invalid API response structure received.');
        }

        if (data.items.length === 0) {
            throw new ApiError(`No repositories found for category '${category}'.`);
        }

        return data.items;

    } catch (error) {
        if (error instanceof ApiError) {
             // Re-throw specific API errors
             throw error;
        } else if (error instanceof Error) {
            // Wrap other errors (e.g., network issues from fetch)
            throw new Error(`Network or other error during fetch: ${error.message}`);
        } else {
            // Handle unexpected error types
            throw new Error(`An unknown error occurred: ${error}`);
        }
    }
}

// --- Main Execution Function ---

// Helper function to ask questions using readline with Promises
function askQuestion(query: string, rl: readline.Interface): Promise<string> {
    return new Promise((resolve) => rl.question(query, resolve));
}

async function main() {
    // Set up readline interface
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });

    try {
        // const categoryInput = await askQuestion(
        //     'Enter the GitHub repository category (e.g., ai, game, typescript): '
        // );
        // Inside the main() async function, within the try block:

const categoryInput = await askQuestion(
    'Enter the GitHub repository category (e.g., ai, game, typescript): ',
    rl // Pass the rl instance here
);
        const category = categoryInput.trim();

        if (!category) {
            throw new Error('Category cannot be empty.');
        }

        // Call the fetching function
        const repositories = await fetchTopRepositories(category, 10);

        console.log(`\n--- Top ${repositories.length} repositories for category '${category}' by stars ---`);
        repositories.forEach((repo, index) => {
            console.log(
                `${(index + 1).toString().padStart(2)}. ${repo.full_name.padEnd(50)} - Stars: ${repo.stargazers_count.toString().padEnd(8)} - URL: ${repo.html_url}`
            );
        });

    } catch (error) {
        console.error('\nError fetching repositories:');
        if (error instanceof ApiError) {
            console.error(`  Status: ${error.status || 'N/A'}`);
            console.error(`  Message: ${error.message}`);
            if (error.details) console.error(`  Details: ${error.details}`);
        } else if (error instanceof Error) {
            console.error(`  Message: ${error.message}`);
        } else {
            console.error('An unknown error occurred:', error);
        }
        process.exitCode = 1; // Set exit code to indicate failure
    } finally {
        // IMPORTANT: Close the readline interface
        rl.close();
    }
}

// Run the main function
main();