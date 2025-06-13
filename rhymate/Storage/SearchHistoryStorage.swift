import Foundation

struct SearchHistoryStorage {
    let SEARCH_HISTORY_KEY = "searchHistory"
    private let storageHandler = StorageHandler()
    
    init() {
        storageHandler.createKeyIfNoneExists(key: SEARCH_HISTORY_KEY)
    }
    
    private func sortByTimestampDescending(_ array: [SearchHistoryEntry]) -> [SearchHistoryEntry] {
        return array.sorted { (lhs, rhs) -> Bool in
            return lhs.timestamp > rhs.timestamp
        }
    }
    
    func get() -> [SearchHistoryEntry]  {
        if let searchHistory: [SearchHistoryEntry] = storageHandler.getJSON(key: SEARCH_HISTORY_KEY) {
            return sortByTimestampDescending(searchHistory)
        }
        storageHandler.createKeyIfNoneExists(key: SEARCH_HISTORY_KEY)
        return []
    }
    
    /// Mutate search history in UserDefaults
    func mutate(_ type: Mutation, _ word: String) throws  {
        switch type {
        case .add:
            var searchHistory = self.get()
            let timestamp = Date().timeIntervalSinceReferenceDate
            var newHistory = searchHistory.filter { $0.input != word }
            newHistory.insert(SearchHistoryEntry(input: word, timestamp: timestamp), at: 0)
            searchHistory = newHistory
            try storageHandler.setJSON(value: searchHistory, key: SEARCH_HISTORY_KEY)
        case .remove:
            let searchHistory = self.get().filter { $0.input != word }
            try storageHandler.setJSON(value: searchHistory, key: SEARCH_HISTORY_KEY)
        }
    }
}
