import Foundation

struct DatamuseFetcher {
    private let rhymesStorage = RhymesStorage()
    private let fetcher: Fetcher
    let baseUrl = URL(string: "https://api.datamuse.com")!
    
    init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default
    ) {
        self.fetcher = Fetcher(configuration: configuration)
    }
    
    /// Fetch Ryhmes from Datamuse API (https://api.datamuse.com/words?rel_rhy=word))
    func getRhymes(forWord: String) async throws -> DatamuseRhymeResponse {
        let word = forWord.lowercased()
        
        // prefer local store if word already exists in UserDefaults
        if let localResult = rhymesStorage.get(word: word), !localResult.isEmpty {
            return localResult
        }
        
        // fetch data from datamuse
        let url = baseUrl.appendingPathComponent("/words?rel_rhy=\(word)")
        if let rhymesResponse: DatamuseRhymeResponse = try await fetcher.get(url) {
            // store response in UserDefaults
            try rhymesStorage.mutate(.add, data: rhymesResponse, key: word)
            return rhymesResponse
        }
        return []
    }
}
