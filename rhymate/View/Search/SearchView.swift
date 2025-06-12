import Foundation
import SwiftUI

struct SearchView: View {
    private let fetcher = DatamuseFetcher()
    private var historyStorage: SearchHistoryStorage
    
    @State var suggestions: [DatamuseSuggestion] = []
    @State var isLoading: Bool = false
    @State var input: String = ""
    @State var searchError: SearchError? = nil
    @State var searchHistory: [String]
    @State private var searchScope = SearchScope.result
    @State private var navigateToResults: Bool = false
    
    @Binding var favorites: FavoriteRhymes
    @Binding private var isSearchFocused: Bool
    
    init(favorites: Binding<FavoriteRhymes>, isSearchFocused: Binding<Bool>) {
        self.historyStorage = SearchHistoryStorage()
        self._favorites = favorites
        self.searchHistory = self.historyStorage.get()
        self._isSearchFocused = isSearchFocused
    }
    
    private func storeSearchTerm(_ searchTerm: String) {
        do {
            try historyStorage.mutate(.add, searchTerm)
            withAnimation{
                var newHistory = searchHistory.filter{!$0.contains(searchTerm)}
                newHistory.insert(searchTerm, at: 0)
                searchHistory = newHistory
            }
        } catch {
            print(error)
        }
    }
    
    private func search(searchTerm: String) async {
        let term = Formatter().formatInput(searchTerm)
        if term.count < 3 {
            suggestions = []
            return
        }
        
        do {
            withAnimation{ isLoading = true }
            let suggestionsResponse = try await fetcher.getSuggestions(forWord: term)
            if suggestionsResponse.isEmpty {
                withAnimation{ searchError = .noResults }
            }
            suggestions = suggestionsResponse
            withAnimation{ isLoading = false }
        } catch {
            withAnimation{ searchError = ErrorHelper().getSearchError(error: error) }
        }
        withAnimation{ isLoading = false }
    }
    
    var body: some View {
        NavigationStack{
            SearchResultManager(
                isLoading: $isLoading,
                input: $input,
                searchError: $searchError,
                searchScope: $searchScope,
                searchHistory: $searchHistory,
                suggestions: $suggestions,
                favorites: $favorites,
                onRhymesFetch: storeSearchTerm
            )
            .navigationDestination(isPresented: $navigateToResults) {
                RhymesScreen(word: input, favorites: $favorites, onRhymesFetch: storeSearchTerm)
            }
        }
        .searchable(
            text: $input,
            prompt: "Find a rhyme"
            // isPresented: $isSearchFocused
        )
        .searchScopes($searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
        .onSubmit(of: .search, { navigateToResults = true } )
        .onChange(of: input) { i in Task { await search(searchTerm: i) } }
    }
}

struct PreviewSearchView: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    @State var isSearchFocused: Bool = false
    var body: some View {
        SearchView(favorites: $favorites, isSearchFocused: $isSearchFocused)
    }
}

#Preview {
    PreviewSearchView()
}
