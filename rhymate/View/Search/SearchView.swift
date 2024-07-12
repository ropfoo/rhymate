import Foundation
import SwiftUI

struct SearchView: View {
    @State var rhymes: DatamuseRhymeResponse = []
    @State var word: String = ""
    @Binding var favorites: FavoriteRhymes

    var body: some View {
        NavigationStack{
            ScrollView{
                RhymesGrid(rhymes:$rhymes, word: $word, favorites: $favorites)
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Spacer()
                }
            }
            SearchFormView(rhymes: $rhymes, word: $word)
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
