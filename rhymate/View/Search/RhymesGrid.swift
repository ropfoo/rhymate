import Foundation
import SwiftUI

struct RhymesGrid: View {
    @Binding var rhymes: DatamuseRhymeResponse
    var body: some View {
        LazyVGrid(columns:  [GridItem(.flexible()), GridItem(.flexible())], spacing: 0){
            ForEach($rhymes) { rhyme in
                RhymeItemView(rhyme:rhyme.word)
            }
            
        }
        .padding(.horizontal, 20)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )}
}

#Preview {
    SearchView()
}
