typealias JSONable = Decodable & Encodable

enum Mutation {
    case add
    case remove
}

enum SearchError {
    case noResults
    case generic
    case network
}
