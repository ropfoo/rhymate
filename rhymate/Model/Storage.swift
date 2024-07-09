import Foundation

enum RhymeStorageMutation {
    case add
    case remove
}

protocol RhymeStorage {
    associatedtype T
    associatedtype B
    
    func mutate(type: RhymeStorageMutation, data: B, key: String) throws -> Void
    func get(word: String) -> T?
}
