import SwiftData
import Foundation

@Model
class CompositionCollection {
    var name: String
    @Relationship var compositions: [Composition] = []
    
    init(name: String) {
        self.name = name
    }
}
