import SwiftUI

@main
struct rhymateApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: Composition.self)
        }
    }
}


