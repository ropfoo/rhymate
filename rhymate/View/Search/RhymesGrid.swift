import Foundation
import SwiftUI

struct RhymesGrid: View {
    @Binding var rhymes: DatamuseRhymeResponse
    @Binding var word: String
    @Binding var favorites: FavoriteRhymes

    var body: some View {
        LazyVGrid(columns:  [GridItem(.flexible()), GridItem(.flexible())], spacing: 10){
            ForEach($rhymes) { rhyme in
                RhymeItemView(rhyme:rhyme.word, word: $word, favorites: $favorites)
            }
            
        }
        .padding(.horizontal, 20)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )}
}

//#Preview {
//    SearchView()
//}
