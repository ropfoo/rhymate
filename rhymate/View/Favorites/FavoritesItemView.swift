import SwiftUI

enum FavoritesItemLayout {
    case list
    case detail
}

struct FavoritesItemView: View {
    @Environment(\.colorScheme) var colorScheme

    @State var definitions: [String] = []
    let layout: FavoritesItemLayout
    let word: String
    let rhyme: String
    let onToggle: () -> Void
    @Binding var favorites: FavoriteRhymes
    var isFavorite: Bool
    
    init(
        _ layout: FavoritesItemLayout,
        word: String,
        rhyme: String,
        onToggle: @escaping () -> Void,
        favorites: Binding<FavoriteRhymes>,
        isFavorite: Bool
    ) {
        self.layout = layout
        self.word = word
        self.rhyme = rhyme
        self.onToggle = onToggle
        self._favorites = favorites
        self.isFavorite = isFavorite
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
        }
    }
    
    var body: some View {
        switch layout {
        case .detail:
            VStack(alignment: .center, spacing: 16) {
                Text(word)
                    .font(.footnote)
                    .fontWeight(.black)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                Text(rhyme)
                    .fontWeight(.bold)
                FavoritesToggle(
                    action: toggleState,
                    isActivated: isFavorite,
                    size: .large
                )
                VStack{
                    HTMLContentView(
                        htmlElements: definitions,
                        scheme: colorScheme
                    )
                }.onAppear(perform: {
                    Task {
                        definitions = try await WiktionaryFetcher().getDefinitions(forWord: rhyme)
                    }
                })
            }
        case .list:
            HStack {
                Text(rhyme)
                    .font(.system(.caption))
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
                FavoritesToggle(
                    action: toggleState,
                    isActivated: isFavorite)
                .padding(.horizontal, 12)
                
            }
            .padding(.vertical, 12)
            .background(.quinary)
            .frame(
                minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                maxWidth: .infinity
            )
            .cornerRadius(.infinity)
        }
        
    }
}

struct PreviewFavoritesItemView: View {
    let layout: FavoritesItemLayout
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()
    var body: some View{
        FavoritesItemView(layout, word: "test", rhyme: "best",onToggle: {print("toggle")}, favorites: $favorites, isFavorite: favorites["test"]?.rhymes.contains("best") ?? false )
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
