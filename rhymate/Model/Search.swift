typealias SearchHistory = [String]

enum SearchError {
    case noResults
    case generic
    case network
}

enum SearchScope: String, CaseIterable {
    case result
    case history
}
