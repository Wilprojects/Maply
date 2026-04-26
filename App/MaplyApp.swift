//
//  MaplyApp.swift
//  Maply
//
//  Created by Wilder Moreno on 18/04/26.
//

import SwiftUI
import SwiftData

@main
struct MaplyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [SavedLocationItem.self])
    }
}
