import SwiftUI

struct SearchHistoryList: View {
    @Binding var history: [String]
    let onItemSelect: (_ selection: String) -> Void
        
    var body: some View {
        VStack{
            ScrollView{
                VStack(alignment:.leading){
                    ForEach($history, id: \.self){
                        term in
                        Button(
                            "\(term.wrappedValue)",
                            action: {onItemSelect(term.wrappedValue)}
                        ).padding(.bottom, 5)
                    }.frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
            }
        }
        .padding()
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}


struct SearchOverlayPreview: View {
    @State var searchHistory = ["test", "balloon"]
    var body: some View{
        SearchHistoryList(
            history: $searchHistory,
            onItemSelect: {word in print("select \(word)")}
        )
    }
}

#Preview {
    SearchOverlayPreview()
}
