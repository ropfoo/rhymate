import SwiftUI

struct RootScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    @State var isRhymeSearchFocused: Bool = false
    
    var body: some View {
//            TabView{
//                NavigationStack {
//                    SearchScreen(
//                        favorites: $favorites,
//                        isSearchFocused: $isRhymeSearchFocused
//                    )
//                }.tabItem {
//                    Label("Search", systemImage: "magnifyingglass")
//                }
//    
//                FavoritesScreen(favorites: $favorites).tabItem {
//                    Label("Favorites", systemImage: "heart")
//                }
//            }
        if horizontalSizeClass == .compact {
            TabView{
                NavigationStack {
                    SearchScreen(
                        favorites: $favorites,
                        isSearchFocused: $isRhymeSearchFocused
                    )
                }.tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
                FavoritesScreen(favorites: $favorites).tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            }
        }
        else {
            NavigationSplitView {
                NavigationStack {
                    SearchScreen(
                        favorites: $favorites,
                        isSearchFocused: $isRhymeSearchFocused
                    ).navigationSplitViewStyle(.balanced)
                }

            }
            detail: {
                NavigationStack {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    RootScreen()
}
