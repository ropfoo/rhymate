//
//  SearchForm.swift
//  rhymate
//
//  Created by Robert Pasdziernik on 01.07.24.
//

import SwiftUI
import Foundation



struct SearchFormView: View {
    @Binding var rhymes: [String]
    @State private var word: String = ""
    
    func submit() {
       print("submitting: \(word)")
       RhymesFetcher(rhymes:$rhymes).getRhyme(word:word)
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

