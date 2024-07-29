protocol RhymeStorage {
    associatedtype T
    associatedtype B
    
    func mutate(_ type: Mutation, key: String, _ data: B?) throws -> Void
    func get(word: String) -> T?
}
