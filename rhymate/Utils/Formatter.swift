struct Formatter {
    func formatInput(_ value: String) -> String {
        return value
            .lowercased()
            .trimmingCharacters(in: .punctuationCharacters)
            .trimmingCharacters(in: .symbols)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
