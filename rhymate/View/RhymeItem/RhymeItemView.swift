import Foundation
import SwiftUI

struct RhymeItem: Identifiable {
    let id: String
    let name: String
}

enum RhymeItemLayout {
    case grid
    case favorite
}

struct RhymeItemView: View {
    let layout: RhymeItemLayout
    private var rhyme: String
    private var word: String
    @State private var sheetDetail: RhymeItem?
    @State private var isFavorite: Bool
    
    @Binding var favorites: FavoriteRhymes
    
    let favoriteStorage = FavoriteRhymesStorage()
    
    init(_ layout: RhymeItemLayout = .grid,rhyme: String, word: String, favorites: Binding<FavoriteRhymes>) {
        self.layout = layout
        self.rhyme = rhyme
        self.word = word
        self._favorites = favorites
        self.sheetDetail = nil
        self.isFavorite = favoriteStorage.isFavorite(rhyme: rhyme, forWord: word)
    }
    
    var body:some View {
        ZStack(alignment: .topLeading){
            if layout == .grid && 
                favorites[word]?.rhymes.contains(rhyme) ?? false 
            {
                VStack{
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                }
                .padding(5)
                .frame(width: 20, height: 20)
                .background(.background)
                .cornerRadius(100)
                .offset(x: 0, y: -10)
                .zIndex(1)
                .shadow(radius: 1)

            }
            
            Button(action: {
                sheetDetail = RhymeItem(
                    id: rhyme,
                    name: rhyme)
            }, label: {
                Text(rhyme)
                    .font(.system(.caption))
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .foregroundColor(.primary)
                    .frame(
                        maxWidth: .infinity,
                        alignment: layout == .grid ? .center : .leading
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
                ).presentationDetents([.height(200), .large])
            }
            .background(.quinary)
            .cornerRadius(25)
        }
        
    }
}

struct PreviewRhymeItemView: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    
    var body: some View {
        RhymeItemView(rhyme: "best", word: "test", favorites: $favorites)
        RhymeItemView(.favorite, rhyme: "best", word: "test", favorites: $favorites)

    }
}

#Preview {
    PreviewRhymeItemView()
}
