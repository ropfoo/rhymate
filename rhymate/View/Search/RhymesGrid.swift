import Foundation
import SwiftUI

struct RhymesGrid: View {
    @Binding var rhymes: DatamuseRhymeResponse
    @Binding var word: String
    @Binding var favorites: FavoriteRhymes
    @State private var sheetDetail: RhymeItem?
    
    func toggleFavorite(_ rhyme: String) {
        do {
            try FavoriteRhymesStorage().mutate(
                isFavorite(rhyme) ? .remove : .add,
                key: word,
                rhyme
            )
        } catch {
            print(error)
        }
        favorites = DictionaryHelper().mutateFavorite(
            favorites,
            isFavorite(rhyme) ? .remove : .add,
            data: rhyme,
            key: word
        )
    }
    
    func isFavorite(_ rhyme: String) -> Bool {
        return favorites[word]?.rhymes.contains(rhyme) ?? false
    }
    
    var body: some View {
        LazyVGrid(
            columns:[GridItem(
                .adaptive(minimum: 300)
            )],
            spacing: 15
        ){
            ForEach($rhymes) { rhyme in
                let item = RhymeItem(
                    id: rhyme.word.wrappedValue,
                    word: word,
                    rhyme: rhyme.word.wrappedValue
                )
                
                RhymeItemView(
                    onPress: { sheetDetail=item },
                    rhyme:rhyme.word.wrappedValue,
                    word: $word.wrappedValue,
                    isFavorite: isFavorite(item.rhyme),
                    toggleFavorite: { toggleFavorite(item.rhyme) },
                )
            }
        }
        .sheet(
            item: $sheetDetail,
            onDismiss: {sheetDetail = nil}
        )
        { item in
            FavoritesItemView(
                .detail,
                word: word,
                rhyme: item.rhyme,
                favorites: $favorites,
                isFavorite: isFavorite(item.rhyme),
                toggFavorite: { toggleFavorite(item.rhyme) },
                onDismiss: {sheetDetail = nil}
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
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
