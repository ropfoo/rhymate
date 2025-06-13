import Foundation

struct StorageHandler {
    
    /// Checks if key does already exist in
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    /// Creates a key with an initial value if the key does not exist yet
    func createKeyIfNoneExists(key: String, initialValue: String = "{}") {
        if !isKeyPresentInUserDefaults(key: key) {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
    }
    
    /// Returns a decodable value from UserDefaults based on the given key if it exists
    func getJSON<T:Decodable>(key: String) -> T?  {
        let storageString =  UserDefaults.standard.object(forKey: key)
        if let storageString = storageString as? String {
            let storageJSON = Data(storageString.utf8)
            do {
                let storageData  = try JSONDecoder().decode(T.self, from: storageJSON)
                return storageData
            } catch let error as DecodingError {
                switch error {
                case .typeMismatch:
                    print("Type mismatch when decoding. Removing key \(key) from UserDefaults.")
                    UserDefaults.standard.removeObject(forKey: key)
                default:
                    print("Decoding error: \(error). Removing key \(key) from UserDefaults.")
                    UserDefaults.standard.removeObject(forKey: key)
                }
                return nil
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    /// Stores an encodable value as JSON in UserDefaults
    func setJSON<T:Encodable>(value: T, key: String) throws {
        let jsonData = try JSONEncoder().encode(value)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        if let json {
            UserDefaults.standard.set(json, forKey: key)
        }
    }
}
