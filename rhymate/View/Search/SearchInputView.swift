import SwiftUI

struct SearchInputView: View {
    @Binding var input: String
    @Binding var word: String
    @Binding var showOverlay: Bool
    @Binding var isSearchTop: Bool
    @FocusState.Binding var isSearchFocused: Bool
    let setIsSearchTop: (Bool) -> Void
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
            HStack{
                VStack{
                    Image(systemName: isSearchTop ? "chevron.backward":"magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(isSearchTop ? .headline : .title3)

                }
                .padding()
                .onTapGesture {
                    setIsSearchTop(!isSearchTop)
                }
                TextField(
                    LocalizedStringKey("searchInput"),
                    text:$input,
                    onEditingChanged: handleChange,
                    onCommit: handleCommit
                )
                .padding(isSearchTop ? 0 : 20)
                .focused($isSearchFocused)
                .frame(maxWidth: 900)
            }
            .background(.quaternary)
            .cornerRadius(isSearchTop ? 20: 25)
            .onTapGesture {
                isSearchFocused = true
                
            }
            .onChange(of: isSearchFocused) { isFocused in
                withAnimation{
                    isSearchTop = isFocused || !input.isEmpty
                }}
            }
        .padding(.horizontal)
        }
    }

#Preview {
    PreviewSearchView()
}
