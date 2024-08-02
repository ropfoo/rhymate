import SwiftUI

struct SearchOverlay: View {
    @Binding var searchHistory: [String]
    let onItemSelect: (_ selection: String) -> Void
    
    
    var body: some View {
        ForEach($searchHistory, id: \.self){ term in
            Button("\(term.wrappedValue)", action: {
                onItemSelect(term.wrappedValue)
            })
        }
    }
}


struct SearchOverlayPreview: View {
    @State var searchHistory = ["test", "balloon"]
    var body: some View{
        SearchOverlay(
            searchHistory: $searchHistory,
            onItemSelect: {word in print("select \(word)")}
        )
    }
}

#Preview {
    SearchOverlayPreview()
}