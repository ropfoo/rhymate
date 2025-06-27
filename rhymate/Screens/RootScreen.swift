import SwiftUI

struct RootScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    @State private var selectedComposition: Composition?
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabView{
                CompositionsOverviewScreen(
                    selectedComposition: $selectedComposition,
                    favorites: $favorites).tabItem {
                        Label("Editor", systemImage: "square.and.pencil")
                    }.modelContainer(for: Composition.self)
                
                RhymeOverviewView(favorites: $favorites).tabItem {
                    Label("Rhymes", systemImage: "music.pages.fill")
                }
            }
        }
        else {
            NavigationSplitView {
                List {
                    NavigationLink(
                        destination: CompositionsOverviewScreen(
                            selectedComposition: $selectedComposition,
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
            content: {}
            detail: {
                if let composition = selectedComposition {
                    CompositionView(
                        composition: composition,
                        favorites: $favorites
                    )
                } else {
                    Text("Select or create a composition")
                }
            }
        }
    }
}

#Preview {
    RootScreen()
}
