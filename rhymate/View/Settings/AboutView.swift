import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("Rhymate uses the Datamuse API to find rhyming words and Wiktionary for word definitions.")
                    .padding(.bottom)
                
                Link("Datamuse API", destination: URL(string: "https://www.datamuse.com/api/")!)
                Link("Wiktionary API", destination: URL(string: "https://en.wiktionary.org/w/api.php")!)

                Spacer()
            }
            .padding()
            .navigationTitle("about")
        }
    }
}

#Preview {
    AboutView()
}
