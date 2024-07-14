import Foundation

struct DatamuseFetcher {
    private let rhymesStorage = RhymesStorage()
    private let fetcher: Fetcher
    let baseUrlWords = DATAMUSE_API_URL.appendingPathComponent("/words")
    
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
        var urlComponents = URLComponents(string: baseUrlWords.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "rel_rhy", value: word),
        ]
        let url = urlComponents.url!
        if let rhymesResponse: DatamuseRhymeResponse = try await fetcher.get(url) {
            let sortedRhymeResponse = rhymesResponse.sorted{
                $0.score ?? 0 > $1.score ?? 0
            }
            // store response in UserDefaults
            try rhymesStorage.mutate(.add, data: sortedRhymeResponse, key: word)
            return sortedRhymeResponse
        }
        return []
    }
}
