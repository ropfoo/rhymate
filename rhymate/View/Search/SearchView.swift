import Foundation
import SwiftUI

struct SearchView: View {
    private let fetcher = DatamuseFetcher()
    private var historyStorage: SearchHistoryStorage
    
    @State var suggestions: [DatamuseSuggestion] = []
    @State var isLoading: Bool = false
    @State var input: String = ""
    @State var searchError: SearchError? = nil
    @State var searchHistory: [SearchHistoryEntry]
    @State private var navigateToResults: Bool = false
    @State private var debounceTask: Task<Void, Never>? = nil
    
    @Binding var favorites: FavoriteRhymes
    @FocusState private var isSearchFocused: Bool
    
    init(favorites: Binding<FavoriteRhymes>, isSearchFocused: Binding<Bool>) {
        self.historyStorage = SearchHistoryStorage()
        self._favorites = favorites
        self.searchHistory = self.historyStorage.get()
        self.isSearchFocused = self.isSearchFocused
    }
    
    private func storeSearchTerm(_ searchTerm: String) {
        do {
            try historyStorage.mutate(.add, searchTerm)
//            searchHistory = historyStorage.get()
            withAnimation{ searchHistory = historyStorage.get() }
        } catch {
            print(error)
        }
    }
    
    private func search(searchTerm: String) async {
        let term = Formatter().formatInput(searchTerm)
        if term == "" {
            return withAnimation{isLoading = false; searchError = nil; suggestions = [] }
        }
        if term.count < 3 {
            return withAnimation{isLoading = false; searchError = .noResults; suggestions = [] }
        }
        
        do {
            withAnimation{ isLoading = true }
            let suggestionsResponse = try await fetcher.getSuggestions(forWord: term)
            if suggestionsResponse.isEmpty {
               return withAnimation{isLoading = false; searchError = .noResults }
            }
            print(suggestionsResponse)
            suggestions = suggestionsResponse
            withAnimation{ isLoading = false; searchError = nil }
        } catch {
            if let urlError = error as? URLError, urlError.code == .cancelled {
                // Ignore cancelled requests
                return withAnimation{ isLoading = false; searchError = nil}
            }
            return withAnimation{
                isLoading = false
                searchError = ErrorHelper().getSearchError(error: error)
                suggestions = [] 
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            SearchResultManager(
                isLoading: $isLoading,
                input: $input,
                searchError: $searchError,
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
//        @available(iOS 18.0, *)
//        .searchFocused($isSearchFocused)
        .onSubmit(of: .search, { navigateToResults = true } )
        .onChange(of: input) { i in
            isLoading = i.isEmpty == false;
            suggestions = []
            debounceTask?.cancel()
            debounceTask = Task { [input = i] in
                try? await Task.sleep(nanoseconds: 300_000_000)
                if !Task.isCancelled {
                    await search(searchTerm: input)
                }
            }
        }
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
