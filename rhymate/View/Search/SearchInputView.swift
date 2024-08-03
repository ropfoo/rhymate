import SwiftUI

struct SearchInputView: View {
    @Binding var input: String
    @Binding var word: String
    @Binding var showOverlay: Bool
    @FocusState.Binding var isSearchFocused: Bool
    let onSubmit: () async -> Void
    
    private func formatInput(_ value: String) -> String {
        return value
            .trimmingCharacters(in: .punctuationCharacters)
            .trimmingCharacters(in: .symbols)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func handleCommit() {
        withAnimation{ showOverlay = true}
        word = formatInput(input)
        Task{ await onSubmit() }
    }
    
    private func handleChange(hasChanged: Bool) {
        if hasChanged {
            withAnimation{ showOverlay = true}
        }
    }
    
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
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField(
                    LocalizedStringKey("searchInput"),
                    text:$input,
                    onEditingChanged: handleChange,
                    onCommit: handleCommit
                )
                .focused($isSearchFocused)
            }
            .padding()
            .background(.quaternary)
            .cornerRadius(20)
            .onTapGesture {
                isSearchFocused = true
            }
            
        }
        .padding()
    }
}

#Preview {
    PreviewSearchView()
}
