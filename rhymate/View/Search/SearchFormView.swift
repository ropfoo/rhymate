import SwiftUI

struct SearchFormView: View {
    @Binding var rhymes: DatamuseRhymeResponse
    @Binding var word: String
    @Binding var isLoading: Bool
    @Binding var searchError: SearchError?
    
    private let fetcher = DatamuseFetcher()
    
    func submit() async {
        withAnimation{
            searchError = nil
            isLoading = true
        }
        do {
            let rhymesResponse = try await fetcher.getRhymes(forWord: word)
            if rhymesResponse.isEmpty {
                withAnimation{ searchError = .noResults }
            }
            rhymes = rhymesResponse
        } catch {
            withAnimation{
                switch error._code {
                case -1009:
                    searchError = .network
                default:
                    searchError = .generic
                }
            }
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
        .frame(maxHeight: 100)
    }
}

#Preview {
    PreviewSearchView()
}
