import XCTest
@testable import rhymate

final class RhymesStorageTests: XCTestCase {
    var rhymesStorage: RhymesStorage!
    
    let testWord = "test"
    let testRhymes: DatamuseRhymeResponse = [
        DatamuseRhyme(word: "manifest", score: 2995, numSyllables: 3),
        DatamuseRhyme(word: "best", score: 2743, numSyllables: 1),
        DatamuseRhyme(word: "rest", score: 2366, numSyllables: 1),
    ]
    
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
            for (index, rhyme) in testRhymes.enumerated() {
                XCTAssertEqual(rhyme.word, result[testWord]![index].word)
                XCTAssertEqual(rhyme.score, result[testWord]![index].score)
                XCTAssertEqual(rhyme.numSyllables, result[testWord]![index].numSyllables)
            }
        }
    }
    
    func testGet() throws {
        let history: RhymesHistory = [testWord: testRhymes]
        
        try StorageHandler().setJSON(value: history, key: rhymesStorage.RHYMES_HISTORY_KEY)
        
        if let result = rhymesStorage.get(word: testWord) {
            for (index, rhyme) in testRhymes.enumerated() {
                XCTAssertEqual(rhyme.word, result[index].word)
                XCTAssertEqual(rhyme.score, result[index].score)
                XCTAssertEqual(rhyme.numSyllables, result[index].numSyllables)
            }
        }
        
        UserDefaults.standard.removeObject(forKey: rhymesStorage.RHYMES_HISTORY_KEY)
        let resultNil = rhymesStorage.get(word: testWord)
        XCTAssertNil(resultNil)

        let resultEmpty = rhymesStorage.get(word: "someKey")
        XCTAssertNil(resultEmpty)

    }
    
}
