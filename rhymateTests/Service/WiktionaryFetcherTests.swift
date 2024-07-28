import XCTest
@testable import rhymate

final class WiktionaryFetcherTests: XCTestCase {
    var wiktionaryDefinitionsStorage: WiktionaryDefinitionsStorage!
    
    override func setUpWithError() throws {
        wiktionaryDefinitionsStorage = WiktionaryDefinitionsStorage()
    }
    
    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: wiktionaryDefinitionsStorage.WIKTIONARY_DEFINITIONS_KEY)
    }
    
    func testGetWiktionaryDefinitionsSuccess() async throws {
        let fetcher = createMockWiktionaryFetcher()
        let url = URL(string: WIKTIONARY_API_URL.absoluteString + "/definition/best")!
        let json = wiktionaryMockBest
        
        BlockTestProtocolHandler.register(url: url) { (request: URLRequest) -> (response: HTTPURLResponse, data:Data?) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: BlockTestProtocolHandler.httpVersion, headerFields: nil)!
            return (response, Data(json.utf8))
        }
        
        let result = try await fetcher.getDefinitions(forWord: "best")
        XCTAssertEqual(result, wiktionaryMockBestResult)
    }
    
    func testGetWiktionaryDefinitionsLocalResultSuccess() async throws {
        let localData = wiktionaryMockBestResult
        try wiktionaryDefinitionsStorage.mutate(.add, key: "best", localData)
        
        let fetcher = createMockWiktionaryFetcher()
        let url = URL(string: WIKTIONARY_API_URL.absoluteString + "/definition/best")!
        let json = wiktionaryMockBest
        
        BlockTestProtocolHandler.register(url: url) { (request: URLRequest) -> (response: HTTPURLResponse, data:Data?) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: BlockTestProtocolHandler.httpVersion, headerFields: nil)!
            return (response, Data(json.utf8))
        }
        
        let result = try await fetcher.getDefinitions(forWord: "best")
        XCTAssertEqual(result, wiktionaryMockBestResult)
    }
    
    func testGetWiktionaryDefinitionsError() async throws {
        let fetcher = createMockWiktionaryFetcher()
        let url = URL(string: WIKTIONARY_API_URL.absoluteString + "/definition/best")!
        let json = wiktionaryMockBest
        
        BlockTestProtocolHandler.register(url: url) { (request: URLRequest) -> (response: HTTPURLResponse, data:Data?) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: BlockTestProtocolHandler.httpVersion, headerFields: nil)!
            return (response, Data(json.utf8))
        }
        
        let result = try await fetcher.getDefinitions(forWord: "best")
        XCTAssertEqual(result, [])
    }
    
    func createMockWiktionaryFetcher() -> WiktionaryFetcher {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [
            BlockTestProtocolHandler.self
        ]
        return WiktionaryFetcher(configuration: config)
    }
}
