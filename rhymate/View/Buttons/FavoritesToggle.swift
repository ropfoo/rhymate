import Foundation
import SwiftUI

enum FavoriteToggleSize {
    case small
    case large
}

struct FavoritesToggle: View {
    let action: () -> Void
    let isActivated: Bool
    let size: FavoriteToggleSize
    private var sizeValue: CGFloat
    
    init(action: @escaping () -> Void, isActivated: Bool, size: FavoriteToggleSize = .small) {
        self.action = action
        self.isActivated = isActivated
        self.size = size
        
        switch self.size {
        case .large: self.sizeValue = 20
        case .small: self.sizeValue = 14
        }
    }
    
    var body: some View {
        Button(
            action: action
        ){
            Image(systemName: isActivated ? "heart.fill" : "heart")
        }
        .font(.system(size: sizeValue))
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
            isActivated: true,
            size: .small
        )
        Spacer()
        FavoritesToggle(
            action: {print("activate")},
            isActivated: false,
            size: .large
        )
        Spacer()
        FavoritesToggle(
            action: {print("deactivate")},
            isActivated: true,
            size: .large
        )
        Spacer()
    }
}
