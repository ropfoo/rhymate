
struct WiktionaryParsedExample: JSONable {
    let example: String?
    let translation: String?
}

struct WiktionaryDefinition: JSONable {
    let definition: String
    let examples: [String]?
    let parsedExamples: [WiktionaryParsedExample?]?
}

struct WiktionaryUsageDescription: JSONable {
    let partOfSpeech: String
    let language: String?
    let definitions: [WiktionaryDefinition]
}
    
typealias WiktionaryDefinitionResponse = [String: [WiktionaryUsageDescription]]

typealias WiktionaryWord = String
typealias WiktionaryDefinitions = [String]
typealias WiktionaryHistory = [WiktionaryWord: WiktionaryDefinitions]
