import SwiftUI

@main
struct rhymateApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
                SearchView().tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                HistoryView().tabItem {
                    Label("History", systemImage: "clock")
                }
            }
        }
    }
}


