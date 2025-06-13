import Foundation

struct SearchHistoryEntry: JSONable & Identifiable {
    var input: String
    let timestamp: TimeInterval
    var id: String { input + timestamp.description }
}

enum SearchError {
    case noResults
    case generic
    case network
}
