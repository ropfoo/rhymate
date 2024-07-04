import Foundation

struct StorageHandler {
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func get<T:Decodable>(key: String) -> T?  {
        let storageString = UserDefaults.standard.object(forKey: key) as! String?
        if let storageString  {
            let storageJSON = Data(storageString.utf8)
            let storageData  = try! JSONDecoder().decode(T.self, from: storageJSON)
            return storageData
        }
        return nil
    }
    
    func set<T:Encodable>(value: T, key: String) {
        let jsonData = try! JSONEncoder().encode(value)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        if let json {
            UserDefaults.standard.set(json, forKey: key)
        }
    }
}
