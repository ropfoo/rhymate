//
//  Fetcher.swift
//  rhymate
//
//  Created by Robert Pasdziernik on 02.07.24.
//

import Foundation
import SwiftUI


struct RhymesResponse: Decodable {
    let rhymes: [String]
    let word: String
}

struct RhymesFetcher {
    @Binding var rhymes: [String]

    func getRhyme(word: String) {
        var rhymeResponse: RhymesResponse? = nil
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

                    // store result in local storage
                    let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [])
                    let prettyPrintedData = try! JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])

                    if let jsonString = String(data: prettyPrintedData, encoding: .utf8){
                        UserDefaults.standard.set(jsonString, forKey: word)
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
