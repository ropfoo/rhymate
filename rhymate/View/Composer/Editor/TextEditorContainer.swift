import SwiftUI

struct TextEditorContainer: UIViewControllerRepresentable {
    class Coordinator {
        var controller: TextEditorViewController?
        var onTextChange: ((String) -> Void)?
        var onSelectionChange: ((String) -> Void)?
        var onHeightChange: ((CGFloat) -> Void)?
    }

    let initialText: String
    let initialHeight: CGFloat
    var onTextChange: ((String) -> Void)? = nil
    var onSelectionChange: ((String) -> Void)? = nil
    var onHeightChange: ((CGFloat) -> Void)? = nil

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.onTextChange = onTextChange
        coordinator.onSelectionChange = onSelectionChange
        coordinator.onHeightChange = onHeightChange
        return coordinator
    }

    func makeUIViewController(context: Context) -> TextEditorViewController {
        let vc = TextEditorViewController()
        vc.textView.text = initialText
        vc.onTextChange = context.coordinator.onTextChange
        vc.onSelectionChange = context.coordinator.onSelectionChange
        vc.onHeightChange = context.coordinator.onHeightChange
        context.coordinator.controller = vc
        return vc
    }

    func updateUIViewController(_ uiViewController: TextEditorViewController, context: Context) {
        // do nothing to avoid triggering updates unless you need to call .setText()
    }
}
