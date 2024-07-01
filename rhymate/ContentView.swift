//
//  ContentView.swift
//  rhymate
//
//  Created by Robert Pasdziernik on 01.07.24.
//

import SwiftUI

struct ContentView: View {
    @State var rhymes: [String] = []
    var body: some View {
        VStack(alignment: .leading){
            SearchFormView(rhymes: $rhymes)
            ScrollView{
                VStack(alignment: .leading){
                    ForEach($rhymes,id: \.self) { rhyme in
                        Text("\(rhyme.wrappedValue)")
                    }
                    Spacer()
                }
                .padding()
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
