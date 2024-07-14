struct DatamuseRhyme: JSONable & Identifiable {
    var word: String
    let score: Int?
    let numSyllables: Int
    var id: String { word }
}

typealias DatamuseRhymeResponse = [DatamuseRhyme]
