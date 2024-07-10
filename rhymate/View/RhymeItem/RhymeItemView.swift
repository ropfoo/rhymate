import Foundation
import SwiftUI

struct RhymeItem: Identifiable {
    let id: String
    let name: String
}

struct RhymeItemView: View {
    @Binding private var rhyme: String
    @Binding private var word: String
    @State private var sheetDetail: RhymeItem?
    @State private var isFavorite: Bool
    
    private let favoriteStorage = FavoriteRhymesStorage()
    
    
    init(rhyme: Binding<String>, word: Binding<String>) {
        self._rhyme = rhyme
        self._word = word
        self.sheetDetail = nil
        self.isFavorite = favoriteStorage.isFavorite(rhyme: rhyme.wrappedValue, forWord: word.wrappedValue)
        
    }
    
    var body:some View {
        HStack{
            Button(action: {
                sheetDetail = RhymeItem(
                    id: rhyme,
                    name: rhyme)
            }, label: {
                Text("\($rhyme.wrappedValue)")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(.vertical, 18)
                    .opacity(1)
                    .foregroundColor(isFavorite ? .red : .primary)
                    .frame(
                        maxWidth: .infinity
                    )
            })
            .sheet(
                item: $sheetDetail,
                onDismiss: {}
            )
            { detail in
                RhymeItemDetail(rhyme: detail.name, word: word, isFavorite: $isFavorite)
                    .presentationDetents([.height(180)])
                    .onTapGesture {
                        sheetDetail = nil
                    }
            }
            .background(.gray.opacity(0.15))
            .cornerRadius(25)
        }
        
    }
}

struct PreviewRhymeItemView: View {
    @State var word = "test"
    @State var rhyme = "best"
    var body: some View {
        RhymeItemView(rhyme: $rhyme, word: $word)
    }
}

#Preview {
    PreviewRhymeItemView()
}
