import Foundation
import SwiftUI

struct SearchView: View {
    private let fetcher = DatamuseFetcher()
    private var searchStorage: SearchHistoryStorage
    
    @State var rhymes: DatamuseRhymeResponse = []
    @State var isLoading: Bool = false
    @State var input: String = ""
    @State var searchError: SearchError? = nil
    @State var searchHistory: [String]
    @State private var showOverlay: Bool = false
    
    enum SearchScope: String, CaseIterable {
        case inbox, favorites
    }
    
    @State private var searchScope = SearchScope.inbox
    
    @Binding var favorites: FavoriteRhymes
    @FocusState private var isSearchFocused: Bool
    
    init(favorites: Binding<FavoriteRhymes>) {
        self.searchStorage = SearchHistoryStorage()
        self._favorites = favorites
        self.searchHistory = self.searchStorage.get()
    }
    
    private func formatInput(_ value: String) -> String {
        return value
            .trimmingCharacters(in: .punctuationCharacters)
            .trimmingCharacters(in: .symbols)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func submit() async {
        print("submit", input)
        // handle empty input
        if input == "" {
            rhymes = []
            return
        }
        
        // set input to formatted word
        let searchTerm = formatInput(input)
        
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
            try searchStorage.mutate(.add, searchTerm)
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
            showOverlay = false
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                if showOverlay {
                    VStack(alignment: .trailing){
                        if isLoading {
                            ProgressView()
                                .scaleEffect(1.5, anchor: .center)
                        } else {
                            SearchOverlay(
                                searchHistory: $searchHistory,
                                onItemSelect: { selection in
                                    input = selection
                                    Task{
                                        await submit()
                                        isSearchFocused = false
                                    }
                                }
                            )
                        }
                    }
                    .frame(
                        minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity
                    )
                    .background(.background)
                } else if let searchError {
                    Spacer()
                    VStack(alignment: .center){
                        switch searchError {
                        case .noResults:
                            FallbackView(
                                "fallbackNoRhymesFound \(input)",
                                "exclamationmark.magnifyingglass"
                            )
                        case .network:
                            FallbackView(
                                "fallbackNoInternetConnection",
                                "network.slash"
                            )
                        case .generic:
                            FallbackView(
                                "fallbackUnexpectedError",
                                "exclamationmark.triangle"
                            )
                        }
                    }
                    Spacer()
                } else if rhymes.isEmpty{
                    Spacer()
                
                } else {
                    ScrollView{
                        RhymesGrid(
                            rhymes:$rhymes,
                            word: $input,
                            favorites: $favorites
                        ).padding(.top, 15)
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()){
                        Image(systemName: "person.circle.fill")
                    }
                }
            }
        }
        .searchable(text: $input)
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
    var body: some View {
        SearchView(favorites: $favorites)
    }
}

#Preview {
    PreviewSearchView()
}
