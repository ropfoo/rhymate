import SwiftUI

struct RootScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    @State var isRhymeSearchFocused: Bool = false
    
    @State var text: String = "Hello word, there are a fiew more words here so yeah i guess"
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabView{
                LyricAssistentView(text: $text, favorites: $favorites).tabItem {
                    Label("Search", systemImage: "magnifyingglass")
//                    Label("Compose", systemImage: "square.and.pencil")
                }
//                NavigationStack {
//                    SearchScreen(
//                        favorites: $favorites,
//                        isSearchFocused: $isRhymeSearchFocused
//                    )
//                }.tabItem {
//                    Label("Search", systemImage: "magnifyingglass")
//                }
                
                FavoritesScreen(favorites: $favorites).tabItem {
                    Label("Favorites", systemImage: "heart")
                }

            }
        }
        else {
            NavigationSplitView {
                NavigationStack {
                    List {
                        NavigationLink(
                            destination: SearchScreen(
                                favorites: $favorites,
                                isSearchFocused: $isRhymeSearchFocused
                            ),
                            label: { Label("Search", systemImage: "magnifyingglass") }
                        )
                        NavigationLink(
                            destination: FavoritesScreen(favorites: $favorites),
                            label: { Label("Favorites", systemImage: "heart") }
                        )
                    }.navigationSplitViewStyle(.balanced)
                }
            }
            content:{
                NavigationStack{
                    FavoritesScreen(favorites: $favorites)
                }
            }
            detail: {
                NavigationStack {
                    SearchScreen(
                        favorites: $favorites,
                        isSearchFocused: $isRhymeSearchFocused
                    )
                }
            }
        }
    }
}

#Preview {
    RootScreen()
}
