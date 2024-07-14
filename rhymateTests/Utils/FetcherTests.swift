import XCTest
@testable import rhymate

final class FetcherTests: XCTestCase {
    func testGetSuccess() async throws {
        let targetURL = URL(string: "https://www.some-url.com")!
        let json =  #"{"name": "Jack"}"#
        BlockTestProtocolHandler.register(url: targetURL) { (request: URLRequest) -> (response: HTTPURLResponse, data:Data?) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: BlockTestProtocolHandler.httpVersion, headerFields: nil)!
            return (response, Data(json.utf8))
        }
      
        let fetcher = createMockFetcher()
        let result: [String:String]? = try await fetcher.get(targetURL)
        XCTAssertNotNil(result)
    }
    
    func testGetErrorInvalidJson() async throws {
        let targetURL = URL(string: "https://www.some-url.com")!
        let json =  #"{"name": "Jack"}"#
        BlockTestProtocolHandler.register(url: targetURL) { (request: URLRequest) -> (response: HTTPURLResponse, data:Data?) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: BlockTestProtocolHandler.httpVersion, headerFields: nil)!
            return (response, Data(json.utf8))
        }
      
        let fetcher = createMockFetcher()
        let result: [String:String]? = try await fetcher.get(targetURL)
        XCTAssertNil(result)
    }
    
    func testGetErrorHTTPResponse() async throws {
        let targetURL = URL(string: "https://www.some-url.com")!
        let json =  ""
        BlockTestProtocolHandler.register(url: targetURL) { (request: URLRequest) -> (response: HTTPURLResponse, data:Data?) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: BlockTestProtocolHandler.httpVersion, headerFields: nil)!
            return (response, Data(json.utf8))
        }
      
        let fetcher = createMockFetcher()
        let result: [String:String]? = try await fetcher.get(targetURL)
        XCTAssertNil(result)
    }
    
    func createMockFetcher() -> Fetcher {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [
            BlockTestProtocolHandler.self
        ]
        return Fetcher(configuration: config)
    }
    
}
