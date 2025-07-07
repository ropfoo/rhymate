import SwiftUI

struct ComposeEditor: View {
    var key: String;
    @Binding var text: NSAttributedString
    @Binding var favorites: FavoriteRhymes
    var onChange: (() -> Void)?
    
    @State private var isAssistentVisible = false
    @State private var selected = ""
    @State private var height: CGFloat = 400
    
    @State private var coordinator: TextEditorContainer.Coordinator? = nil
    
    @StateObject private var keyboard = KeyboardObserver()
    
    var body: some View {
        ZStack() {
            TextEditorContainer(
                initialText: text,
                initialHeight: height,
                onTextChange: { updated in
                    DispatchQueue.main.async {
                        self.text = updated
                        onChange?()
                    }
                },
                onSelectionChange: { selection, range in
                    DispatchQueue.main.async {
                        self.selected = selection
                    }
                },
                onHeightChange: { updatedHeight in
                    self.height = max(updatedHeight, 600)
                },
                coordinatorRef: $coordinator
            )
            .id(key)
            .frame(height: height)
        }
        .toolbar {
            ToolbarItemGroup(
                placement: keyboard.isKeyboardVisible ? .navigation : .bottomBar
            ) {
                Button {
                    isAssistentVisible.toggle()
                } label: {
                    Image(systemName: "music.note")
                }
                Button {
                    if let updatedText = coordinator?.toggleBold() {
                        DispatchQueue.main.async {
                            self.text = updatedText
                            
                            print(updatedText)
                            print(self.text)
                            onChange?()
                        }
                    }
                } label: {
                    Image(systemName: "bold")
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
            
        }).onAppear {
            let loaded = text
            print("OnAppear: loaded string: \(loaded.string)")
            loaded.enumerateAttributes(in: NSRange(location: 0, length: loaded.length), options: []) { attrs, range, _ in
                print("Attributes at \(range): \(attrs)")
            }
        }
    }
}

#Preview {
    //    ComposeEditor()
}
