import UIKit

enum TraitType {
    case bold
    case italic
}

final class TextEditorViewController: UIViewController, UITextViewDelegate {
    let textView = UITextView()
    
    var onTextChange: ((NSAttributedString) -> Void)?
    var onSelectionChange: ((String, NSRange) -> Void)?
    var onHeightChange: ((CGFloat) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = false
        
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        DispatchQueue.main.async { [weak self] in
            self?.recalculateHeight()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if textView.text.isEmpty {
            applyDefaultTypingAttributesIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        onTextChange?(textView.attributedText)
        recalculateHeight()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let range = textView.selectedRange
        let selected = (textView.attributedText.string as NSString).substring(with: range)
        onSelectionChange?(selected, range)
    }
    
    func setText(_ newText: NSAttributedString, keepingSelection range: NSRange?) {
        guard textView.attributedText != newText else { return }
        applyDefaultTypingAttributesIfNeeded()
        
        let selectionToRestore = range ?? textView.selectedRange
        textView.attributedText = newText
        
        // Restore selection
        if selectionToRestore.location <= textView.attributedText.length {
            textView.selectedRange = selectionToRestore
        }
    }
    
    private func applyDefaultTypingAttributesIfNeeded() {
        textView.typingAttributes = [
            .font: UIFont.systemFont(ofSize: DEFAULT_FONT_SIZE),
            .foregroundColor: UIColor.label
        ]
    }
    
    func toggleTraitAtCurrentSelection(_ type: TraitType ) -> NSAttributedString {
        let range = textView.selectedRange
        guard range.length > 0 else { return textView.attributedText }
        
        let mutable = NSMutableAttributedString(attributedString: textView.attributedText)
        
        var trait: UIFontDescriptor.SymbolicTraits {
            switch type {
            case .bold: return .traitBold
            case .italic: return .traitItalic
            }
        }
        
        mutable.enumerateAttribute(.font, in: range, options: []) { value, subrange, _ in
            if let font = value as? UIFont {
                var traits = font.fontDescriptor.symbolicTraits
                let isTraitApplied = traits.contains(trait)
                
                if isTraitApplied {
                    traits.remove(trait)
                } else {
                    traits.insert(trait)
                }
                
                if let newDescriptor = font.fontDescriptor.withSymbolicTraits(traits) {
                    let updatedFont = UIFont(descriptor: newDescriptor, size: font.pointSize)
                    mutable.addAttribute(.font, value: updatedFont, range: subrange)
                }
            }
        }
        
        textView.attributedText = mutable
        textView.selectedRange = range
        return mutable
    }
    
    private func recalculateHeight() {
        let fittingSize = CGSize(width: textView.bounds.width > 0 ? textView.bounds.width : 300, height: .infinity)
        let newHeight = textView.sizeThatFits(fittingSize).height
        onHeightChange?(newHeight)
    }
}
