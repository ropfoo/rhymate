//
//  SearchForm.swift
//  rhymate
//
//  Created by Robert Pasdziernik on 01.07.24.
//

import SwiftUI
import Foundation

struct RhymesResponse: Decodable {
    let rhymes: [String]
    let word: String
}

struct SearchFormView: View {
    @Binding var rhymes: [String]
    @State private var word: String = ""
    
    func submit() {
        let url = URL(string: "http://localhost:8000/rhyme-word?word=\(word)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // handle the error
                print(error)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    // parse the data
                    let rhymesResponse: RhymesResponse = try! JSONDecoder().decode(RhymesResponse.self, from: data)
                    print(rhymesResponse)
                    rhymes = rhymesResponse.rhymes
                } else {
                    // handle the response code
                    print(response.statusCode)
                }
            }
        }
        task.resume()
        print("submitting: \(word)")
    }
    
    
    var body: some View {
        Form{
            HStack{
                TextField("Search rhyme...", text:$word)
                Button(action:submit){
                    Text("Go")
                }
            }
        }
        .onSubmit{
            submit()
        }.frame(maxHeight:100, alignment: .top)
    }
}

