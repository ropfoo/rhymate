import Foundation
import SwiftUI

struct RhymeItem: Identifiable {
    let id: String
    let name: String
}

struct RhymeItemView: View {
    @Binding private var rhyme: String
    @Binding private var word: String
    @State private var sheetDetail: RhymeItem?
    @State private var isFavorite: Bool
    
    @Binding var favorites: FavoriteRhymes
    
    let favoriteStorage = FavoriteRhymesStorage()
    

    
    init(rhyme: Binding<String>, word: Binding<String>, favorites: Binding<FavoriteRhymes>) {
        self._rhyme = rhyme
        self._word = word
        self._favorites = favorites
        self.sheetDetail = nil
        self.isFavorite = favoriteStorage.isFavorite(rhyme: rhyme.wrappedValue, forWord: word.wrappedValue)
        
    }
    
    var body:some View {
        ZStack(alignment: .topLeading){
            if favorites[word]?.rhymes.contains(rhyme) ?? false {
                VStack{
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                }
                .padding(5)
                .background(.quaternary)
                .cornerRadius(100)
                .offset(x: 0, y: -10)

            }
            
            Button(action: {
                sheetDetail = RhymeItem(
                    id: rhyme,
                    name: rhyme)
            }, label: {
                Text("\($rhyme.wrappedValue)")
                    .font(.system(.caption))
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .foregroundColor(.primary)
                    .frame(
                        maxWidth: .infinity
                    )
            })
            .sheet(
                item: $sheetDetail,
                onDismiss: {}
            )
            { detail in
                FavoritesItemView(
                    .detail,
                    word: word,
                    rhyme: detail.name,
                    onToggle: { sheetDetail = nil },
                    favorites: $favorites,
                    isFavorite: favorites[word]?.rhymes.contains(rhyme) ?? false
                ).presentationDetents([.height(180)])
            }
            .background(.quinary)
            .cornerRadius(25)
        }
        
    }
}

struct PreviewRhymeItemView: View {
    @State var word = "test"
    @State var rhyme = "best"
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    
    init(word: String = "test", rhyme: String = "best") {
        self.word = word
        self.rhyme = rhyme
    }
    
    var body: some View {
        RhymeItemView(rhyme: $rhyme, word: $word, favorites: $favorites)
    }
}

#Preview {
    PreviewRhymeItemView()
}
