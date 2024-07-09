import Foundation

struct RhymeWithFavorites: JSONable {
    let word: String
    var rhymes: [String]
}

typealias FavoriteRhymes = [String: RhymeWithFavorites]

