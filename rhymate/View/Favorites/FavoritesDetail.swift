import Foundation
import SwiftUI

struct FavoritesDetail: View {
    let word: String
    @Binding var favorites: FavoriteRhymes
    let onDismiss: () -> Void

    var body: some View {
        let items: [RhymeItem] = (favorites[word]?.rhymes.map { r -> RhymeItem in
            RhymeItem(word: word, rhyme: r)
        }) ?? []
        VStack(alignment: .leading){
            HStack{
                Text(word)
                    .fontWeight(.black)
                    .font(.system(.title))
                    .padding(3)
                Spacer()
                Button("close", action: onDismiss)
            }
            ScrollView{
                RhymesGrid(rhymes: items, favorites: $favorites)
            }
        }
        .padding(30)
    }
}

struct PreviewFavoritesDetail: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View{
        FavoritesDetail(
            word: "Test",
            favorites: $favorites,
            onDismiss: { print("dismiss") }
        )
    }
}

#Preview {
    PreviewFavoritesDetail()
}
