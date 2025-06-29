import SwiftUI

struct RootView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    @State private var selectedComposition: Composition?
    @State private var selectedCollection: CompositionCollection?
    @State var isRhymesSheetVisible = false
    
    var body: some View {
        NavigationSplitView {
            Button(action: {
                isRhymesSheetVisible.toggle()
            }) {
                Label("Rhymes", systemImage: "music.note.list")
            }
            .sheet(isPresented: $isRhymesSheetVisible) {
                NavigationStack {
                    SearchScreen(favorites: $favorites)
                }
            }
            CompositionCollectionListView(
                selectedCollection: $selectedCollection,
            )
        } content: {
            if let collection = selectedCollection {
                CompositionListView(
                    selectedCollection: collection,
                    selectedComposition: $selectedComposition,
                    favorites: $favorites
                )
            } else {
                Text("Select something")
                
            }
        } detail: {
            if let composition = selectedComposition {
                CompositionView(composition: composition, favorites: $favorites)
            } else {
                Text("Select a composition")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    RootView()
}
