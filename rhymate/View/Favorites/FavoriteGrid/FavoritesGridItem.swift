import SwiftUI

struct FavoritesGridItem: View {
    let rhymes: [String]
    let word: String
    let onTap: (_ rhymeWithFavorites: RhymeWithFavorites) -> Void
    
    var body: some View {
        VStack{
            Button(
                action: {
                    onTap(RhymeWithFavorites(word: word, rhymes: rhymes))
                }
            ){
                ZStack{
                    VStack{
                        Text(word)
                            .fontWeight(.black)
                            .font(.system(.subheadline))
                            .foregroundColor(.primary)
                        Spacer()
                        HStack{
                            ForEach(rhymes, id: \.self){ rhyme in
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
                            minWidth: 0,
                            maxWidth: .infinity,
                            alignment: .center
                        )
                    }
                }.padding(10)
            }
        }
        .background(.quinary)
        .cornerRadius(20)
        .padding(5)
    }
}

#Preview {
    FavoritesGridItem(
        rhymes: ["best", "chest"], word: "test", onTap: {
            rhymeWithFavorites in print(rhymeWithFavorites.rhymes)
        }
    )
}
