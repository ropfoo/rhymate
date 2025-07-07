import SwiftUI

struct TextEditorContainer: UIViewControllerRepresentable {
    class Coordinator {
        var controller: TextEditorViewController?
        var onTextChange: ((NSAttributedString) -> Void)?
        var onSelectionChange: ((String, NSRange) -> Void)?
        var onHeightChange: ((CGFloat) -> Void)?
        
        func toggleBold() -> NSAttributedString? {
            return controller?.toggleBoldAtCurrentSelection()
        }
    }

    let initialText: NSAttributedString
    let initialHeight: CGFloat
    var onTextChange: ((NSAttributedString) -> Void)? = nil
    var onSelectionChange: ((String, NSRange) -> Void)? = nil
    var onHeightChange: ((CGFloat) -> Void)? = nil
    @Binding var coordinatorRef: TextEditorContainer.Coordinator?

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.onTextChange = onTextChange
        coordinator.onSelectionChange = onSelectionChange
        coordinator.onHeightChange = onHeightChange
        return coordinator
    }

    func makeUIViewController(context: Context) -> TextEditorViewController {
        let vc = TextEditorViewController()
        vc.textView.attributedText = initialText
        vc.onTextChange = context.coordinator.onTextChange
        vc.onSelectionChange = context.coordinator.onSelectionChange
        vc.onHeightChange = context.coordinator.onHeightChange
        context.coordinator.controller = vc
        
        DispatchQueue.main.async {
            self.coordinatorRef = context.coordinator
        }
        
        return vc
    }

    func updateUIViewController(_ uiViewController: TextEditorViewController, context: Context) {
        // do nothing to prevent re-renders via SwiftUI
    }
}
