//
//  main.swift
//  MKcmd
//
//  Created by apple on 4/4/2025.
//

//#!/usr/bin/env swift
// The line above helps make the script directly executable after chmod +x

import Foundation
// Import System for exit() - uncomment if needed, usually Foundation provides it implicitly or exit() isn't strictly required for script end.
// import System

// --- Data Structures (Codable) ---

// Represents the overall JSON response from the GitHub Search API
struct SearchResponse: Decodable {
    let items: [Repository]
}

// Represents a single repository in the JSON response
// Using Identifiable is good practice but not strictly required here.
struct Repository: Decodable, Identifiable {
    let id: Int
    let fullName: String
    let stargazersCount: Int
    let htmlUrl: URL // Use URL type for URLs

    // Maps JSON snake_case keys to Swift camelCase properties
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case htmlUrl = "html_url"
    }
}
struct NewModel: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    struct Items: Codable {
        let id: Int
        let nodeId: String?
        let name: String
        let fullName: String?
        let `private`: Bool
        struct Owner: Codable {
            let login: String
            let id: Int
            let nodeId: String?
            let avatarUrl: String?
            let gravatarId: String?
            let url: String
            let htmlUrl: String?
            let followersUrl: String?
            let followingUrl: String?
            let gistsUrl: String?
            let starredUrl: String?
            let subscriptionsUrl: String?
            let organizationsUrl: String?
            let reposUrl: URL?
            let eventsUrl: String?
            let receivedEventsUrl: String?
            let type: String?
            let userViewType: String?
            let siteAdmin: Bool?
            private enum CodingKeys: String, CodingKey {
                case login
                case id
                case nodeId = "node_id"
                case avatarUrl = "avatar_url"
                case gravatarId = "gravatar_id"
                case url
                case htmlUrl = "html_url"
                case followersUrl = "followers_url"
                case followingUrl = "following_url"
                case gistsUrl = "gists_url"
                case starredUrl = "starred_url"
                case subscriptionsUrl = "subscriptions_url"
                case organizationsUrl = "organizations_url"
                case reposUrl = "repos_url"
                case eventsUrl = "events_url"
                case receivedEventsUrl = "received_events_url"
                case type
                case userViewType = "user_view_type"
                case siteAdmin = "site_admin"
            }
        }
        let owner: Owner?
        let htmlUrl: URL?
        let description: String?
        let fork: Bool?
        let url: String?
        let forksUrl: String?
        let keysUrl: String?
        let collaboratorsUrl: String?
        let teamsUrl: String?
        let hooksUrl: String?
        let issueEventsUrl: String?
        let eventsUrl: String?
        let assigneesUrl: String?
        let branchesUrl: String?
        let tagsUrl: String?
        let blobsUrl: String?
        let gitTagsUrl: String?
        let gitRefsUrl: String?
        let treesUrl: String?
        let statusesUrl: String?
        let languagesUrl: String?
        let stargazersUrl: String?
        let contributorsUrl: String?
        let subscribersUrl: String?
        let subscriptionUrl: String?
        let commitsUrl: String?
        let gitCommitsUrl: String?
        let commentsUrl: String?
        let issueCommentUrl: String?
        let contentsUrl: String?
        let compareUrl: String?
        let mergesUrl: String?
        let archiveUrl: String?
        let downloadsUrl: URL?
        let issuesUrl: String?
        let pullsUrl: String?
        let milestonesUrl: String?
        let notificationsUrl: String?
        let labelsUrl: String?
        let releasesUrl: String?
        let deploymentsUrl: String?
        let createdAt: String?
        let updatedAt: String?
        let pushedAt: String?
        let gitUrl: String?
        let sshUrl: String?
        let cloneUrl: String?
        let svnUrl: String?
        let homepage: String?
        let size: Int
        let stargazersCount: Int?
        let watchersCount: Int?
        let language: String?
        let hasIssues: Bool?
        let hasProjects: Bool?
        let hasDownloads: Bool?
        let hasWiki: Bool?
        let hasPages: Bool?
        let hasDiscussions: Bool?
        let forksCount: Int?
        let mirrorUrl: String? //TODO: Specify the type to conforms Codable protocol
        let archived: Bool?
        let disabled: Bool?
        let openIssuesCount: Int?
        struct License: Codable {
            let key: String?
            let name: String?
            let spdxId: String?
            let url: URL?
            let nodeId: String?
            private enum CodingKeys: String, CodingKey {
                case key
                case name
                case spdxId = "spdx_id"
                case url
                case nodeId = "node_id"
            }
        }
        let license: License?
        let allowForking: Bool?
        let isTemplate: Bool?
        let webCommitSignoffRequired: Bool?
        let topics: [String]?
        let visibility: String?
        let forks: Int?
        let openIssues: Int?
        let watchers: Int?
        let defaultBranch: String?
        let score: Double?
        private enum CodingKeys: String, CodingKey {
            case id
            case nodeId = "node_id"
            case name
            case fullName = "full_name"
            case `private`
            case owner
            case htmlUrl = "html_url"
            case description
            case fork
            case url
            case forksUrl = "forks_url"
            case keysUrl = "keys_url"
            case collaboratorsUrl = "collaborators_url"
            case teamsUrl = "teams_url"
            case hooksUrl = "hooks_url"
            case issueEventsUrl = "issue_events_url"
            case eventsUrl = "events_url"
            case assigneesUrl = "assignees_url"
            case branchesUrl = "branches_url"
            case tagsUrl = "tags_url"
            case blobsUrl = "blobs_url"
            case gitTagsUrl = "git_tags_url"
            case gitRefsUrl = "git_refs_url"
            case treesUrl = "trees_url"
            case statusesUrl = "statuses_url"
            case languagesUrl = "languages_url"
            case stargazersUrl = "stargazers_url"
            case contributorsUrl = "contributors_url"
            case subscribersUrl = "subscribers_url"
            case subscriptionUrl = "subscription_url"
            case commitsUrl = "commits_url"
            case gitCommitsUrl = "git_commits_url"
            case commentsUrl = "comments_url"
            case issueCommentUrl = "issue_comment_url"
            case contentsUrl = "contents_url"
            case compareUrl = "compare_url"
            case mergesUrl = "merges_url"
            case archiveUrl = "archive_url"
            case downloadsUrl = "downloads_url"
            case issuesUrl = "issues_url"
            case pullsUrl = "pulls_url"
            case milestonesUrl = "milestones_url"
            case notificationsUrl = "notifications_url"
            case labelsUrl = "labels_url"
            case releasesUrl = "releases_url"
            case deploymentsUrl = "deployments_url"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case pushedAt = "pushed_at"
            case gitUrl = "git_url"
            case sshUrl = "ssh_url"
            case cloneUrl = "clone_url"
            case svnUrl = "svn_url"
            case homepage
            case size
            case stargazersCount = "stargazers_count"
            case watchersCount = "watchers_count"
            case language
            case hasIssues = "has_issues"
            case hasProjects = "has_projects"
            case hasDownloads = "has_downloads"
            case hasWiki = "has_wiki"
            case hasPages = "has_pages"
            case hasDiscussions = "has_discussions"
            case forksCount = "forks_count"
            case mirrorUrl = "mirror_url"
            case archived
            case disabled
            case openIssuesCount = "open_issues_count"
            case license
            case allowForking = "allow_forking"
            case isTemplate = "is_template"
            case webCommitSignoffRequired = "web_commit_signoff_required"
            case topics
            case visibility
            case forks
            case openIssues = "open_issues"
            case watchers
            case defaultBranch = "default_branch"
            case score
        }
    }
    let items: [Items]
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
// --- Custom Error Type ---

