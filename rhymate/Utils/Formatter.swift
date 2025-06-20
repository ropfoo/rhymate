struct Formatter {
    func normalize(_ value: String) -> String {
        return value
            .lowercased()
            .trimmingCharacters(in: .punctuationCharacters)
            .trimmingCharacters(in: .symbols)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isWordSimilar(_ word1: String, _ word2: String) -> Bool {
        return normalize(word1) == normalize(word2)
    }
}
