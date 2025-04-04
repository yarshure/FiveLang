//
//  main.swift
//  MKcmd
//
//  Created by apple on 4/4/2025.
//

//#!/usr/bin/env swift
// The line above helps make the script directly executable after chmod +x

import Foundation
//import NewModel // Import the new file
// Import System for exit() - uncomment if needed, usually Foundation provides it implicitly or exit() isn't strictly required for script end.
 import mindZLibrary

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

// --- Custom Error Type ---

// Enum for error messages to support translation/localization
enum ErrorMessages: String {
    case invalidURL = "Failed to create a valid URL for the API request."
    case networkError = "Network error accessing GitHub API."
    case apiError = "GitHub API Error."
    case decodingError = "Failed to decode API response."
    case rateLimitExceeded = "GitHub API rate limit exceeded."
    case noRepositoriesFound = "No repositories found for the specified category."
    case inputError = "Input Error: Category cannot be empty."

    // Function to translate or localize messages
    func localized() -> String {
        // Replace this with actual localization logic if needed
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

// Custom error enum for more specific error handling
enum GitHubError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case apiError(statusCode: Int, message: String?)
    case decodingError(Error)
    case rateLimitExceeded(resetDate: Date?)
    case noRepositoriesFound(category: String)
    case inputError(String)

    // Provides user-friendly error messages using ErrorMessages
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return ErrorMessages.invalidURL.localized()
        case .networkError(let underlyingError):
            return "\(ErrorMessages.networkError.localized()): \(underlyingError.localizedDescription)"
        case .apiError(let statusCode, let message):
            return "\(ErrorMessages.apiError.localized()) (Status Code: \(statusCode)): \(message ?? "No additional message.")"
        case .decodingError(let underlyingError):
            return "\(ErrorMessages.decodingError.localized()): \(underlyingError.localizedDescription)"
        case .rateLimitExceeded(let resetDate):
            if let date = resetDate {
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                return "\(ErrorMessages.rateLimitExceeded.localized()) Try again after \(formatter.string(from: date))."
            } else {
                return ErrorMessages.rateLimitExceeded.localized()
            }
        case .noRepositoriesFound(let category):
            return "\(ErrorMessages.noRepositoriesFound.localized()) Category: '\(category)'."
        case .inputError(let message):
            return "\(ErrorMessages.inputError.localized()) \(message)"
        }
    }
}

// --- API Fetching Function ---

func fetchTopRepositories(category: String, count: Int = 10) async throws -> [NewModel.Items] {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.github.com"
    components.path = "/search/repositories"
    components.queryItems = [
        URLQueryItem(name: "q", value: "topic:\(category)"),
        URLQueryItem(name: "sort", value: "stars"),
        URLQueryItem(name: "order", value: "desc"),
        URLQueryItem(name: "per_page", value: String(count))
    ]

    guard let url = components.url else {
        throw GitHubError.invalidURL
    }

    var request = URLRequest(url: url)
    request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
    request.timeoutInterval = 20

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
        let responseBody = String(data: data, encoding: .utf8) ?? "Could not read response body"
        throw GitHubError.apiError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0, message: responseBody)
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let searchResponse = try decoder.decode(NewModel.self, from: data)

    if searchResponse.items.isEmpty {
        throw GitHubError.noRepositoriesFound(category: category)
    }

    return searchResponse.items
}



// --- Main Execution Block ---

Logger.isDebugEnabled = true // Set this to false to disable debug logs

Logger.info("Enter the GitHub repository category (e.g., ai, game, swift):")

guard let categoryInput = readLine(), !categoryInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
    let inputError = GitHubError.inputError("Category cannot be empty.")
    Logger.error("Error: \(inputError.localizedDescription ?? "Invalid input.")")
    exit(1)
}

let category = categoryInput.trimmingCharacters(in: .whitespacesAndNewlines)

do {
    let repositories = try await fetchTopRepositories(category: category, count: 10)

    Logger.info("\n--- Top \(repositories.count) repositories for category '\(category)' by stars ---")
    for repo in repositories {
        Logger.log("\(repo)")
    }
} catch let error as GitHubError {
    Logger.error("\nError: \(error.localizedDescription ?? "An unknown error occurred.")")
    exit(1)
} catch {
    Logger.error("\nUnexpected error: \(error.localizedDescription)")
    exit(1)
}




