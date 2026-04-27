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
    
    @AppStorage("selectedTheme") private var selectedThemeRawValue: String = ThemeOption.system.rawValue
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(currentTheme.colorScheme)
        }
        .modelContainer(for: [SavedLocationItem.self])
    }
    
    private var currentTheme: ThemeOption {
        ThemeOption(rawValue: selectedThemeRawValue) ?? .system
    }
}

/*
@main
struct MaplyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [SavedLocationItem.self])
    }
} */
