import SwiftUI

struct FallbackView: View {
    let text: String
    let systemName: String
    
    init(_ text: String, _ systemName: String = "info.circle") {
        self.text = text
        self.systemName = systemName
    }
    
    var body: some View {
        VStack{
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            Text(text)
                .font(.footnote)
                .foregroundColor(.secondary)

        }
    }
}

#Preview {
    FallbackView("Some text message")
}
