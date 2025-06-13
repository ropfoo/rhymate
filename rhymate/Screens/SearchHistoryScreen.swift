import SwiftUI

struct SearchHistoryScreen: View {
    @Binding var history: [SearchHistoryEntry]
    let destination: (String) -> RhymesScreen

    let historyStorage = SearchHistoryStorage()
    
    func deleteHistory() {
        do {
            for entry in history {
                try historyStorage.mutate(.remove, entry.input)
            }
        } catch {
            print(error)
        }
        history = historyStorage.get()
    }

    
    var body: some View {
        List {
            ForEach(Array(history.indices), id: \.self) { idx in
                let entry = $history[idx]
                NavigationLink(
                    destination: { destination(entry.input.wrappedValue) },
                    label: { Text("\(entry.input.wrappedValue)") }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: deleteHistory) {
                        Label("Delete history", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                }
            }
        }
        .navigationTitle("History")
    }
}

#Preview {
//    SearchHistoryScreen()
}
