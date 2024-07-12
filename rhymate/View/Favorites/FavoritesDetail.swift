import Foundation
import SwiftUI

struct FavoritesDetail: View {
    let word: String
    @Binding var favorites: FavoriteRhymes
    
    var body: some View {
        VStack(alignment: .leading){
            Text(word)
                .fontWeight(.black)
                .font(.system(.title))
                .padding(3)
            ScrollView{
                Spacer(minLength: 30)
                VStack(alignment: .trailing){
                    ForEach($favorites.wrappedValue[word]?.rhymes ?? [],id: \.self){ rhyme in
                        @State var isFavorite = true
                        FavoritesItemView(
                            .list,
                            word: word,
                            rhyme: rhyme,
                            onToggle: {},
                            favorites: $favorites,
                            isFavorite: $isFavorite
                        )
                    }
                    .frame(
                        minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                        maxWidth: .infinity
                    )
                }
            }
        }.padding(30)
    }
}

struct PreviewFavoritesDetail: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View{
        FavoritesDetail(word: "Test", favorites: $favorites)
    }
}

#Preview {
    PreviewFavoritesDetail()
}
