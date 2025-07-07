import SwiftData
import Foundation

@Model
class Composition {
    var id: UUID
    var title: String
    var contentData: Data
    var createdAt: Date
    var updatedAt: Date
    @Relationship var collection: CompositionCollection?
    
    @Transient
    var content: NSAttributedString {
        get {
            (try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: contentData)) ?? NSAttributedString(string: "")
        }
        set {
            do {
                contentData = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
            } catch {
                print("Failed to archive NSAttributedString: \(error)")
                contentData = Data()
            }
        }
    }
    
    init(
        title: String,
        content: NSAttributedString,
        createdAt: Date,
        updatedAt: Date,
        collection: CompositionCollection? = nil
    ) {
        self.id = UUID()
        self.title = title
        do {
            contentData = try NSKeyedArchiver.archivedData(withRootObject: content, requiringSecureCoding: false)
        } catch {
            print("Failed to archive NSAttributedString: \(error)")
            contentData = Data()
        }
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.collection = collection
    }
}
