import SwiftUI
import SwiftData

struct CompositionsOverviewScreen: View {
    @Binding var selectedComposition: Composition?
    @Binding var favorites: FavoriteRhymes
    @Environment(\.modelContext) private var modelContext
    
    @State private var path = NavigationPath()
    
    @Query(sort: \Composition.updatedAt, order: .reverse)
    private var compositions: [Composition]
    
    var body: some View {
//        NavigationStack {
            VStack {
                if compositions.isEmpty {
                    Text("No Projects yet")
                    VStack(spacing: 12) {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 64))
                            .foregroundStyle(.accent)
                        
                        Button(action: createComposition) {
                            Label("Create Your First Project", systemImage: "plus")
                                .font(.headline)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.accentColor.opacity(0.15)))
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.accent)
                    }
                    .padding(.top, 12)
                } else {
                    List(selection: $selectedComposition) {
                        ForEach(compositions) { composition in
                            NavigationLink(
                                value: composition
//                                destination: CompositionView(
//                                    composition: composition,
//                                    favorites: $favorites,
//                                )
                            ) {
                                VStack(alignment: .leading) {
                                    Text(composition.title)
                                        .font(.headline)
                                    Text(composition.updatedAt.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .navigationTitle("Projects")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                createComposition()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }

                
    }
    
    private func delete(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let composition = compositions[index]
                
                // 👇 Clear the detail view if it was showing this one
                if selectedComposition?.id == composition.id {
                    selectedComposition = nil
                }

                modelContext.delete(composition)
            }

            do {
                try modelContext.save()
            } catch {
                print("Failed to save: \(error)")
            }
        }
    }
    
    private func createComposition() {
        let newComposition = Composition(
            title: "Untitled",
            content: "",
            createdAt: Date.now,
            updatedAt: Date.now
        )
        modelContext.insert(newComposition)
    }
}

