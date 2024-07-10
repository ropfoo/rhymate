import Foundation
import SwiftUI

struct SearchView: View {
    @State var rhymes: DatamuseRhymeResponse = []
    @State var word: String = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                RhymesGrid(rhymes:$rhymes, word: $word)
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Spacer()
                }
            }
            SearchFormView(rhymes: $rhymes, word: $word)
        }
    }
}

#Preview {
    SearchView()
}
