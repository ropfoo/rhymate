import Foundation

struct StorageHandler {
    /**
     Checks if key does already exist in UserDefaults
     */
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    /**
     Returns a decodable value from UserDefaults based on the given key if it exists
     */
    func getJSON<T:Decodable>(key: String) -> T?  {
        let storageString = String(describing: UserDefaults.standard.object(forKey: key))
        let storageJSON = Data(storageString.utf8)
        do {
            let storageData  = try JSONDecoder().decode(T.self, from: storageJSON)
            return storageData
        } catch {
           return nil
        }
    }
    
    /**
     Stores an encodable value as JSON in UserDefaults
     */
    func setJSON<T:Encodable>(value: T, key: String) throws {
        let jsonData = try JSONEncoder().encode(value)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        if let json {
            UserDefaults.standard.set(json, forKey: key)
        }
    }
}
