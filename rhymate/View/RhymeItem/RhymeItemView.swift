import SwiftUI

struct RhymeItem: Identifiable {
    let id: String
    let word: String
    let rhyme: String
}

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
                Button(action: toggleFavorite, label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .accentColor : .gray.opacity(0.6))
                        .font(.system(size: 14))
                })
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderless)
                .padding(.leading, 15)
            }
            Button(action: onPress, label: {
                Text(rhyme)
                    .font(.system(.headline))
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .foregroundColor(.primary)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            })
            
        }
        .background(.quinary)
        .cornerRadius(25)
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
