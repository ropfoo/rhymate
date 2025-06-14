import Foundation
import SwiftUI



struct FavoritesView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var favorites: FavoriteRhymes
    @State private var sheet: RhymeWithFavorites?
    @State private var sheetDetail: RhymeItem?
    
    private func hasFavoritesWithRhymes() -> Bool {
        var hasFavorite: Bool = false
        for favorite in favorites {
            if favorite.value.rhymes.isEmpty {
                continue
            } else {
                hasFavorite = true
            }
        }
        return hasFavorite
    }
    
    var body :some View {
        NavigationStack{
            // if user has no stored favortes, display a default message
            if !hasFavoritesWithRhymes() {
                VStack(alignment: .center){
                    Spacer()
                    Text("fallbackFavoritesTitle")
                        .font(.system(.headline))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 10)
                    Text("fallbackFavoritesText")
                        .padding(.bottom, 10)
                    Image(systemName: "heart.fill").foregroundColor(.accentColor)
                }.padding(.horizontal, 50)
            }
            
            ScrollView{
                FavoritesGrid(
                    favorites: $favorites,
                    onItemTap: { rhymeWithFavorites in
                        sheet = rhymeWithFavorites
                    }
                )
            }
            .sheet(
                item: $sheet,
                onDismiss: { sheet = nil }
            ){ detail in
                FavoritesDetail(
                    word: detail.word,
                    favorites: $favorites,
                    onItemPress: {
                        rhyme in
                        sheetDetail = RhymeItem(
                            id: detail.word,
                            word: detail.word,
                            rhyme: rhyme
                        )
                    },
                    onDismiss: { sheet = nil }
                )
                .sheet(
                    item: $sheetDetail,
                    onDismiss: { sheetDetail = nil }
                ){ rhymeItem in
                    FavoritesItemView(
                        .detail,
                        word: rhymeItem.word,
                        rhyme: rhymeItem.rhyme,
                        favorites: $favorites,
                        isFavorite: favorites[rhymeItem.word]?.rhymes.contains(rhymeItem.rhyme) ?? false,
                        onDismiss: { sheetDetail = nil }
                    )
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
                }
                .presentationDetents([.large])
            }
            .frame(
                minHeight: 0,
                maxHeight: .infinity
            )
            .navigationTitle("favorites")
        }
    }
}

struct PreviewFavoritesView: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View {
        FavoritesView(favorites: $favorites)
    }
}

#Preview {
    PreviewFavoritesView()
}



