struct RhymeWithFavorites: JSONable & Identifiable {
    var id: String {word}
    let word: String
    var rhymes: [String]
}

struct RhymeItem: Identifiable {
    var id: String{word + rhyme}
    var word: String
    var rhyme: String
}

typealias FavoriteRhymes = [String: RhymeWithFavorites]
