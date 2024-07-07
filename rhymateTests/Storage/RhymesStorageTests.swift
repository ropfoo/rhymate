import XCTest
@testable import rhymate

final class RhymesStorageTests: XCTestCase {
    var rhymesStorage: RhymesStorage!
    
    let testWord = "test"
    let testRhymes = ["west", "best", "chest"]
    
    override func setUpWithError() throws {
        rhymesStorage = RhymesStorage()
        UserDefaults.standard.removeObject(forKey: rhymesStorage.RHYMES_HISTORY_KEY)
    }
    
    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: rhymesStorage.RHYMES_HISTORY_KEY)
    }
    
    func testStore() throws {
        try rhymesStorage.store(rhymes: testRhymes, key: testWord)
        
        if let result: RhymesHistory = StorageHandler().getJSON(key: rhymesStorage.RHYMES_HISTORY_KEY) {
            XCTAssertEqual(testRhymes, result[testWord])
        }
    }
    
    func testGet() throws {
        let history: RhymesHistory = [testWord: testRhymes]
        
        try StorageHandler().setJSON(value: history, key: rhymesStorage.RHYMES_HISTORY_KEY)
        
        if let result = rhymesStorage.get(word: testWord) {
            let expected: RhymesResponse = RhymesResponse(rhymes: testRhymes, word: testWord)
            XCTAssertEqual(expected.rhymes, result.rhymes)
            XCTAssertEqual(expected.word, result.word)
        }
        
        UserDefaults.standard.removeObject(forKey: rhymesStorage.RHYMES_HISTORY_KEY)
        let resultNil = rhymesStorage.get(word: testWord)
        XCTAssertEqual(resultNil?.word, nil)
        
        let resultEmpty = rhymesStorage.get(word: "someKey")
        XCTAssertEqual(resultEmpty?.word, nil)
    }
    
}
