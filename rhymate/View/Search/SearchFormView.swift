import SwiftUI

struct SearchFormView: View {
    @Binding var input: String
    @Binding var word: String
    @Binding var showOverlay: Bool
    @FocusState.Binding var isSearchFocused: Bool
    @Binding var searchHistory: [String]
    let onSubmit: () async -> Void
    
    private let fetcher = DatamuseFetcher()
    
    var body: some View {
        VStack{
            if showOverlay {
                Button("done", action: {
                    withAnimation{
                        showOverlay = false
                        isSearchFocused = false
                    }
                })
            }
            HStack{
                TextField(
                    LocalizedStringKey("searchInput"),
                    text:$input,
                    onEditingChanged: {changed in
                        if changed {
                            withAnimation{ showOverlay = true}
                        }
                    },
                    onCommit: {withAnimation{
                        showOverlay = true
                        word = input
                        Task{ await onSubmit() }
                    }}
                )
                .focused($isSearchFocused)
                .padding()
                .background(.quinary)
            }
        }
        .padding()
    }
}

#Preview {
    PreviewSearchView()
}
