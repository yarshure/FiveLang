"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
// Use require for node-fetch v2 (CommonJS)
const fetch = require('node-fetch');
// Import specific types if needed (Response might conflict with DOM types)
// import { Response as FetchResponse } from 'node-fetch';
// Import readline for user input
const readline = __importStar(require("readline"));
const url_1 = require("url"); // Use Node's built-in URL handling
// --- Custom Error Class ---
class ApiError extends Error {
    constructor(message, status, details) {
        super(message);
        this.status = status;
        this.details = details;
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
function fetchTopRepositories(category, count) {
    return __awaiter(this, void 0, void 0, function* () {
        const baseURL = 'https://api.github.com/search/repositories';
        // Build URL safely
        const params = new url_1.URLSearchParams({
            q: `topic:${category}`,
            sort: 'stars',
            order: 'desc',
            per_page: count.toString(),
        });
        const url = new url_1.URL(baseURL);
        url.search = params.toString();
        console.log(`Workspaceing repository info for category '${category}'...`);
        const headers = {
            'Accept': 'application/vnd.github.v3+json',
            // IMPORTANT: Set a descriptive User-Agent header
            'User-Agent': 'typescript-github-repo-fetcher-example (YourAppNameOrUsername)',
        };
        try {
            // Type assertion needed because require returns 'any'
            const response = yield fetch(url.toString(), { headers });
            if (!response.ok) {
                // Try to get more details from the error response body
                const errorBody = yield response.text();
                // Handle rate limit specifically? Check response.status === 403
                // Check response.headers.get('x-ratelimit-remaining') === '0'
                throw new ApiError(`GitHub API error`, response.status, errorBody || response.statusText);
            }
            // Parse JSON - Use type assertion here
            const data = (yield response.json());
            if (!data || !data.items) {
                throw new Error('Invalid API response structure received.');
            }
            if (data.items.length === 0) {
                throw new ApiError(`No repositories found for category '${category}'.`);
            }
            return data.items;
        }
        catch (error) {
            if (error instanceof ApiError) {
                // Re-throw specific API errors
                throw error;
            }
            else if (error instanceof Error) {
                // Wrap other errors (e.g., network issues from fetch)
                throw new Error(`Network or other error during fetch: ${error.message}`);
            }
            else {
                // Handle unexpected error types
                throw new Error(`An unknown error occurred: ${error}`);
            }
        }
    });
}
// --- Main Execution Function ---
// Helper function to ask questions using readline with Promises
function askQuestion(query, rl) {
    return new Promise((resolve) => rl.question(query, resolve));
}
function main() {
    return __awaiter(this, void 0, void 0, function* () {
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
            const categoryInput = yield askQuestion('Enter the GitHub repository category (e.g., ai, game, typescript): ', rl // Pass the rl instance here
            );
            const category = categoryInput.trim();
            if (!category) {
                throw new Error('Category cannot be empty.');
            }
            // Call the fetching function
            const repositories = yield fetchTopRepositories(category, 10);
            console.log(`\n--- Top ${repositories.length} repositories for category '${category}' by stars ---`);
            repositories.forEach((repo, index) => {
                console.log(`${(index + 1).toString().padStart(2)}. ${repo.full_name.padEnd(50)} - Stars: ${repo.stargazers_count.toString().padEnd(8)} - URL: ${repo.html_url}`);
            });
        }
        catch (error) {
            console.error('\nError fetching repositories:');
            if (error instanceof ApiError) {
                console.error(`  Status: ${error.status || 'N/A'}`);
                console.error(`  Message: ${error.message}`);
                if (error.details)
                    console.error(`  Details: ${error.details}`);
            }
            else if (error instanceof Error) {
                console.error(`  Message: ${error.message}`);
            }
            else {
                console.error('An unknown error occurred:', error);
            }
            process.exitCode = 1; // Set exit code to indicate failure
        }
        finally {
            // IMPORTANT: Close the readline interface
            rl.close();
        }
    });
}
// Run the main function
main();
