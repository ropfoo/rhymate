//
//  rhymateApp.swift
//  rhymate
//
//  Created by Robert Pasdziernik on 01.07.24.
//

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


