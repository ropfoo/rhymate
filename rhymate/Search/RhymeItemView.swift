import Foundation
import SwiftUI

struct InventoryItem: Identifiable {
    let id: String
    let name: String
}

struct RhymeItemView: View {
    @Binding var rhyme: String
    @State private var sheetDetail: InventoryItem?
    
    var body:some View {
        HStack{
            Button(action: {
                sheetDetail = InventoryItem(
                    id: rhyme,
                    name: rhyme)
            }, label: {
                Text("\($rhyme.wrappedValue)")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(10)
                    .opacity(1)
                    .frame(
                        maxWidth: .infinity
                    )
            })
            .sheet(item: $sheetDetail,
                   onDismiss: {}) { detail in
                VStack(alignment: .leading, spacing: 20) {
                    Text("\(detail.name)")
                }
                .presentationDetents([.height(300)])
                .onTapGesture {
                    sheetDetail = nil
                }
            }
            
        }
        .background(.gray.opacity(0.15))
        .cornerRadius(10)
    }
}

#Preview {
    SearchView()
}
