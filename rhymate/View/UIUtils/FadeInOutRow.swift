import SwiftUI

struct FadeInOutRow: View {
    let rgbColorIn: CGFloat
    let rgbColorOut: CGFloat
    
    private let colorIn: Color
    private let colorOut: Color

    init(rgbColorIn: CGFloat, rgbColorOut: CGFloat) {
        self.rgbColorIn = rgbColorIn
        self.rgbColorOut = rgbColorOut
        
        colorIn = Color(red: rgbColorIn, green: rgbColorIn, blue: rgbColorIn)
        
        colorOut = Color(red: rgbColorOut, green: rgbColorOut, blue: rgbColorOut)
    }
    
    
    var body: some View {
        HStack(){}
            .frame(width: 50, height: 15)
            .background(LinearGradient(
                colors: [
                    colorIn,
                    colorIn,
                    colorIn.opacity(0.75),
                    .clear
                ],
                startPoint: .topTrailing,
                endPoint: .topLeading
            ))
            .zIndex(1)
            .offset(x:145, y: 10)
        HStack(){}
            .frame(width: 50, height: 15)
            .background(LinearGradient(
                colors: [
                    colorOut,
                    colorOut,
                    colorOut.opacity(0.75),
                    .clear
                ],
                startPoint: .topLeading,
                endPoint: .topTrailing
            ))
            .zIndex(1)
            .offset(x:-145, y: 10)
    }
}

#Preview {
    FadeInOutRow(rgbColorIn: 0.9, rgbColorOut: 0.9)
}
