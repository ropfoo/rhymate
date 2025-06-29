import SwiftData
import Foundation

@Model
class Composition {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    @Relationship var collection: CompositionCollection?

    init(
        title: String,
        content: String,
        createdAt: Date,
        updatedAt: Date,
        collection: CompositionCollection? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.collection = collection
    }
}
