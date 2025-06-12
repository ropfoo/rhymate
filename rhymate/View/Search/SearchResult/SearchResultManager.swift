import SwiftUI

struct SearchResultManager: View {
    @Binding var isLoading: Bool
    @Binding var input: String
    @Binding var searchError: SearchError?
    @Binding var searchHistory: [String]
    @Binding var suggestions: [DatamuseSuggestion]
    @Binding var favorites: FavoriteRhymes
    let onRhymesFetch: (String) -> Void
    
    var body: some View {
        VStack {
            if isLoading {
               LoadingSpinner()
            } else if (input == "") {
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
            } else if let searchError {
                Spacer()
                SearchResultError(input: input, searchError: searchError)
                Spacer()
            } else {
                List {
                    ForEach(suggestions) { suggestion in
                        NavigationLink(
                            destination: RhymesScreen(
                                word: suggestion.word,
                                favorites: $favorites,
                                onRhymesFetch: onRhymesFetch
                            ),
                            label: { Text(suggestion.word)}
                        )
                    }
                }
            }
        }
        .navigationTitle("Search")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingsView()){
                    Image(systemName: "person.circle.fill")
                }
            }
        }
    }
}
