import SwiftUI
import SwiftData

struct CompositionsOverviewScreen: View {
    @Query var compositions: [Compositon]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(compositions) { composition in
                    NavigationLink(
                        destination: CompositionView(composition: composition)) {
                        VStack(alignment: .leading) {
                            Text(composition.title)
                                .font(.headline)
                            Text(composition.createdAt.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Your Songs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let newCompositon = Compositon(
                            title: "Untitled",
                            content: "",
                            createdAt: Date.now,
                            updatedAt: Date.now
                        )
                        context.insert(newCompositon)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(compositions[index])
        }
    }
}

#Preview {
    CompositionsOverviewScreen()
}
