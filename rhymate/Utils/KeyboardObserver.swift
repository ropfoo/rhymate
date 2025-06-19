import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        let willShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }

        let willHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }

        willShow
            .merge(with: willHide)
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
    }
}
