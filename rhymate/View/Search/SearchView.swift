import Foundation
import SwiftUI

struct SearchView: View {
    @State var rhymes: DatamuseRhymeResponse = []
    @State var isLoading: Bool = false
    @State var word: String = ""
    @State var searchError: SearchError? = nil
    @Binding var favorites: FavoriteRhymes
    
    var body: some View {
        NavigationStack{
            VStack {
                if isLoading {
                    Spacer()
                    VStack(alignment: .center){
                        ProgressView()
                            .scaleEffect(1.5, anchor: .center)
                    }
                    Spacer()
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
                        RhymesGrid(
                            rhymes:$rhymes,
                            word: $word,
                            favorites: $favorites
                        )
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
            }
            Spacer()
            SearchFormView(
                rhymes: $rhymes,
                word: $word,
                isLoading: $isLoading,
                searchError: $searchError
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
