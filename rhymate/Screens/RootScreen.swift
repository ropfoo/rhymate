import SwiftUI

struct RootScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabView{
                CompositionsOverviewScreen(favorites: $favorites).tabItem {
                    Label("Editor", systemImage: "square.and.pencil")
                }.modelContainer(for: Composition.self)
                
                RhymeOverviewView(favorites: $favorites).tabItem {
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
                            .modelContainer(for: Composition.self),
                            label: { Label("Editor", systemImage: "square.and.pencil") }
                        )
                        
                        NavigationLink(
                            destination: RhymeOverviewView(favorites: $favorites),
                            label: { Label("Rhymes", systemImage: "music.pages.fill") }
                        )
                    }.navigationSplitViewStyle(.balanced)
                }
            }
            content:{
                NavigationStack {
                    List {
                        NavigationLink(
                            destination: CompositionsOverviewScreen(
                                favorites: $favorites
                            )
                            .modelContainer(for: Composition.self),
                            label: { Label("Editor", systemImage: "square.and.pencil") }
                        )
                        
                        NavigationLink(
                            destination: RhymeOverviewView(favorites: $favorites),
                            label: { Label("Rhymes", systemImage: "music.pages.fill") }
                        )
                    }.navigationSplitViewStyle(.balanced)
                }
            }
            detail: {
                NavigationStack {
                    SearchScreen(favorites: $favorites)
                }
            }
        }
    }
}

#Preview {
    RootScreen()
}
