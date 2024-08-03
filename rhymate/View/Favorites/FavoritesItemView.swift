import SwiftUI

enum FavoritesItemLayout {
    case list
    case detail
}

struct FavoritesItemView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var definitions: [String] = []
    @State var isLoading: Bool = true
    let layout: FavoritesItemLayout
    let word: String
    let rhyme: String
    @Binding var favorites: FavoriteRhymes
    var isFavorite: Bool
    
    init(
        _ layout: FavoritesItemLayout,
        word: String,
        rhyme: String,
        favorites: Binding<FavoriteRhymes>,
        isFavorite: Bool
    ) {
        self.layout = layout
        self.word = word
        self.rhyme = rhyme
        self._favorites = favorites
        self.isFavorite = isFavorite
    }
    
    func toggleState() {
        do {
            try FavoriteRhymesStorage().mutate(
                isFavorite ? .remove : .add,
                key: word,
                rhyme
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
            VStack(alignment: .center) {
                Spacer()
                HStack(alignment: .center, spacing: -20){
                    Spacer()
                    Text(word)
                        .font(.footnote)
                        .fontWeight(.black)
                        .foregroundColor(.secondary)
                    Spacer()
                    FavoritesToggle(
                        action: toggleState,
                        isActivated: isFavorite,
                        size: .large
                    )
                }
                .padding(.horizontal,20)
                .padding(.top, 20)
                .padding(.bottom, 5)
                
                Text(rhyme)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                VStack{
                    if isLoading {
                        VStack{
                            ProgressView()
                        }.frame(minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    } else {
                        HTMLContentView(
                            htmlElements: definitions,
                            scheme: colorScheme,
                            classNames: """
                            .definition p {
                                padding-bottom: 0.5rem;
                            }
                            """,
                            linkOptions: HTMLContentLinkOptions(
                                baseUrl: "https://en.wiktionary.org/",
                                target: "_blank"
                            )
                        )
                    }
                }.onAppear(perform: {
                    Task {
                        definitions = try await WiktionaryFetcher().getDefinitions(forWord: rhyme)
                        withAnimation{ isLoading = false }
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
        FavoritesItemView(
            layout,
            word: "test",
            rhyme: "best",
            favorites: $favorites,
            isFavorite: favorites["test"]?.rhymes.contains("best") ?? false )
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
