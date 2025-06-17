import SwiftUI

struct FavoritesGrid: View {
    @Binding var favorites: FavoriteRhymes
    var body: some View {
        LazyVGrid(
            columns:[GridItem(
                .adaptive(minimum: 400)
            )],
            spacing: 4
        ){
            ForEach(Array($favorites.wrappedValue.keys), id: \.self) {key in
                // check if favorite has rhymes
                if !(favorites[key]?.rhymes.isEmpty ?? false) {
                    NavigationLink(
                        destination: FavoritesDetail(word: key, favorites: $favorites),
                        label: {
                        FavoritesGridItem(
                            rhymes: $favorites.wrappedValue[key]?.rhymes ?? [],
                            word: key,
                        )
                    })
                }
            }
        }
    }
}

struct PreviewFavoritesGrid: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View{
        FavoritesGrid(favorites: $favorites)
    }
}

#Preview {
    PreviewFavoritesGrid()
}


