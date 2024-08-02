import Foundation

struct SearchHistoryStorage {
    let SEARCH_HISTORY_KEY = "searchHistory"
    private let storageHandler = StorageHandler()

    init() {
        storageHandler.createKeyIfNoneExists(key: SEARCH_HISTORY_KEY)
    }
    
    func get() -> SearchHistory  {
        if let searchHistory: SearchHistory = storageHandler.getJSON(key: SEARCH_HISTORY_KEY) {
            return searchHistory
        }
        storageHandler.createKeyIfNoneExists(key: SEARCH_HISTORY_KEY)
        return []
    }
    
    /// Mutate search history in UserDefaults
    func mutate(
        _ type: Mutation,
        _ word: String
    ) throws  {
        switch type {
        case .add:
            var searchHistory = self.get()
            if !searchHistory.contains(word) {
                var newHistory = searchHistory.filter{!$0.contains(word)}
                newHistory.insert(word, at: 0)
                searchHistory = newHistory
            }
            try storageHandler.setJSON(value: searchHistory, key: SEARCH_HISTORY_KEY)
        case .remove:	
            let  searchHistory = self.get().filter{!$0.contains(word)}
            try storageHandler.setJSON(value: searchHistory, key: SEARCH_HISTORY_KEY)
        }
    }
}
