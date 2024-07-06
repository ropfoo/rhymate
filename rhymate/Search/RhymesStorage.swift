import Foundation

typealias RhymesHistory = [String: [String]]

let RHYMES_HISTORY_KEY = "rhymesHistory"

struct RhymesStorage {
    private let storageHandler = StorageHandler()
    
    init() {
        if !storageHandler.isKeyPresentInUserDefaults(key:RHYMES_HISTORY_KEY) {
            UserDefaults.standard.set("{}", forKey: RHYMES_HISTORY_KEY)
        }
    }
    
    private func getRhymesHistory() -> RhymesHistory  {
        let rhymesHistory: RhymesHistory? = storageHandler.getJSON(key: RHYMES_HISTORY_KEY)
        if let rhymesHistory {
            return  rhymesHistory
        }
        return ["":[]]
    }
    
    func store(rhymes: [String], key: String) throws  {
        var currentRhymes = getRhymesHistory()
        currentRhymes[key] = rhymes
        try storageHandler.setJSON(value: currentRhymes, key: RHYMES_HISTORY_KEY)
    }
    
    func get(word: String) -> RhymesResponse? {
        let currentRhymes = getRhymesHistory()	
        if let rhymes = currentRhymes[word]  {
            return RhymesResponse(rhymes: rhymes, word: word)
        }
        return nil
    }
}
