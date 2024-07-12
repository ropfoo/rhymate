import Foundation

protocol RhymeStorage {
    associatedtype T
    associatedtype B
    
    func mutate(_ type: Mutation, data: B, key: String) throws -> Void
    func get(word: String) -> T?
}