// Custom error enum for more specific error handling
enum GitHubError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case apiError(statusCode: Int, message: String?) // HTTP errors from the API
    case decodingError(Error)
    case rateLimitExceeded(resetDate: Date?)
    case noRepositoriesFound(category: String)
    case inputError(String) // For input validation

    // Provides user-friendly error messages
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Failed to create a valid URL for the API request."
        case .networkError(let underlyingError):
            return "Network error accessing GitHub API: \(underlyingError.localizedDescription)"
        case .apiError(let statusCode, let message):
            return "GitHub API Error (Status Code: \(statusCode)): \(message ?? "No additional message.")"
        case .decodingError(let underlyingError):
             // Provide more detail for decoding errors if possible
             if let decodingContext = underlyingError as? DecodingError {
                 switch decodingContext {
                 case .keyNotFound(let key, let context):
                     return "Decoding Error: Key '\(key.stringValue)' not found. Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
                 case .typeMismatch(let type, let context):
                     return "Decoding Error: Type mismatch for type '\(type)'. Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
                 case .valueNotFound(let type, let context):
                     return "Decoding Error: Value not found for type '\(type)'. Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
                 case .dataCorrupted(let context):
                     return "Decoding Error: Data corrupted. Path: \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) - \(context.debugDescription)"
                 @unknown default:
                     return "Unknown Decoding Error: \(underlyingError.localizedDescription)"
                 }
             } else {
                 return "Failed to decode API response: \(underlyingError.localizedDescription)"
             }
        case .rateLimitExceeded(let resetDate):
            if let date = resetDate {
                 let formatter = DateFormatter()
                 formatter.dateStyle = .none
                 formatter.timeStyle = .medium
                 return "GitHub API rate limit exceeded. Try again after \(formatter.string(from: date))."
            } else {
                return "GitHub API rate limit exceeded. Try again later."
            }
        case .noRepositoriesFound(let category):
            return "No repositories found for category '\(category)'."
        case .inputError(let message):
            return "Input Error: \(message)"
        }
    }
}


// --- API Fetching Function ---

