import SwiftUI

struct RootScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    @State var isRhymeSearchFocused: Bool = false
    
//    @State var text: String = "Hello word, there are a fiew more words here so yeah i guess"
    
    @State var text: String = "hello"
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabView{
                CompositionsOverviewScreen(favorites: $favorites).tabItem {
                    Label("Editor", systemImage: "square.and.pencil")
                }.modelContainer(for: Compositon.self)
                
//                LyricAssistentView(text: $text, favorites: $favorites).tabItem {
//                    Label("Search", systemImage: "magnifyingglass")
//                }
                
                FavoritesScreen(favorites: $favorites).tabItem {
                    Label("Rhymes", systemImage: "music.pages.fill")
                }
            }
        }
        else {
            NavigationSplitView {
                NavigationStack {
                    List {
                        NavigationLink(
                            destination: CompositionsOverviewScreen(
                                favorites: $favorites
                            )
                            .modelContainer(for: Compositon.self),
                            label: { Label("Editor", systemImage: "square.and.pencil") }
                        )
                    
                        NavigationLink(
                            destination: LyricAssistentView(text: $text, favorites: $favorites),
                            label: { Label("Search", systemImage: "magnifyingglass") }
                        )
                    
                        NavigationLink(
                            destination: FavoritesScreen(favorites: $favorites),
                            label: { Label("Favorites", systemImage: "music.pages") }
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
