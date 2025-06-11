import SwiftUI

struct SearchResultManager: View {
    @Binding var isLoading: Bool
    @Binding var input: String
    @Binding var word: String
    @Binding var searchError: SearchError?
    @Binding var searchScope: SearchScope
    @Binding var searchHistory: [String]
    @Binding var rhymes: DatamuseRhymeResponse
    @Binding var favorites: FavoriteRhymes
    
    let handleSumbit: () async -> Void
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
            } else if (searchScope == .history) {
                SearchHistoryList(
                    history: $searchHistory,
                    onItemSelect: { selection in
                        input = selection
                        Task { await handleSumbit() }
                    }
                )
            } else if let searchError {
                Spacer()
                SearchResultError(
                    input: input,
                    searchError: searchError
                )
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
        .navigationTitle(rhymes.isEmpty ? "Search" : word)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingsView()){
                    Image(systemName: "person.circle.fill")
                }
            }
        }
        
    }
    
}
