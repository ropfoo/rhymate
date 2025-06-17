import SwiftUI

enum RhymeItemLayout {
    case grid
    case favorite
}

struct RhymeItemView: View {
    let layout: RhymeItemLayout
    let onPress: () -> Void
    private var rhyme: String
    private var word: String
    @State private var sheetDetail: RhymeItem?
    var isFavorite: Bool
    var toggleFavorite: () -> Void
    
    init(
        _ layout: RhymeItemLayout = .grid,
        onPress: @escaping () -> Void,
        rhyme: String,
        word: String,
        isFavorite: Bool,
        toggleFavorite: @escaping () -> Void,
    ) {
        self.layout = layout
        self.onPress = onPress
        self.rhyme = rhyme
        self.word = word
        self.sheetDetail = nil
        self.isFavorite = isFavorite
        self.toggleFavorite = toggleFavorite
    }
    
    var body:some View {
        HStack{
            if layout == .grid {
                FavoritesToggle(action: toggleFavorite, isActivated: isFavorite)
            }
            Button(action: onPress, label: {
                HStack{
                    Text(rhyme)
                        .font(.system(.headline))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    if UIDevice.current.userInterfaceIdiom != .phone {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)

            })
            .background(.quinary)
            .cornerRadius(10)
        }
    }
}

//struct PreviewRhymeItemView: View {
//    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
//
//    var body: some View {
//        RhymeItemView(onPress: {}, rhyme: "best", word: "test", favorites: $favorites)
//        RhymeItemView(.favorite,onPress: {}, rhyme: "best", word: "test", favorites: $favorites)
//    }
//}
//
//#Preview {
//    PreviewRhymeItemView()
//}
