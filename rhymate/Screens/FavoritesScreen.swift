import Foundation
import SwiftUI



struct FavoritesScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var favorites: FavoriteRhymes
    
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
                FavoritesGrid(favorites: $favorites)
            }.padding()
            .navigationTitle("favorites")
        }
    }
}

struct PreviewFavoritesView: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View {
        FavoritesScreen(favorites: $favorites)
    }
}

#Preview {
    PreviewFavoritesView()
}



