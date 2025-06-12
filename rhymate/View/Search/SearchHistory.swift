import SwiftUI

struct SearchHistoryList: View {
    @Binding var history: [String]
    let destination: (String) -> RhymesScreen
    
    @State private var maxHistoryCount: Int = 3
    
    var body: some View {
        Section(header: Text("Latest")) {
            ForEach(Array(history.suffix(maxHistoryCount)).indices, id: \.self) { idx in
                let suffixHistory = Array($history.suffix(maxHistoryCount))
                let term = suffixHistory[idx]
                NavigationLink(
                    destination: { destination(term.wrappedValue) },
                    label: { Text("\(term.wrappedValue)") }
                )
            }
            Button("Show all") {
                withAnimation{ maxHistoryCount = history.count }
            }
        }
    }
}


struct SearchOverlayPreview: View {
    @State var searchHistory = ["test", "balloon"]
    @State var favorites: FavoriteRhymes = .init()
    func onRhymesFetch(_ word: String) { print(word) }
    
    var body: some View{
        SearchHistoryList(
            history: $searchHistory,
            destination: { entry in
                RhymesScreen(
                    word: entry,
                    favorites: $favorites,
                    onRhymesFetch: onRhymesFetch
                )
            }
        )
    }
}

#Preview {
    SearchOverlayPreview()
}
