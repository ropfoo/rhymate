import Foundation
import SwiftUI

struct RhymesResponse: Decodable {
    let rhymes: [String]
    let word: String
}

struct RhymesFetcher {
    @Binding var rhymes: [String]
    
    private let rhymesStorage = RhymesStorage()
    
    func getRhyme(word: String) {
        var rhymeResponse: RhymesResponse? = nil
        // check local store
        let localResult = rhymesStorage.get(word: word)
        if let localResult {
            print("using local result")
            rhymes = localResult.rhymes
            return
        }
        
        print("fetching data")
        let url = URL(string: "http://localhost:8000/rhyme-word?word=\(word)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // handle the error
                print(error)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    // parse the data
                    rhymeResponse  = try! JSONDecoder().decode(RhymesResponse.self, from: data)
                    rhymes = rhymeResponse?.rhymes ?? []
                    rhymesStorage.store(rhymes: rhymes, key: word)
                } else {
                    // handle the response code
                    print(response.statusCode)
                }
            }
            
        }
        task.resume()
    }
}
