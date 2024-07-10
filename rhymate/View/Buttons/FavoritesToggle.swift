import Foundation
import SwiftUI

struct FavoritesToggle: View {
    let action: () -> Void
    let isActivated: Bool
    
    var body: some View {
        Button(
            action: action
        ){
            Image(systemName: isActivated ? "heart.fill" : "heart")
        }
        .font(.system(size: 24))
        .foregroundColor(
            isActivated ? .red: .blue
        )
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
