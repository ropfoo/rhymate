import SwiftUI

struct Subheadline: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .fontWeight(.black)
            .font(.system(.subheadline))
            .foregroundColor(.primary)
    }
}

#Preview {
    Subheadline(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
}
