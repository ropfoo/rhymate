import SwiftUI

struct TextEditorContainer: UIViewControllerRepresentable {
    class Coordinator {
        var controller: TextEditorViewController?
        var onTextChange: ((NSAttributedString) -> Void)?
        var onSelectionChange: ((String, NSRange) -> Void)?
        var onHeightChange: ((CGFloat) -> Void)?
        
        func toggleTrait(_ type: TraitType) -> NSAttributedString? {
            return controller?.toggleTraitAtCurrentSelection(type)
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
        vc.onTextChange = context.coordinator.onTextChange
        vc.onSelectionChange = context.coordinator.onSelectionChange
        vc.onHeightChange = context.coordinator.onHeightChange
        context.coordinator.controller = vc
        
        vc.textView.attributedText = ensureFont(in: initialText)
        
        DispatchQueue.main.async {
            self.coordinatorRef = context.coordinator
        }
        
        return vc
    }
    
    private func ensureFont(
        in attributed: NSAttributedString,
        defaultFont: UIFont = .systemFont(ofSize: DEFAULT_FONT_SIZE)
    ) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: attributed)
        let fullRange = NSRange(location: 0, length: mutable.length)
        
        mutable.enumerateAttribute(.font, in: fullRange, options: []) { value, range, _ in
            if value == nil {
                mutable.addAttribute(.font, value: defaultFont, range: range)
            }
        }

        return mutable
    }
    

    func updateUIViewController(_ uiViewController: TextEditorViewController, context: Context) {
        // do nothing to prevent re-renders via SwiftUI
    }
}
