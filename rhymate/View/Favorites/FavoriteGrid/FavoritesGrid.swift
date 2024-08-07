import SwiftUI

struct FavoritesGrid: View {
    @Binding var favorites: FavoriteRhymes
    let onItemTap: (_ rhymeWithFavorites: RhymeWithFavorites) -> Void
    var body: some View {
        LazyVGrid(
            columns:[GridItem(
                .adaptive(minimum: 400)
            )],
            spacing: 10
        ){
            // iterate over each stored favorite
            ForEach(Array($favorites.wrappedValue.keys), id: \.self) {key in
                // check if favorite has rhymes
                if !(favorites[key]?.rhymes.isEmpty ?? false) {
                 FavoritesGridItem(
                    rhymes: $favorites.wrappedValue[key]?.rhymes ?? [],
                    word: key,
                    onTap: onItemTap
                 )
                }
            }
        }
        .padding(30)
    }
}

struct PreviewFavoritesGrid: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View{
        FavoritesGrid(favorites: $favorites, onItemTap: { rhymeWithFavorite in print("")})
    }
}

#Preview {
    PreviewFavoritesGrid()
}


