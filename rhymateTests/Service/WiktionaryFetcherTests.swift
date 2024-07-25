import XCTest
@testable import rhymate

final class WiktionaryFetcherTests: XCTestCase {

    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
