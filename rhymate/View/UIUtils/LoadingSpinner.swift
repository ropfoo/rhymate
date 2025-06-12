import SwiftUI

struct LoadingSpinner: View {
    var body: some View {
        ProgressView().scaleEffect(1.5, anchor: .center)
    }
}

#Preview {
    LoadingSpinner()
}
