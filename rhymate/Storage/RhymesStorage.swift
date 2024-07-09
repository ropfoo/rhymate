import Foundation

typealias RhymesHistory = [String: DatamuseRhymeResponse]

struct RhymesStorage: RhymeStorage{
    let RHYMES_HISTORY_KEY = "rhymesHistory"
    private let storageHandler = StorageHandler()
    
    init() {
        storageHandler.createKeyIfNoneExists(key: RHYMES_HISTORY_KEY)
    }
    
    private func getRhymesHistory() -> RhymesHistory  {
        if let history: RhymesHistory = storageHandler.getJSON(key: RHYMES_HISTORY_KEY) {
            return history
        }
        storageHandler.createKeyIfNoneExists(key: RHYMES_HISTORY_KEY)
        return ["":[]]
    }
    
    /// Add rhymes to the UserDefaults
    func mutate(
        type: RhymeStorageMutation,
        data: DatamuseRhymeResponse,
        key: String
    ) throws  {
        switch type {
        case .add:
            var currentRhymes = getRhymesHistory()
            currentRhymes[key] = data
            try storageHandler.setJSON(value: currentRhymes, key: RHYMES_HISTORY_KEY)
        case .remove:
            var currentRhymes = getRhymesHistory()
            currentRhymes.removeValue(forKey: key)
            try storageHandler.setJSON(value: currentRhymes, key: RHYMES_HISTORY_KEY)
        }
    }
    
    /// Get rhymes for given word from UserDefaults
    func get(word: String) -> DatamuseRhymeResponse? {
        let currentRhymes = getRhymesHistory()
        if let rhymes = currentRhymes[word]  {
            return rhymes
        }
        return nil
    }
}
