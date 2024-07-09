import Foundation
import SwiftUI

struct RhymesFetcher {
    @Binding var rhymes: DatamuseRhymeResponse
    
    private let rhymesStorage = RhymesStorage()
    
    func getRhyme(word: String) {
        var rhymeResponse: DatamuseRhymeResponse? = nil
        // check local store
        if let localResult = rhymesStorage.get(word: word) {
            print("using local result")
            rhymes = localResult
            return
        }
        
        print("fetching data")
        // let url = URL(string: "http://localhost:8000/rhyme-word?word=\(word)")!
        let url = URL(string: "http://localhost:8000/rhymes")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // handle the error
                print(error)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    // parse the data
                    rhymeResponse  = try! JSONDecoder().decode(DatamuseRhymeResponse.self, from: data)
                    rhymes = rhymeResponse ?? []
                    do {
                        try rhymesStorage.mutate(type: .add, data: rhymes, key: word)
                    } catch {
                        print("Error storing rhymes: \(error)")
                    }
                } else {
                    // handle the response code
                    print(response.statusCode)
                }
            }
            
        }
        task.resume()
    }
}
