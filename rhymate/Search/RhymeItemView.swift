//
//  ResultItem.swift
//  rhymate
//
//  Created by Robert Pasdziernik on 01.07.24.
//

import Foundation
import SwiftUI

struct RhymeItemView: View {
    @Binding var rhyme: String
    var body:some View {
        HStack{
            Text("\($rhyme.wrappedValue)")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .padding(10)
                .opacity(0.75)
                .frame(maxWidth: .infinity)
        }
        .background(.gray.opacity(0.15))
        .cornerRadius(10)
    }
}

#Preview {
    SearchView()
}
