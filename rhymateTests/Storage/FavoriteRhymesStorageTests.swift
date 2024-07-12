import XCTest
@testable import rhymate

final class FavoriteRhymesStorageTests: XCTestCase {
    var favoriteRhymesStorage: FavoriteRhymesStorage!
    
    override func setUpWithError() throws {
        favoriteRhymesStorage = FavoriteRhymesStorage()
        UserDefaults.standard.removeObject(forKey: favoriteRhymesStorage.FAVORITE_RHYMES_STORAGE_KEY)
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: favoriteRhymesStorage.FAVORITE_RHYMES_STORAGE_KEY)
    }
    
    private func setupDefaultData() throws {
        // add sample values to store
        try favoriteRhymesStorage.mutate(.add, data: "chest", key: "test")
        try favoriteRhymesStorage.mutate(.add, data: "best", key: "test")
    }
    
    func testIsFavorite() throws {
        try setupDefaultData()
        let shouldBeTrue = favoriteRhymesStorage.isFavorite(rhyme: "best", forWord: "test")
        XCTAssertTrue(shouldBeTrue)
        
        let shouldeBeFalse = favoriteRhymesStorage.isFavorite(rhyme: "west", forWord: "test")
        XCTAssertFalse(shouldeBeFalse)
        
        let shouldBeFalseDefault = favoriteRhymesStorage.isFavorite(rhyme: "west", forWord: "bear")
        XCTAssertFalse(shouldBeFalseDefault )
    }

    func testAdd() throws {
        // should create an entry if none exists
        try favoriteRhymesStorage.mutate(.add, data: "chest", key: "test")
        if let resulWithSingleEntry: FavoriteRhymes = StorageHandler().getJSON(key: favoriteRhymesStorage.FAVORITE_RHYMES_STORAGE_KEY) {
            XCTAssertEqual(resulWithSingleEntry["test"]?.rhymes, ["chest"])
        }
        
        // should add to entry if it exists
        try favoriteRhymesStorage.mutate(.add, data: "best", key: "test")
         if let result: FavoriteRhymes = StorageHandler().getJSON(key: favoriteRhymesStorage.FAVORITE_RHYMES_STORAGE_KEY) {
             XCTAssertEqual(result["test"]?.rhymes, ["chest", "best"])
         }
    }
    
    func testRemove() throws {
        try setupDefaultData()
        
        // should remove string from rhymes array
        try favoriteRhymesStorage.mutate(.remove, data: "chest", key: "test")
        if let result: FavoriteRhymes = StorageHandler().getJSON(key: favoriteRhymesStorage.FAVORITE_RHYMES_STORAGE_KEY) {
            XCTAssertEqual(result["test"]?.rhymes, ["best"])
        }
    }
    
    func testGet() throws {
        let favorites: FavoriteRhymes = ["test": RhymeWithFavorites(word: "test", rhymes: ["best","west"])]
        
        try StorageHandler().setJSON(value: favorites, key: favoriteRhymesStorage.FAVORITE_RHYMES_STORAGE_KEY)
        
        if let result = favoriteRhymesStorage.get(word: "test") {
            XCTAssertEqual(result.word, "test")
            XCTAssertEqual(result.rhymes, ["best", "west"])
        }
        
        UserDefaults.standard.removeObject(forKey: favoriteRhymesStorage.FAVORITE_RHYMES_STORAGE_KEY)
        let resultNil = favoriteRhymesStorage.get(word: "test")
        XCTAssertNil(resultNil)
    }
}
