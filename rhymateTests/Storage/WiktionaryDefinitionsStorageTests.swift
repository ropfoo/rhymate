import XCTest
@testable import rhymate

final class WiktionaryDefinitionsStorageTests: XCTestCase {
    var wiktionaryDefinitionsStorage: WiktionaryDefinitionsStorage!
    
    override func setUpWithError() throws {
        wiktionaryDefinitionsStorage = WiktionaryDefinitionsStorage()
        UserDefaults.standard.removeObject(forKey: wiktionaryDefinitionsStorage.WIKTIONARY_DEFINITIONS_KEY)
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: wiktionaryDefinitionsStorage.WIKTIONARY_DEFINITIONS_KEY)
    }

    func testRemoveAndAdd() throws {
        // it should add data to the key "best"
        try wiktionaryDefinitionsStorage.mutate(.add, key: "best", wiktionaryMockBestResult)
        let result: WiktionaryHistory = StorageHandler().getJSON(key: wiktionaryDefinitionsStorage.WIKTIONARY_DEFINITIONS_KEY)!
        XCTAssertEqual(result["best"], wiktionaryMockBestResult)
        
        // it should remove the key "best"
        try wiktionaryDefinitionsStorage.mutate(.remove, key: "best")
        let resultRemove: WiktionaryHistory = StorageHandler().getJSON(key: wiktionaryDefinitionsStorage.WIKTIONARY_DEFINITIONS_KEY)!
        XCTAssertNil(resultRemove["best"])

    }
}
