import XCTest
@testable import rhymate

final class DatamuseFetcherTests: XCTestCase {
    var rhymesStorage: RhymesStorage!

    override func setUpWithError() throws {
        rhymesStorage = RhymesStorage()
        UserDefaults.standard.removeObject(forKey: rhymesStorage.RHYMES_HISTORY_KEY)
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: rhymesStorage.RHYMES_HISTORY_KEY)
    }

    func testGetRhymesFetchSuccess() async throws {
        let fetcher = createMockDatamuseFetcher()
        let url = URL(string: DATAMUSE_API_URL.absoluteString + "/words?rel_rhy=test")!
        let json =  #"[{"word": "best", "score": 123, "numSyllables": 1 }, {"word": "chest", "score": 321, "numSyllables": 1 }]"#
        
        BlockTestProtocolHandler.register(url: url) { (request: URLRequest) -> (response: HTTPURLResponse, data:Data?) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: BlockTestProtocolHandler.httpVersion, headerFields: nil)!
            return (response, Data(json.utf8))
        }
      
        let result = try await fetcher.getRhymes(forWord: "test")
        XCTAssertNotNil(result)
        XCTAssertEqual(result[0].word, "chest")
        XCTAssertEqual(result[0].score, 321)
        XCTAssertEqual(result[0].numSyllables, 1)
        XCTAssertEqual(result[1].word, "best")
        XCTAssertEqual(result[1].score, 123)
        XCTAssertEqual(result[1].numSyllables, 1)
    }
    
    func testGetRhymesLocalResult() async throws {
        let localData = [DatamuseRhyme(word: "west", score: 321, numSyllables: 1)]
        try rhymesStorage.mutate(.add, key: "test", localData)
        
        let fetcher = createMockDatamuseFetcher()
        let url = URL(string: DATAMUSE_API_URL.absoluteString + "/words?rel_rhy=test")!
        let json =  #"[{"word": "best", "score": 123, "numSyllables": 1 }]"#
        
        BlockTestProtocolHandler.register(url: url) { (request: URLRequest) -> (response: HTTPURLResponse, data:Data?) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: BlockTestProtocolHandler.httpVersion, headerFields: nil)!
            return (response, Data(json.utf8))
        }
      
        let result = try await fetcher.getRhymes(forWord: "test")
        XCTAssertNotNil(result)
        XCTAssertEqual(result[0].word, "west")
        XCTAssertEqual(result[0].score, 321)
        XCTAssertEqual(result[0].numSyllables, 1)
    }
    
    func testGetRhymesError() async throws {
        let fetcher = createMockDatamuseFetcher()
        let url = URL(string: DATAMUSE_API_URL.absoluteString + "/words?rel_rhy=test")!
        let json =  #"[{"word": "best", "score": 123, "numSyllables": 1 }]"#
        
        BlockTestProtocolHandler.register(url: url) { (request: URLRequest) -> (response: HTTPURLResponse, data:Data?) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: BlockTestProtocolHandler.httpVersion, headerFields: nil)!
            return (response, Data(json.utf8))
        }
      
        let result = try await fetcher.getRhymes(forWord: "test")
        XCTAssertNotNil(result)
        XCTAssertTrue(result.isEmpty)
    }

    func createMockDatamuseFetcher() -> DatamuseFetcher {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [
            BlockTestProtocolHandler.self
        ]
        return DatamuseFetcher(configuration: config)
    }

}
