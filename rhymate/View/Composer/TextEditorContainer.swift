import SwiftUI
struct TextEditorContainer: UIViewControllerRepresentable {
    class Coordinator {
        var controller: TextEditorViewController?
        var onTextChange: ((String) -> Void)?
        var onSelectionChange: ((String) -> Void)?
    }

    let initialText: String
    var onTextChange: ((String) -> Void)? = nil
    var onSelectionChange: ((String) -> Void)? = nil

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.onTextChange = onTextChange
        coordinator.onSelectionChange = onSelectionChange
        return coordinator
    }

    func makeUIViewController(context: Context) -> TextEditorViewController {
        let vc = TextEditorViewController()
        vc.textView.text = initialText
        vc.onTextChange = context.coordinator.onTextChange
        vc.onSelectionChange = context.coordinator.onSelectionChange
        context.coordinator.controller = vc
        return vc
    }

    func updateUIViewController(_ uiViewController: TextEditorViewController, context: Context) {
        // do nothing to avoid triggering updates unless you need to call .setText()
    }
}
