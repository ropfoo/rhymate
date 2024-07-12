import Foundation
import SwiftUI

struct FavoriteRhymesStorage: RhymeStorage {
    let FAVORITE_RHYMES_STORAGE_KEY = "favoriteRhymes"
    private let storageHandler = StorageHandler()
    private let helper = DictionaryHelper()
    
    let emptyDefault: FavoriteRhymes = ["": RhymeWithFavorites(word: "", rhymes: [])]
    
    init() {
        storageHandler.createKeyIfNoneExists(key: FAVORITE_RHYMES_STORAGE_KEY)
    }
    
    /// Get all favorite rhymes from UserDefaults storage
    func getFavoriteRhymes() -> FavoriteRhymes  {
        if let favoriteRhymes: FavoriteRhymes = storageHandler.getJSON(key: FAVORITE_RHYMES_STORAGE_KEY) {
            return favoriteRhymes
        }
        storageHandler.createKeyIfNoneExists(key: FAVORITE_RHYMES_STORAGE_KEY)
        return emptyDefault
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
    func mutate(_ type: Mutation, data: String, key: String) throws  {
        var currentFavorites = getFavoriteRhymes()
        currentFavorites = helper.mutateFavorite(currentFavorites, type, data: data, key: key)
        try storageHandler.setJSON(value: currentFavorites, key: FAVORITE_RHYMES_STORAGE_KEY)
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
