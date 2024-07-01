//
//  RhymesGrid.swift
//  rhymate
//
//  Created by Robert Pasdziernik on 02.07.24.
//

import Foundation
import SwiftUI

struct RhymesGrid: View {
    @Binding var rhymes: [String]
    
    var body: some View {
        LazyVGrid(columns:  [GridItem(.flexible()), GridItem(.flexible())]){
            ForEach($rhymes,id: \.self) { rhyme in
                RhymeItemView(rhyme:rhyme)
            }
        }
        .padding(.horizontal,25)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )}
}
