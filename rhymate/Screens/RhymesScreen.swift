import SwiftUI

struct RhymesScreen: View {
    var word: String
    @Binding var favorites: FavoriteRhymes
    var onDisappear: ((String) -> Void)?

    private let fetcher = DatamuseFetcher()
    
    @State private var isLoading: Bool = false
    @State private var rhymes: DatamuseRhymeResponse = []
    @State private var searchError: SearchError? = nil

    private func getRhymes(forWord: String) async {
        if forWord == "" {
            rhymes = []
            return
        }
        let searchTerm = Formatter().formatInput(forWord)
        withAnimation{ searchError = nil; isLoading = true }
        do {
            let rhymesResponse = try await fetcher.getRhymes(forWord: searchTerm)
            if rhymesResponse.isEmpty {
                withAnimation{ searchError = .noResults }
            }
            rhymes = rhymesResponse
        } catch {
            withAnimation { searchError = ErrorHelper().getSearchError(error: error) }
        }
        withAnimation{ isLoading = false }
    }

    var body: some View {
        VStack{
            if isLoading {
                LoadingSpinner()
            } else if(searchError != nil) {
                SearchResultError(input: word, searchError: $searchError.wrappedValue ?? .generic)
            } else {
                ScrollView {
                    RhymesGrid(
                        rhymes:$rhymes,
                        word: Binding<String>(get: { word }, set: { _ in }),
                        favorites: $favorites
                    )
                }
            }
        }
        .navigationTitle(word)
        .onAppear { Task { await getRhymes(forWord: word) } }
        .onDisappear {
            let searchTerm = Formatter().formatInput(word)
            onDisappear?(searchTerm)
        }
    }
}

#Preview {
//    RhymesScreen()
}
