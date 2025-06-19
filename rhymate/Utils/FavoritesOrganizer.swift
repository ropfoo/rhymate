import Foundation

struct FavoritesOrganizer{
    
    func mutate(
        _ favorites: FavoriteRhymes,
        _ type: Mutation,
        data: String,
        key: String
    ) -> FavoriteRhymes {
        switch type {
        case .add: return add(favorites, data: data, toKey: key)
        case .remove: return remove(favorites, data: data, fromKey: key)
        }
    }
    
    private func add(
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
    
    private func remove(
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
    
    func mergeSimilar(_ favorites: FavoriteRhymes) -> FavoriteRhymes {
        // Group keys by their lowercase representation
        var groupedKeys: [String: [String]] = [:]
        for key in favorites.keys {
            let normalized = Formatter.normalize(key)
            groupedKeys[normalized, default: []].append(key)
        }

        // Create a new dictionary to hold the merged result
        var merged: FavoriteRhymes = [:]

        for (normalizedKey, similarKeys) in groupedKeys {
            var combinedRhymes = Set<String>()

            for key in similarKeys {
                combinedRhymes.formUnion(favorites[key]?.rhymes ?? [])
            }

            let representativeKey = similarKeys.first ?? normalizedKey

            merged[representativeKey] = RhymeWithFavorites(
                word: representativeKey,
                rhymes: Array(combinedRhymes).sorted()
            )
        }

        return merged
    }
    
}
