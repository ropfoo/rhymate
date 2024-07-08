import Foundation

typealias RhymesHistory = [String: DatamuseRhymeResponse]

struct RhymesStorage {
    let RHYMES_HISTORY_KEY = "rhymesHistory"
    private let storageHandler = StorageHandler()
    
    init() {
        createRhymesHistoryIfNoneExists()
    }
    
    private func createRhymesHistoryIfNoneExists() {
        if !storageHandler.isKeyPresentInUserDefaults(key:RHYMES_HISTORY_KEY) {
            UserDefaults.standard.set("{}", forKey: RHYMES_HISTORY_KEY)
        }
    }
    
    private func getRhymesHistory() -> RhymesHistory  {
        if let history: RhymesHistory = storageHandler.getJSON(key: RHYMES_HISTORY_KEY) {
            return history
        }
        createRhymesHistoryIfNoneExists()
        return ["":[]]
    }
    
    /**
     Add rhymes to the UserDefaults store
     */
    func store(rhymes: DatamuseRhymeResponse, key: String) throws  {
        var currentRhymes = getRhymesHistory()
        currentRhymes[key] = rhymes
        try storageHandler.setJSON(value: currentRhymes, key: RHYMES_HISTORY_KEY)
    }
    
    /**
     Get rhymes for given word from UserDefaults store
     */
    func get(word: String) -> DatamuseRhymeResponse? {
        let currentRhymes = getRhymesHistory()
        if let rhymes = currentRhymes[word]  {
            return rhymes
        }
        return nil
    }
}
