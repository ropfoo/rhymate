import Foundation
import SwiftUI



struct FavoritesView: View {
    @Binding var favorites: FavoriteRhymes
    @State private var sheet: RhymeWithFavorites?
    
    private func hasFavoritesWithRhymes() -> Bool {
        var hasFavorite: Bool = false
        for favorite in favorites {
            if favorite.value.rhymes.isEmpty {
                continue
            } else {
                hasFavorite = true
            }
        }
        return hasFavorite
    }
    
    var body :some View {
        // if user has no stored favortes, display a default message
        if !hasFavoritesWithRhymes() {
            VStack(alignment: .center){
                Spacer()
                Text("No favorites yet")
                    .font(.system(.headline))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 10)
                Text("You can mark rhymes as favorites by tapping them and activating the heart icon")
                    .padding(.bottom, 20)
                Image(systemName: "heart.fill").foregroundColor(.red)
            }.padding(.horizontal, 50)
        }
        
        ScrollView{
            // iterate over each stored favorite
            ForEach(Array($favorites.wrappedValue.keys), id: \.self) {key in
                // check if favorite has rhymes
                if !(favorites[key]?.rhymes.isEmpty ?? false) {
                    VStack{
                        Button(
                            action: {
                                sheet = RhymeWithFavorites(word: key, rhymes: $favorites.wrappedValue[key]?.rhymes ?? [])
                            }
                        ){
                            VStack{
                                Subheadline(key)
                                HStack{
                                    ForEach($favorites.wrappedValue[key]?.rhymes ?? [], id: \.self){ rhyme in
                                        Text(rhyme)
                                            .lineLimit(1)
                                            .fixedSize()
                                            .padding(.horizontal, 5)
                                            .foregroundColor(.primary)
                                            .opacity(0.6)
                                    }
                                }
                                .frame(
                                    maxWidth: 300,
                                    alignment: .center
                                )
                                .clipped()
                            }.padding(10)
                        }
                        .sheet(
                            item: $sheet,
                            onDismiss: {sheet = nil}
                        ){ detail in
                            FavoritesDetail(
                                word: detail.word,
                                favorites: $favorites
                            )
                            .presentationDetents([.height(500)])
                        }
                    }
             
                
                    .background(.quinary)
                    .cornerRadius(20)
                    .padding(5)
                }
            }
            .padding(30)
          
        }
        .frame(
            minHeight: 0,
            maxHeight: .infinity
        )
    }
}

struct PreviewFavoritesView: View {
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View {
        FavoritesView(favorites: $favorites)
    }
}

#Preview {
    PreviewFavoritesView()
}
