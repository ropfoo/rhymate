import Foundation
import SwiftUI

struct RhymesGrid: View {
    @Binding var rhymes: DatamuseRhymeResponse
    @Binding var word: String
    @Binding var favorites: FavoriteRhymes

    var body: some View {
        LazyVGrid(columns:  [GridItem(.flexible()), GridItem(.flexible())], spacing: 10){
            ForEach($rhymes) { rhyme in
                RhymeItemView(rhyme:rhyme.word.wrappedValue, word: $word.wrappedValue, favorites: $favorites)
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

struct PreviewRhymesGrid: View {
    @State var rhymes: DatamuseRhymeResponse = [
        DatamuseRhyme(word: "west", score: 10, numSyllables: 2),
        DatamuseRhyme(word: "best", score: 10, numSyllables: 2),
        DatamuseRhyme(word: "chest", score: 10, numSyllables: 2),
    ]
    @State var word: String = "test"
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View {
        RhymesGrid(rhymes: $rhymes, word: $word, favorites:$favorites)

    }
}

#Preview {
    PreviewRhymesGrid()
}
