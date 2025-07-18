import Foundation
import SwiftUI

struct FavoritesDetail: View {
    let word: String
    @Binding var favorites: FavoriteRhymes

    var body: some View {
        let items: [RhymeItem] = (favorites[word]?.rhymes.map { rhyme -> RhymeItem in
            RhymeItem(word: word, rhyme: rhyme)
        }) ?? []
        
        VStack(alignment: .leading){
            HStack{
                Text(word)
                    .fontWeight(.black)
                    .font(.system(.title))
                    .padding(3)
            }.padding()
            ScrollView{
                RhymesGrid(
                    layout: .favorite,
                    word: word,
                    rhymes: items,
                    favorites: $favorites
                )
            }
        }
    }
}

struct PreviewFavoritesDetail: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View{
        FavoritesDetail(
            word: "Test",
            favorites: $favorites,
        )
    }
}

#Preview {
    PreviewFavoritesDetail()
}
