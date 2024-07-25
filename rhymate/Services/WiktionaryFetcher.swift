import Foundation


struct WiktionaryFetcher {
    private let fetcher: Fetcher
    let baseUrlDefinition = WIKTIONARY_API_URL.appendingPathComponent("/definition")
    
    init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default
    ) {
        self.fetcher = Fetcher(configuration: configuration)
    }
    
    /// Convert wiktionary response to string array where every string is a definition div with all of its examples as list items.
    private func flattenDefinitionsToHTMLStrings(
        _ definitionResponse: WiktionaryDefinitionResponse,
        language: String
    ) -> [String] {
        var definitions: [String] = []
        guard let usageDescriptions = definitionResponse[language] else { return [] }
        for description in usageDescriptions {
            for definition in description.definitions {
                var examplesHtml: String = ""
                for example in definition.examples ?? [] {
                    examplesHtml.append("<li>\(example)</li>")
                }
                let definitionHtml: String =
                    "<div class=\"definition\"><p>\(definition.definition)</p><ul>\(examplesHtml)</ul></div>"
                
                definitions.append(definitionHtml)
            }
        }
        return definitions
    }
    
    /// Fetch wiktionary word definitons as a parsed array of html strings.
    func getDefinitions(forWord: String) async throws -> [String] {
        // fetch data from wiktionary
        let url = baseUrlDefinition.appendingPathComponent("/\(forWord)")
        if let definitionResponse: WiktionaryDefinitionResponse = try await fetcher.get(url) {
            let definitions = flattenDefinitionsToHTMLStrings(definitionResponse, language: "en")
            return definitions
        }
        return []
    }
}
