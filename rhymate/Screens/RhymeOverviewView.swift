import SwiftUI

struct RhymeOverviewView: View {
    @Binding var favorites: FavoriteRhymes
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(
                    destination: SearchScreen(favorites: $favorites),
                    label: { Label("Find", systemImage: "magnifyingglass") }
                )
                
                NavigationLink(
                    destination: FavoritesScreen(favorites: $favorites),
                    label: { Label("Favorites", systemImage: "heart") }
                )
            }.navigationTitle("Rhymes")
        }
    }
}

#Preview {
    //    RhymeOverviewView()
}
