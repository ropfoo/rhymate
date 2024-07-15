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
    
    func toggleState() {
        let isFav = favorites[word]?.rhymes.contains(rhyme) ?? false
        do {
            try favoriteStorage.mutate(
                isFav ? .remove : .add,
                data: rhyme,
                key: word
            )
        } catch {
            print(error)
        }
        withAnimation {
            favorites = DictionaryHelper().mutateFavorite(
                favorites,
                isFav ? .remove : .add,
                data: rhyme,
                key: word
            )
        }
    }
    
    var body:some View {
        ZStack(alignment: .topLeading){
            if favorites[word]?.rhymes.contains(rhyme) ?? false {
                VStack{
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                }
                .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                .padding(5)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(100)
                .offset(x: 0, y: -10)
                .shadow(radius: 1)
            }
            
            Button(action: toggleState , label: {
                Text("\($rhyme.wrappedValue)")
                    .font(.system(.caption))
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .foregroundColor(.primary)
                    .frame(
                        maxWidth: .infinity
                    )
            })
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
