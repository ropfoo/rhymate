import SwiftUI

@main
struct rhymateApp: App {
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .modelContainer(for: Composition.self)
        }
    }
}


