import XCTest
@testable import rhymate

final class StorageHandlerTests: XCTestCase {
    let testKey = "testKey"
    var storageHandler: StorageHandler!
    
    struct TestData: Encodable & Decodable {
        let name: String
        let age: Int
    }
    
    override func setUpWithError() throws {
        UserDefaults.standard.removeObject(forKey: testKey)
        storageHandler = StorageHandler()
    }
    
    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: testKey)
    }
    
    func testIsKeyPresentInUserDefaults() {
        // should be false with unset key
        let isKeyPresentFalse = storageHandler.isKeyPresentInUserDefaults(key: testKey)
        XCTAssertFalse(isKeyPresentFalse)
        
        // should be true with set key
        UserDefaults.standard.setValue("", forKey: testKey)
        let isKeyPresentTrue = storageHandler.isKeyPresentInUserDefaults(key: testKey)
        XCTAssertTrue(isKeyPresentTrue)
    }
    
    func testSetJSON() throws {
        try storageHandler.setJSON(value: TestData(name: "Peter", age: 20), key: testKey)
        
        if let testData: TestData = storageHandler.getJSON(key: testKey) {
            XCTAssertEqual(testData.name, "Peter")
            XCTAssertEqual(testData.age, 20)
        }
    }
    
    func testGetJSON() {
        UserDefaults.standard.setValue("{\"name\":\"Bob\", age: 21}", forKey: testKey)
        if let testData: TestData = storageHandler.getJSON(key: testKey) {
            XCTAssertEqual(testData.name, "Bob")
            XCTAssertEqual(testData.age, 21)
        }
    }
}