// Asynchronous function to fetch top repositories
func fetchTopRepositories(category: String, count: Int = 10) async throws -> [NewModel.Items] {
    print("Fetching repository info for category '\(category)'...")

    // 1. Construct URL safely using URLComponents
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.github.com"
    components.path = "/search/repositories"
    components.queryItems = [
        URLQueryItem(name: "q", value: "topic:\(category)"),
        URLQueryItem(name: "sort", value: "stars"),
        URLQueryItem(name: "order", value: "desc"),
        URLQueryItem(name: "per_page", value: String(count)) // Parameter must be a String
    ]

    guard let url = components.url else {
        throw GitHubError.invalidURL
    }

    // 2. Create URLRequest (add headers if needed)
    var request = URLRequest(url: url)
    print(url)
    request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
    request.timeoutInterval = 20 // Set a timeout (e.g., 20 seconds)

    // 3. Perform API request using URLSession
    let data: Data
    let response: URLResponse
    do {
        // Use async/await for the network request
        (data, response) = try await URLSession.shared.data(for: request)
       
    } catch {
        // Catch general network errors (timeout, DNS lookup failure, etc.)
        throw GitHubError.networkError(error)
    }
    //print(String(data))
    // 4. Validate HTTP Response
    guard let httpResponse = response as? HTTPURLResponse else {
        // This should typically not happen if the request succeeded at the network level
         throw GitHubError.apiError(statusCode: 0, message: "Received an invalid HTTP response.")
    }

    // Check for Rate Limiting (Status Code 403) before checking other errors
     if httpResponse.statusCode == 403 {
        if let remaining = httpResponse.value(forHTTPHeaderField: "X-RateLimit-Remaining"), remaining == "0" {
             var resetDate: Date? = nil
             if let resetTimestamp = httpResponse.value(forHTTPHeaderField: "X-RateLimit-Reset"),
                let timestamp = TimeInterval(resetTimestamp) {
                 resetDate = Date(timeIntervalSince1970: timestamp)
             }
             throw GitHubError.rateLimitExceeded(resetDate: resetDate)
         } else {
             // Other 403 error (e.g., authentication needed, forbidden)
              let responseBody = String(data: data, encoding: .utf8) ?? "Could not read response body"
             throw GitHubError.apiError(statusCode: httpResponse.statusCode, message: "Access Forbidden (403). Details: \(responseBody)")
         }
     }

    // Check for other unsuccessful HTTP status codes (e.g., 404 Not Found, 422 Unprocessable Entity, 5xx Server Errors)
    guard (200..<300).contains(httpResponse.statusCode) else {
        // Try to read an error message from the response body
        let responseBody = String(data: data, encoding: .utf8) ?? "Could not read response body"
        print(responseBody)
        throw GitHubError.apiError(statusCode: httpResponse.statusCode, message: responseBody)
    }

    // 5. Decode JSON Data
    do {
        let decoder = JSONDecoder()
        print(String(decoding: data, as: UTF8.self))
        // Crucial for converting snake_case (API) to camelCase (Swift)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let searchResponse = try decoder.decode(NewModel.self, from: data)

        // Check if the API returned an empty list of items
        if searchResponse.items.isEmpty {
            throw GitHubError.noRepositoriesFound(category: category)
        }

        return searchResponse.items

    } catch let decodingError {
        // Catch JSON decoding errors
        throw GitHubError.decodingError(decodingError)
    }
}


// --- Main Execution Block (Top-Level Code) ---

// Check if running in interactive mode or script mode for better prompt handling if needed
// For simplicity, we assume direct script execution.

print("Enter the GitHub repository category (e.g., ai, game, swift):")

// Read user input
guard let categoryInput = readLine(), !categoryInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
    // Use the custom error type for consistency
    let inputError = GitHubError.inputError("Category cannot be empty.")
    print("Error: \(inputError.localizedDescription ?? "Invalid input.")")
    // Exit with a non-zero status code to indicate failure
    exit(1) // Requires 'import System' or implicitly available in Foundation? Usually works.
}

let category = categoryInput.trimmingCharacters(in: .whitespacesAndNewlines)

// Use a Task to create an asynchronous context for top-level await
// (Required if not using Swift 5.5+ or in environments where top-level await isn't directly supported)
// If using Swift 5.5+, you can often remove the Task { ... } wrapper. Try without it first.
// Task {
    do {
        // Call the async function and wait for the result
        // If not in Task { }, just use 'try await' directly here if Swift version supports it.
        let repositories = try await fetchTopRepositories(category: category, count: 10)

        print("\n--- Top \(repositories.count) repositories for category '\(category)' by stars ---")
        // Print the results
        for (index, repo) in repositories.enumerated() {
            // Format the output for better alignment
            print(repo)  // Repository URL
        }
        // Indicate successful completion (optional)
        // exit(0)

    } catch let error as GitHubError {
         // Print the user-friendly error message from our custom enum
        print("\nError fetching repositories: \(error.localizedDescription ?? "An unknown GitHub error occurred.")")
        exit(1) // Indicate failure
    } catch {
         // Catch any other unexpected errors
        print("\nAn unexpected error occurred: \(error.localizedDescription)")
        exit(1) // Indicate failure
    }
// } // End of Task block (if used)

// If not using Task { } and not explicitly calling exit(), the script ends here.
// If using Task { }, you might need to ensure the script waits for the Task.
// For simple scripts run via `swift run` or `swift`, this usually works okay.




