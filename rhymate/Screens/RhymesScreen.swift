import SwiftUI

struct RhymesScreen: View {
    var word: String
    @Binding var favorites: FavoriteRhymes
    var onDisappear: ((String) -> Void)?
    
    private let lyricService = LyricService()
    
    @State private var isLoading: Bool = false
    @State private var rhymes: [String] = []
    @State private var searchError: SearchError? = nil
    
    private func getRhymes(forWord: String) async {
        if forWord == "" {
            rhymes = []
            return
        }
        let searchTerm = Formatter.normalize(forWord)
        updateState(suggestions: rhymes, error: nil, loading: true)
        
        let result = await lyricService.getSuggestions(forText: searchTerm, .word)
        switch result {
        case .success(let suggestions):
            return updateState(
                suggestions: suggestions,
                error: nil,
                loading: false
            )
        case .failure(let err):
            return updateState(
                suggestions: [],
                error: err,
                loading: false
            )
        }
    }
    
    private func updateState(
        suggestions: [String],
        error: SearchError?,
        loading: Bool
    ) {
        withAnimation{
            rhymes = suggestions
            searchError = error
            isLoading = loading
        }
        
    }
    
    var body: some View {
        VStack{
            if isLoading {
                LoadingSpinner()
            } else if(searchError != nil) {
                SearchResultError(input: word, searchError: $searchError.wrappedValue ?? .generic)
            } else {
                ScrollView {
                    RhymesGrid(word: word, rhymes: rhymes, favorites: $favorites)
                }
            }
        }
        .navigationTitle(word)
        
        .onAppear { Task { await getRhymes(forWord: word) } }
        .onChange(of:word) {w in Task { await getRhymes(forWord: w) }}
        .onDisappear {
            let searchTerm = Formatter.normalize(word)
            onDisappear?(searchTerm)
        }
    }
}

#Preview {
    //    RhymesScreen()
}
