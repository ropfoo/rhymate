import SwiftData
import Foundation

@Model
class Composition {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String, content: String, createdAt: Date, updatedAt: Date) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
