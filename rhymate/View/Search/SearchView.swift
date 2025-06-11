import Foundation
import SwiftUI

struct SearchView: View {
    private let fetcher = DatamuseFetcher()
    private var historyStorage: SearchHistoryStorage
    
    @State var rhymes: DatamuseRhymeResponse = []
    @State var isLoading: Bool = false
    @State var input: String = ""
    @State var word: String = ""
    @State var searchError: SearchError? = nil
    @State var searchHistory: [String]
    @State private var searchScope = SearchScope.result
    
    @Binding var favorites: FavoriteRhymes
    @Binding private var isSearchFocused: Bool
    
    init(favorites: Binding<FavoriteRhymes>, isSearchFocused: Binding<Bool>) {
        self.historyStorage = SearchHistoryStorage()
        self._favorites = favorites
        self.searchHistory = self.historyStorage.get()
        self._isSearchFocused = isSearchFocused
    }
    
    private func formatInput(_ value: String) -> String {
        return value
            .trimmingCharacters(in: .punctuationCharacters)
            .trimmingCharacters(in: .symbols)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func submit() async {
        // handle empty input
        if input == "" {
            rhymes = []
            return
        }
        
        // set input to formatted word
        let searchTerm = formatInput(input)
        word = searchTerm
        
        withAnimation{
            searchError = nil
            isLoading = true
        }
        
        do {
            let rhymesResponse = try await fetcher.getRhymes(forWord: searchTerm)
            if rhymesResponse.isEmpty {
                withAnimation{ searchError = .noResults }
            }
            rhymes = rhymesResponse
            
            // store word in search storage
            try historyStorage.mutate(.add, searchTerm)
            withAnimation{
                var newHistory = searchHistory.filter{!$0.contains(searchTerm)}
                newHistory.insert(searchTerm, at: 0)
                searchHistory = newHistory
            }
        } catch {
            withAnimation{
                switch error._code {
                case -1009:
                    searchError = .network
                default:
                    searchError = .generic
                }
            }
            print(error)
        }
        withAnimation{
            isLoading = false
        }
    }
    
    var body: some View {
        NavigationStack{
          SearchResultManager(
            isLoading: $isLoading,
            input: $input,
            word: $word,
            searchError: $searchError,
            searchScope: $searchScope,
            searchHistory: $searchHistory,
            rhymes: $rhymes,
            favorites: $favorites,
            handleSumbit: submit
          )
        }
        .searchable(
            text: $input,
            // isPresented: $isSearchFocused
        )
        .searchScopes($searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
        .onSubmit(of: .search, {
            Task {
                await submit()
            }
        })
        .onChange(of: searchScope) { t in print(t) }
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
