import SwiftUI

struct RootView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    @State private var selectedComposition: Composition?
    @State private var selectedCollection: CompositionCollection?
    @State var isRhymesSheetVisible = false
    
    var body: some View {
        NavigationSplitView {
            CompositionCollectionListView(
                selectedCollection: $selectedCollection,
            )
            
            Button {
                isRhymesSheetVisible.toggle()
            } label: {
                Label("Rhymes", systemImage: "music.note.list")
            }
            .buttonStyle(.bordered)
            .padding()
            .sheet(isPresented: $isRhymesSheetVisible) {
                NavigationStack {
                    SearchScreen(favorites: $favorites)
                }
            }
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
