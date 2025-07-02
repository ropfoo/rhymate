import SwiftUI
import SwiftData

private enum ViewMode {
    case list
    case edit
}

private enum RenameMode: Equatable {
    case create
    case rename(CompositionCollection)
}

struct CompositionCollectionListView: View {
    @Binding var selectedCollection: CompositionCollection?
    
    @Query private var collections: [CompositionCollection]
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewMode: ViewMode = .list
    @State private var renameMode: RenameMode? = nil
    @State private var nameInput: String = ""
    
    var body: some View {
        List(selection: $selectedCollection) {
            Section(
                header: HStack {
                    Text("Projects")
                        .font(.headline)
                }
            ) {
                ForEach(collections) { collection in
                    HStack {
                        Label(collection.name, systemImage: "folder")
                        Spacer()
                        if viewMode == .edit {
                            Button {
                                nameInput = collection.name
                                renameMode = .rename(collection)
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if viewMode == .list {
                            selectedCollection = collection
                        }
                    }
                }
            }
        }
        .toolbar {
            switch viewMode {
            case .list:
                Button {
                    nameInput = ""
                    renameMode = .create
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
                .padding(.trailing)
                
                Button("Edit") {
                    withAnimation { viewMode = .edit }
                }
                
            case .edit:
                Button("Done") {
                    withAnimation { viewMode = .list }
                }
            }
        }
        .alert(
            renameMode == .create ? "New Folder" : "Rename Folder",
            isPresented: Binding<Bool>(
                get: { renameMode != nil },
                set: { if !$0 { renameMode = nil } }
            ),
            actions: {
                TextField("Name", text: $nameInput)
                Button("Cancel", role: .cancel) {
                    renameMode = nil
                }
                Button("Save") {
                    switch renameMode {
                    case .create:
                        let newCollection = CompositionCollection(name: nameInput)
                        modelContext.insert(newCollection)
                        selectedCollection = newCollection
                    case .rename(let collection):
                        collection.name = nameInput
                    case .none:
                        break
                    }
                    
                    do {
                        try modelContext.save()
                    } catch {
                        print("Error saving context: \(error)")
                    }
                    
                    renameMode = nil
                }
            }
        )
    }
}

