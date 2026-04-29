//
//  MaplyApp.swift
//  Maply
//
//  Created by Wilder Moreno on 18/04/26.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct MaplyApp: App {
    
    @AppStorage("selectedTheme") private var selectedThemeRawValue: String = ThemeOption.system.rawValue
    
    init() {
       UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
   }
    
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
    
    class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
        static let shared = NotificationDelegate()
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound])
        }
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
