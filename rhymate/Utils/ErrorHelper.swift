struct ErrorHelper {
    func getSearchError(error: Error) -> SearchError {
        print(error)
        switch error._code {
        case -1009:
            return .network
        default:
            return .generic
        }
    }
}
