import SwiftUI

struct FallbackView: View {
    let localizedKey: LocalizedStringKey
    let systemName: String
    
    init(_ localizedKey: LocalizedStringKey, _ systemName: String = "info.circle") {
        self.localizedKey = localizedKey
        self.systemName = systemName
    }
    
    var body: some View {
        VStack{
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            Text(localizedKey)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    FallbackView("Some text message")
}
