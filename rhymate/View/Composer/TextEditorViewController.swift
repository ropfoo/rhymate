import UIKit

final class TextEditorViewController: UIViewController, UITextViewDelegate {
    let textView = UITextView()

    var onTextChange: ((String) -> Void)?
    var onSelectionChange: ((String) -> Void)?
    var onHeightChange: ((CGFloat) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
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

    func textViewDidChange(_ textView: UITextView) {
        onTextChange?(textView.text)
        recalculateHeight()
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let range = textView.selectedTextRange else { return }
        let selected = textView.text(in: range) ?? ""
        onSelectionChange?(selected)
    }

    func setText(_ newText: String) {
        guard textView.text != newText else { return }
        textView.text = newText
    }
    
    private func recalculateHeight() {
          let fittingSize = CGSize(width: textView.bounds.width > 0 ? textView.bounds.width : 300, height: .infinity)
          let newHeight = textView.sizeThatFits(fittingSize).height
          onHeightChange?(newHeight)
      }
}
