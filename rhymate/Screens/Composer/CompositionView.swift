import SwiftUI

struct CompositionView: View {
    @Bindable var composition: Compositon
    @Binding var favorites: FavoriteRhymes

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer(minLength: 32)
                TextField("Title", text: $composition.title)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer(minLength: 24)
                ComposeEditor(text: $composition.content, favorites: $favorites)
            }
        }
        .navigationTitle(
            composition.title.isEmpty ? "New Song" : composition.title
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    CompositionView()
//}
