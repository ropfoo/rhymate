import Foundation
import SwiftUI

struct SearchView: View {
    @State var rhymes: DatamuseRhymeResponse = []
    
    var body: some View {
        NavigationStack{
            ScrollView{
                RhymesGrid(rhymes:$rhymes)
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Spacer()
                }
            }
            SearchFormView(rhymes: $rhymes)
        }
    }
}

#Preview {
    SearchView()
}
