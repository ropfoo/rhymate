//
//  ContentView.swift
//  rhymate
//
//  Created by Robert Pasdziernik on 01.07.24.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @State var rhymes: [String] = ["sdsdaSAs","ddadadasdasdasd","asdsasd", "dadasdasdad"]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                RhymesGrid(rhymes:$rhymes)
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Spacer()
                }
            }
            SearchFormView(rhymes: $rhymes)
        }
    }
}

#Preview {
    SearchView()
}
