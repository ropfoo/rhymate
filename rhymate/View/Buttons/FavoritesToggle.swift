import Foundation
import SwiftUI

struct FavoritesToggle: View {
    let action: () -> Void
    let isActivated: Bool
    
    var body: some View {
        Button(
            "",
            systemImage: isActivated ? "heart.fill" : "heart",
            action: action
        )
        .font(.system(size: 20))
        .foregroundColor(
            isActivated ? .red: .blue
        )
        .cornerRadius(20)
        
    }
}

#Preview {
    VStack{
        Spacer()
        FavoritesToggle(
            action: {print("activate")},
            isActivated: false
        )
       Spacer()
        FavoritesToggle(
            action: {print("deactivate")},
            isActivated: true
        )
        Spacer()
    }
}
