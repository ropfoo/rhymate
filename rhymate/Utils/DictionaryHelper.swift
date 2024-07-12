import Foundation

struct DictionaryHelper {
    
    func mutateFavorite(
        _ favorites: FavoriteRhymes,
        _ type: Mutation,
        data: String,
        key: String
    ) -> FavoriteRhymes {
        switch type {
        case .add: return addFavorite(favorites, data: data, toKey: key)
        case .remove: return removeFavorite(favorites, data: data, fromKey: key)
        }
    }
    
    private func addFavorite(
        _ favorites: FavoriteRhymes,
        data: String,
        toKey: String
    ) -> FavoriteRhymes {
        var currentFavorites = favorites
        if var newEntry = favorites[toKey] {
            newEntry.rhymes.append(data)
            currentFavorites[toKey] = newEntry
        } else {
            currentFavorites[toKey] = RhymeWithFavorites(word: toKey, rhymes: [data])
        }
        return currentFavorites
    }
    
    private func removeFavorite(
        _ favorites: FavoriteRhymes,
        data: String,
        fromKey: String
    ) -> FavoriteRhymes {
        var currentFavorites = favorites
        if var newEntry = currentFavorites[fromKey] {
            newEntry.rhymes = newEntry.rhymes.filter{!$0.contains(data)}
            currentFavorites[fromKey] = newEntry
        }
        return currentFavorites
    }
    
}
