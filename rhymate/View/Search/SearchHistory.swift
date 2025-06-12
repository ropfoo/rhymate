import SwiftUI

struct SearchHistoryList: View {
    @Binding var history: [String]
    let destination: (String) -> RhymesScreen
    
    var body: some View {
        VStack{
            List{
                ForEach($history, id: \.self){
                    term in
                    NavigationLink(
                        destination: { destination(term.wrappedValue) },
                        label: { Text("\(term.wrappedValue)") }
                    )
                }
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
