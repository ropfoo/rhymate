import SwiftUI

@main
struct rhymateApp: App {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    
    var body: some Scene {
        WindowGroup {
            TabView{
                SearchView(favorites: $favorites).tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                FavoritesView(favorites: $favorites).tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            }
        }
    }
}


