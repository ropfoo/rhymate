import SwiftUI

struct SearchResultError: View {
    
    let input: String;
    let searchError: SearchError;
    
    var body: some View {
        VStack(alignment: .center){
            switch searchError {
            case .noResults:
                FallbackView(
                    "fallbackNoRhymesFound \(input)",
                    "exclamationmark.magnifyingglass"
                )
            case .network:
                FallbackView(
                    "fallbackNoInternetConnection",
                    "network.slash"
                )
            case .generic:
                FallbackView(
                    "fallbackUnexpectedError",
                    "exclamationmark.triangle"
                )
            }
        }
    }
}

#Preview {
    SearchResultError(input: "test", searchError: .generic)
}
