import SwiftUI

struct SearchFormView: View {
    @Binding var rhymes: DatamuseRhymeResponse
    @Binding var word: String
    @Binding var isLoading: Bool
    
    private let fetcher = DatamuseFetcher()
    
    func submit() async {
        withAnimation{ isLoading = true }
        do {
            let rhymesResponse = try await fetcher.getRhymes(forWord: word)
            rhymes = rhymesResponse
        } catch {
            print(error)
        }
        withAnimation{ isLoading = false }
    }
    
    var body: some View {
        Form{
            HStack{
                TextField("Search rhyme...", text:$word)
            }
        }.onSubmit {
            Task{
                await submit()
            }
        }
        .frame(
            maxHeight: 100
        )
    }
}

#Preview {
    PreviewSearchView()
}
