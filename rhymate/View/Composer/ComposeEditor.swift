import SwiftUI

struct ComposeEditor: View {
    @Binding var text: String
    @State private var selected = ""
    @State private var height: CGFloat = 400

    var body: some View {
        VStack(spacing: 20) {
            TextEditorContainer(
                initialText: text,
                initialHeight: height,
                onTextChange: { updated in
                    DispatchQueue.main.async {
                        self.text = updated
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
            .frame(height: height)
            .border(.gray)

            Text("Selected: \(selected)").font(.caption)
            Text("Live content: \(text)").font(.caption2)
        }
    }
}

#Preview {
//    ComposeEditor()
}
