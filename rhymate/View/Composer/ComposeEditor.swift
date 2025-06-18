import SwiftUI

struct ComposeEditor: View {
    @State private var lastText = ""
    @State private var selected = ""

    var body: some View {
        VStack(spacing: 20) {
            TextEditorContainer(
                initialText: "Type here...",
                onTextChange: { updated in
                    DispatchQueue.main.async {
                        self.lastText = updated
                    }
                },
                onSelectionChange: { selection in
                    DispatchQueue.main.async {
                        self.selected = selection
                    }
                }
            )
            .frame(height: 250)
            .border(.gray)

            Text("Selected: \(selected)").font(.caption)
            Text("Live content: \(lastText)").font(.caption2)
        }
        .padding()
    }
}

#Preview {
    ComposeEditor()
}
