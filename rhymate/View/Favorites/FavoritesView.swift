import Foundation
import SwiftUI



struct FavoritesView: View {
    @Binding var favorites: FavoriteRhymes
    @State private var sheet: RhymeWithFavorites?
    
    var body :some View {
        ScrollView{
            ForEach(Array($favorites.wrappedValue.keys), id: \.self) {key in
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
            }.padding(30)
        }
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
