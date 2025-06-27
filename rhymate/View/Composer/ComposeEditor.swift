import SwiftUI

struct ComposeEditor: View {
    var key: String;
    @Binding var text: String
    @Binding var favorites: FavoriteRhymes
    var onChange: (() -> Void)?
    
    @State private var isAssistentVisible = false
    @State private var selected = ""
    @State private var height: CGFloat = 400

    var body: some View {
        VStack {
            TextEditorContainer(
                initialText: text,
                initialHeight: height,
                onTextChange: { updated in
                    DispatchQueue.main.async {
                        self.text = updated
                        onChange?()
                    }
                },
                onSelectionChange: { selection in
                    DispatchQueue.main.async {
                        self.selected = selection
                    }
                },
                onHeightChange: { updatedHeight in
                    self.height = max(updatedHeight, 400)
                }
            )
            .id(key)
            .frame(height: height)
        }
        .toolbar {
            if (!selected.isEmpty) {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAssistentVisible.toggle()
                    } label: {
                        Image(systemName: "music.note")
                    }
                }
            }
        }
        .sheet(isPresented: $isAssistentVisible, content: {
            NavigationStack {
                LyricAssistentView(
                    text: $selected,
                    favorites: $favorites,
                    hasAutoSubmit: true
                ).toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isAssistentVisible.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])

        })
    }
}

#Preview {
//    ComposeEditor()
}
