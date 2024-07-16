import Foundation
import SwiftUI



struct FavoritesView: View {
    @Environment(\.colorScheme) var colorScheme
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
        NavigationStack{
            // if user has no stored favortes, display a default message
            if !hasFavoritesWithRhymes() {
                VStack(alignment: .center){
                    Spacer()
                    Text("fallbackFavoritesTitle")
                        .font(.system(.headline))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 10)
                    Text("fallbackFavoritesText")
                        .padding(.bottom, 10)
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
                                let fadeColor =
                                colorScheme == .dark ? 0.06 : 0.925
                                ZStack{
                                    FadeInOutRow(
                                        rgbColorIn: fadeColor,
                                        rgbColorOut: fadeColor
                                    )
                                    VStack{
                                        Text(key)
                                            .fontWeight(.black)
                                            .font(.system(.caption))
                                            .foregroundColor(.primary)
                                        HStack{
                                            ForEach($favorites.wrappedValue[key]?.rhymes ?? [], id: \.self){ rhyme in
                                                Text(rhyme)
                                                    .font(.footnote)
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
                                    }
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
                                .presentationDetents([.medium, .large])
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
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
            }
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
