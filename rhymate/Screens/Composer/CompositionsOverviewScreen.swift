import SwiftUI
import SwiftData

struct CompositionsOverviewScreen: View {
    @Binding var favorites: FavoriteRhymes
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Composition.updatedAt, order: .reverse)
    private var compositions: [Composition]

    var body: some View {
        NavigationStack {
            List {
                ForEach(compositions) { composition in
                    NavigationLink(
                        destination: CompositionView(
                            composition: composition,
                            favorites: $favorites,
                        )
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
                        let newComposition = Composition(
                            title: "Untitled",
                            content: "",
                            createdAt: Date.now,
                            updatedAt: Date.now
                        )
                        modelContext.insert(newComposition)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(compositions[index])
        }
    }
}
