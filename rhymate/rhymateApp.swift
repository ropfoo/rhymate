import SwiftUI

@main
struct rhymateApp: App {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    @State var isRhymeSearchFocused: Bool = false
    var body: some Scene {
        WindowGroup {
            TabView{
                SearchView(favorites: $favorites, isSearchFocused: $isRhymeSearchFocused).tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                FavoritesView(favorites: $favorites).tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            }
        }
    }
}


