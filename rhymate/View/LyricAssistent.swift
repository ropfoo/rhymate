import SwiftUI

struct LyricAssistent: View {
    @Binding var text: String;
    @Binding var favorites: FavoriteRhymes;
    
    @State private var height: CGFloat = 40
    @State private var corners: UIRectCorner = .allCorners
    
    @State private var searchText: String = ""
    @FocusState private var hasFocus: Bool
    
    @StateObject private var keyboard = KeyboardObserver()
    
    var body: some View {
        VStack {
            ScrollView{
                RhymesScreen(word: searchText, favorites: $favorites)
            }
            Spacer()
            VStack {
                GrowingTextView(text: $text, height: $height)
                    .frame(height: height)
                HStack {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        searchText = text;
                    }) {
                        Image(systemName: "paperplane.fill")
                            .rotationEffect(.degrees(45))
                            .font(.system(size: 20))
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderless)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedCorners(radius: 24, corners: corners))
        }
        .hideKeyboardOnTap()
        .onChange(of: keyboard.isKeyboardVisible) { isVisible in
            corners = isVisible ? [.topLeft, .topRight]  : .allCorners
        }
    }
}

private struct LyricAssistentPreview: View {
    @State var text: String = "Hello World"
    @State var favorites = FavoriteRhymesStorage().getFavoriteRhymes()

    var body: some View {
        LyricAssistent(text: $text, favorites: $favorites)
    }
}

#Preview {
    LyricAssistentPreview()
}
