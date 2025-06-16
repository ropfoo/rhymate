import SwiftUI

struct FavoritesGridItem: View {
    let rhymes: [String]
    let word: String
    
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading, spacing: 4){
                Text(word)
                    .fontWeight(.black)
                    .font(.system(.subheadline))
                    .foregroundColor(.primary)
                Text(rhymes.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .opacity(0.6)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }.padding()
            Spacer()
            Image(systemName: "chevron.right").padding()
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .center
        )
        .background(.quinary)
        .cornerRadius(12)
        .padding(4)
    }
}

#Preview {
    FavoritesGridItem(rhymes: ["best", "chest"], word: "test")
}
