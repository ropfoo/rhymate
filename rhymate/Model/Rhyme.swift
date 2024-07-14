struct RhymeWithFavorites: JSONable & Identifiable {
    var id: String {word}
    let word: String
    var rhymes: [String]
}

typealias FavoriteRhymes = [String: RhymeWithFavorites]
