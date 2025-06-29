import SwiftUI
import SwiftData

struct CompositionCollectionListView: View {
    @Binding var selectedCollection: CompositionCollection?
    
    @Query private var collections: [CompositionCollection]
    @Environment(\.modelContext) private var modelContext
    

    var body: some View {
        List(selection: $selectedCollection) {
            Section("Projects") {
                ForEach(collections) { collection in
                    NavigationLink(value: collection) {
                        Label(collection.name, systemImage: "folder")
                    }
                }
            }
        }
        .navigationTitle("Folders")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let newCollection = CompositionCollection(name: "New Folder")
                    modelContext.insert(newCollection)
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
            }
        }
    }
}

