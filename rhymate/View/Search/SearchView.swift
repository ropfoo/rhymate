import Foundation
import SwiftUI

struct SearchView: View {
    @State var rhymes: DatamuseRhymeResponse = []
    @State var isLoading: Bool = false
    @State var word: String = ""
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
                }else if rhymes.isEmpty {
                    Spacer()
                    VStack{
                        Text("no rhymes")
                    }
                    Spacer()

                } else {
                    ScrollView{
                        RhymesGrid(rhymes:$rhymes, word: $word, favorites: $favorites)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Spacer()
                }
            }
            Spacer()
            SearchFormView(rhymes: $rhymes, word: $word, isLoading: $isLoading)
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
