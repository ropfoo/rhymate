import Foundation

struct WiktionaryDefinitionsStorage: RhymeStorage {
    let WIKTIONARY_DEFINITIONS_KEY = "wiktionaryDefintions"
    private let storageHandler = StorageHandler()

    init() {
        storageHandler.createKeyIfNoneExists(key: WIKTIONARY_DEFINITIONS_KEY)
    }
    
    private func getWiktionaryDefinitionsHistory() -> WiktionaryHistory  {
        if let history: WiktionaryHistory = storageHandler.getJSON(key: WIKTIONARY_DEFINITIONS_KEY) {
            return history
        }
        storageHandler.createKeyIfNoneExists(key: WIKTIONARY_DEFINITIONS_KEY)
        return ["":[]]
    }
    
    /// Add wiktionary definition to the UserDefaults
    func mutate(
        _ type: Mutation,
        data: WiktionaryDefinitions,
        key: String
    ) throws  {
        switch type {
        case .add:
            var wikionaryDefinitions = getWiktionaryDefinitionsHistory()
            wikionaryDefinitions[key] = data
            try storageHandler.setJSON(value: wikionaryDefinitions, key: WIKTIONARY_DEFINITIONS_KEY)
        case .remove:
            var wikionaryDefinitions = getWiktionaryDefinitionsHistory()
            wikionaryDefinitions.removeValue(forKey: key)
            try storageHandler.setJSON(value: wikionaryDefinitions, key: WIKTIONARY_DEFINITIONS_KEY)
        }
    }
    
    /// Get rhymes for given word from UserDefaults
    func get(word: String) -> WiktionaryDefinitions? {
        let wikionaryDefinitions = getWiktionaryDefinitionsHistory()
        if let definitions = wikionaryDefinitions[word]  {
            return definitions
        }
        return nil
    }
}
