import Foundation

struct FavoriteRhymesStorage: RhymeStorage {
    let FAVORITE_RHYMES_STORAGE_KEY = "favoriteRhymes"
    private let storageHandler = StorageHandler()
    
    init() {
        storageHandler.createKeyIfNoneExists(key: FAVORITE_RHYMES_STORAGE_KEY)
    }
    
    /// Get all favorite rhymes from UserDefaults storage
    func getFavoriteRhymes() -> FavoriteRhymes  {
        if let favoriteRhymes: FavoriteRhymes = storageHandler.getJSON(key: FAVORITE_RHYMES_STORAGE_KEY) {
            return favoriteRhymes
        }
        storageHandler.createKeyIfNoneExists(key: FAVORITE_RHYMES_STORAGE_KEY)
        return ["": RhymeWithFavorites(word: "", rhymes: [])]
    }
    
    /// Check if value is in favorites
    func isFavorite(rhyme: String, forWord: String) -> Bool {
        let currentFavoriteRhymes = getFavoriteRhymes()
        if let rhymeWithFavorites = currentFavoriteRhymes[forWord] {
            return rhymeWithFavorites.rhymes.contains(rhyme)
        }
        return false
    }
    
    /// Mutates rhyme favorites in UserDefaults storage at given key with provided data
    func mutate(type: RhymeStorageMutation, data: String, key: String) throws  {
        var currentFavoriteRhymes = getFavoriteRhymes()
        switch type {
        case .add:
            if var newRhymeWithFavorites = currentFavoriteRhymes[key] {
                newRhymeWithFavorites.rhymes.append(data)
                currentFavoriteRhymes[key] = newRhymeWithFavorites
            } else {
                currentFavoriteRhymes[key] = RhymeWithFavorites(word: key, rhymes: [data])
            }
        case .remove:
            if var newRhymeWithFavorites = currentFavoriteRhymes[key] {
                newRhymeWithFavorites.rhymes = newRhymeWithFavorites.rhymes.filter{!$0.contains(data)}
                currentFavoriteRhymes[key] = newRhymeWithFavorites
            }
        }
        
        try storageHandler.setJSON(value: currentFavoriteRhymes, key: FAVORITE_RHYMES_STORAGE_KEY)
    }
    
    
    /// Get favorites for given word from UserDefaults
    func get(word: String) -> RhymeWithFavorites? {
        let currentRhymes = getFavoriteRhymes()
        if let rhymes = currentRhymes[word]  {
            return rhymes
        }
        return nil
    }
}
