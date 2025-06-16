import Foundation
import SwiftUI

struct RhymesGrid: View {
    var rhymes: [RhymeItem]
    @Binding var favorites: FavoriteRhymes
    
    @State private var sheetDetail: RhymeItem?
    var word: String { rhymes.first?.word ?? "" }
    
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
                .adaptive(minimum: 400)
            )],
            spacing: 15
        ){
            ForEach(rhymes) { item in
                RhymeItemView(
                    onPress: { sheetDetail = item },
                    rhyme: item.rhyme,
                    word: word,
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
                toggleFavorite: { toggleFavorite(item.rhyme) },
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
    @State var rhymes: [RhymeItem] = [
        RhymeItem(word: "test", rhyme: "west"),
        RhymeItem(word: "test", rhyme: "best"),
        RhymeItem(word: "test", rhyme: "chest"),
    ]
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View {
        RhymesGrid(rhymes: rhymes, favorites: $favorites)
    }
}

#Preview {
    PreviewRhymesGrid()
}
