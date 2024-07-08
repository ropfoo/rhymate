import Foundation

struct DatamuseRhyme: Decodable & Encodable & Identifiable {
    var word: String
    let score: Int
    let numSyllables: Int
    var id: String { word }
}

typealias DatamuseRhymeResponse = [DatamuseRhyme]
