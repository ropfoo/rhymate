import SwiftUI

struct CompositionView: View {
    @Bindable var composition: Compositon
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextField("Title", text: $composition.title)
                ComposeEditor(text: $composition.content)
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
