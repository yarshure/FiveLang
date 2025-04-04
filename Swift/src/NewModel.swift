import Foundation

public struct NewModel: Codable { // Mark the struct as public
    public let totalCount: Int? // Mark properties as public
    public let incompleteResults: Bool?
    public let items: [Items]

    public struct Items: Codable { // Mark the nested struct as public
        public let id: Int
        public let nodeId: String?
        public let name: String
        public let fullName: String?
        public let `private`: Bool
        public let owner: Owner?
        public let htmlUrl: URL?
        public let description: String?
        public let fork: Bool?
        public let url: String?
        public let forksUrl: String?
        public let keysUrl: String?
        public let collaboratorsUrl: String?
        public let teamsUrl: String?
        public let hooksUrl: String?
        public let issueEventsUrl: String?
        public let eventsUrl: String?
        public let assigneesUrl: String?
        public let branchesUrl: String?
        public let tagsUrl: String?
        public let blobsUrl: String?
        public let gitTagsUrl: String?
        public let gitRefsUrl: String?
        public let treesUrl: String?
        public let statusesUrl: String?
        public let languagesUrl: String?
        public let stargazersUrl: String?
        public let contributorsUrl: String?
        public let subscribersUrl: String?
        public let subscriptionUrl: String?
        public let commitsUrl: String?
        public let gitCommitsUrl: String?
        public let commentsUrl: String?
        public let issueCommentUrl: String?
        public let contentsUrl: String?
        public let compareUrl: String?
        public let mergesUrl: String?
        public let archiveUrl: String?
        public let downloadsUrl: URL?
        public let issuesUrl: String?
        public let pullsUrl: String?
        public let milestonesUrl: String?
        public let notificationsUrl: String?
        public let labelsUrl: String?
        public let releasesUrl: String?
        public let deploymentsUrl: String?
        public let createdAt: String?
        public let updatedAt: String?
        public let pushedAt: String?
        public let gitUrl: String?
        public let sshUrl: String?
        public let cloneUrl: String?
        public let svnUrl: String?
        public let homepage: String?
        public let size: Int
        public let stargazersCount: Int?
        public let watchersCount: Int?
        public let language: String?
        public let hasIssues: Bool?
        public let hasProjects: Bool?
        public let hasDownloads: Bool?
        public let hasWiki: Bool?
        public let hasPages: Bool?
        public let hasDiscussions: Bool?
        public let forksCount: Int?
        public let mirrorUrl: String?
        public let archived: Bool?
        public let disabled: Bool?
        public let openIssuesCount: Int?
        public let license: License?
        public let allowForking: Bool?
        public let isTemplate: Bool?
        public let webCommitSignoffRequired: Bool?
        public let topics: [String]?
        public let visibility: String?
        public let forks: Int?
        public let openIssues: Int?
        public let watchers: Int?
        public let defaultBranch: String?
        public let score: Double?

        public struct Owner: Codable { // Mark the nested struct as public
            public let login: String
            public let id: Int
            public let nodeId: String?
            public let avatarUrl: String?
            public let gravatarId: String?
            public let url: String
            public let htmlUrl: String?
            public let followersUrl: String?
            public let followingUrl: String?
            public let gistsUrl: String?
            public let starredUrl: String?
            public let subscriptionsUrl: String?
            public let organizationsUrl: String?
            public let reposUrl: URL?
            public let eventsUrl: String?
            public let receivedEventsUrl: String?
            public let type: String?
            public let userViewType: String?
            public let siteAdmin: Bool?

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

        public struct License: Codable { // Mark the nested struct as public
            public let key: String?
            public let name: String?
            public let spdxId: String?
            public let url: URL?
            public let nodeId: String?

            private enum CodingKeys: String, CodingKey {
                case key
                case name
                case spdxId = "spdx_id"
                case url
                case nodeId = "node_id"
            }
        }

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

    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}