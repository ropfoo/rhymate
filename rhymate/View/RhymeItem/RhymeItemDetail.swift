import SwiftUI

struct RhymeItemDetail: View {
    let rhyme: String
    let word: String
    
    @Binding var isFavorite: Bool
    private let favoriteStorage = FavoriteRhymesStorage()
    
    init(rhyme: String, word: String, isFavorite: Binding<Bool>) {
        self.rhyme = rhyme
        self.word = word
        self._isFavorite = isFavorite
    }
    
    func toggleState() {
        print(rhyme, word)
        do {
            try favoriteStorage.mutate(
                type: isFavorite ? .remove : .add,
                data: rhyme,
                key: word
            )
        } catch {
            print(error)
        }
        isFavorite = !isFavorite
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 22) {
            Text(rhyme)
                .font(.system(size: 18))
                .fontWeight(.semibold)
            FavoritesToggle(
                action: toggleState,
                isActivated: isFavorite
            )
        }
    }
}

struct PreviewRhymeItemDetail: View {
    @State var isFavorite = true
    var body: some View {
        RhymeItemDetail(rhyme: "best", word: "test", isFavorite: $isFavorite)
    }
}

#Preview{
    PreviewRhymeItemDetail()
}
