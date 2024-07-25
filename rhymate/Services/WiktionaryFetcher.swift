import Foundation


struct WiktionaryFetcher {
    private let fetcher: Fetcher
    let baseUrlDefinition = WIKTIONARY_API_URL.appendingPathComponent("/definition")
    
    init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default
    ) {
        self.fetcher = Fetcher(configuration: configuration)
    }
    
   private func flattenDefinitionsToHTMLStrings(
        definitionResponse: WiktionaryDefinitionResponse,
        language: String
    ) -> [String] {
        var definitions: [String] = []
        guard let usageDescriptions = definitionResponse[language] else { return [] }
        for description in usageDescriptions {
            for definition in description.definitions {
                definitions.append(definition.definition)
            }
        }
        return definitions
    }
    
    func getDefinitions(forWord: String) async throws -> [String] {
        // fetch data from wiktionary
        let url = baseUrlDefinition.appendingPathComponent("/\(forWord)")
        if let definitionResponse: WiktionaryDefinitionResponse = try await fetcher.get(url) {
            let definitions = flattenDefinitionsToHTMLStrings(definitionResponse: definitionResponse, language: "en")
            return definitions
        }
        return []
    }
    
    
}
