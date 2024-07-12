import SwiftUI

enum FavoritesItemLayout {
    case list
    case detail
}

struct FavoritesItemView: View {
    let layout: FavoritesItemLayout
    let word: String
    let rhyme: String
    let onToggle: () -> Void
    @Binding var favorites: FavoriteRhymes
    @Binding var isFavorite: Bool
    
    init(
        _ layout: FavoritesItemLayout,
        word: String,
        rhyme: String,
        onToggle: @escaping () -> Void,
        favorites: Binding<FavoriteRhymes>,
        isFavorite: Binding<Bool>
    ) {
        self.layout = layout
        self.word = word
        self.rhyme = rhyme
        self.onToggle = onToggle
        self._favorites = favorites
        self._isFavorite = isFavorite
    }
    
    func toggleState() {
        onToggle()
        do {
            try FavoriteRhymesStorage().mutate(
                isFavorite ? .remove : .add,
                data: rhyme,
                key: word
            )
        } catch {
            print(error)
        }
        withAnimation {
            favorites = DictionaryHelper().mutateFavorite(
                favorites,
                isFavorite ? .remove : .add,
                data: rhyme,
                key: word
            )
            isFavorite = !isFavorite
        }
        
    }
    
    var body: some View {
        switch layout {
        case .detail:
            VStack(alignment: .center, spacing: 22) {
                Text(rhyme)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                FavoritesToggle(
                    action: toggleState,
                    isActivated: isFavorite,
                    size: .large
                )
            }
        case .list:
            HStack {
                Text(rhyme)
                    .font(.system(.callout))
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
                FavoritesToggle(
                    action: toggleState,
                    isActivated: isFavorite)
                .padding(.horizontal,3)
                
            }
            .padding()
            .background(.quinary.opacity(0.8))
            .frame(
                minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                maxWidth: .infinity
            )
            .cornerRadius(.infinity)
            .padding(3)
        }
        
    }
}

struct PreviewFavoritesItemView: View {
    let layout: FavoritesItemLayout
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    @State var isFavorite = FavoriteRhymesStorage().isFavorite(rhyme: "best", forWord: "test")
    var body: some View{
        FavoritesItemView(layout, word: "test", rhyme: "best",onToggle: {print("toggle")}, favorites: $favorites, isFavorite: $isFavorite )
    }
}

#Preview {
    VStack{
        Spacer()
        PreviewFavoritesItemView(layout: .list)
        Spacer()
        PreviewFavoritesItemView(layout: .detail)
        Spacer()
        
    }
}
