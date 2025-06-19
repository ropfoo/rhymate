import Foundation
import SwiftUI

struct FavoriteRhymesStorage: RhymeStorage {
    let FAVORITE_RHYMES_STORAGE_KEY = "favoriteRhymes"
    private let storageHandler = StorageHandler()
    private let organizer = FavoritesOrganizer()
    
    let emptyDefault: FavoriteRhymes = ["": RhymeWithFavorites(word: "", rhymes: [])]
    
    init() {
        storageHandler.createKeyIfNoneExists(key: FAVORITE_RHYMES_STORAGE_KEY)
    }
    
    /// Get all favorite rhymes from UserDefaults storage
    func getFavoriteRhymes() -> FavoriteRhymes  {
        if let favoriteRhymes: FavoriteRhymes = storageHandler.getJSON(key: FAVORITE_RHYMES_STORAGE_KEY) {
            return organizer.mergeSimilar(favoriteRhymes)
        }
        storageHandler.createKeyIfNoneExists(key: FAVORITE_RHYMES_STORAGE_KEY)
        return emptyDefault
    }
    
    /// Check if value is in favorites
    func isFavorite(rhyme: String, forWord: String) -> Bool {
        let currentFavoriteRhymes = getFavoriteRhymes()
        let word = Formatter.normalize(forWord)
        if let rhymeWithFavorites = currentFavoriteRhymes[word] {
            return rhymeWithFavorites.rhymes.contains(rhyme)
        }
        return false
    }

    /// Mutates rhyme favorites in UserDefaults storage at given key with provided data
    func mutate(_ type: Mutation, key: String, _ data: String?) throws  {
        let data = data ?? ""
        var currentFavorites = getFavoriteRhymes()
        let word = Formatter.normalize(key)
        currentFavorites = organizer.mutate(currentFavorites, type, data: data, key: word)
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
