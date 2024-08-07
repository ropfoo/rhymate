import Foundation
import SwiftUI

struct SearchView: View {
    private let fetcher = DatamuseFetcher()
    private var searchStorage: SearchHistoryStorage
    
    @State var rhymes: DatamuseRhymeResponse = []
    @State var isLoading: Bool = false
    @State var word: String = ""
    @State var input: String = ""
    @State var searchError: SearchError? = nil
    @Binding var favorites: FavoriteRhymes
    @State private var showOverlay: Bool = false
    @State var searchHistory: [String]
    @FocusState private var isSearchFocused: Bool
    
    init(favorites: Binding<FavoriteRhymes>) {
        self.searchStorage = SearchHistoryStorage()
        self._favorites = favorites
        self.searchHistory = self.searchStorage.get()
    }
    
    private func submit() async {
        // handle empty input
        if input == "" {
            rhymes = []
            showOverlay = false
            return
        }
        
        // set input to formatted word
        input = word
        
        withAnimation{
            searchError = nil
            isLoading = true
        }
        
        do {
            let rhymesResponse = try await fetcher.getRhymes(forWord: word)
            if rhymesResponse.isEmpty {
                withAnimation{ searchError = .noResults }
            }
            rhymes = rhymesResponse
            
            // store word in search storage
            try searchStorage.mutate(.add, word)
            withAnimation{
                var newHistory = searchHistory.filter{!$0.contains(word)}
                newHistory.insert(word, at: 0)
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
                    VStack{
                        if isLoading {
                            ProgressView()
                                .scaleEffect(1.5, anchor: .center)
                        } else {
                            SearchOverlay(
                                searchHistory: $searchHistory,
                                onItemSelect: { selection in
                                    word = selection
                                    input = selection
                                    Task{
                                        await submit()
                                        isSearchFocused = false
                                    }
                                }
                            ).navigationTitle("recent")

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
                                "fallbackNoRhymesFound \(word)",
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
                    FallbackView("fallbackNoInput", "magnifyingglass")
                    Spacer()
                } else {
                    ScrollView{
                        Spacer()
                        RhymesGrid(
                            rhymes:$rhymes,
                            word: $word,
                            favorites: $favorites
                        )
                    }.navigationTitle("\($word.wrappedValue)")
                }
            }
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
            }
            Spacer()
            SearchInputView(
                input: $input,
                word: $word,
                showOverlay: $showOverlay,
                isSearchFocused: $isSearchFocused,
                onSubmit: submit
            )
        }
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
