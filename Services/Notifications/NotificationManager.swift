//
//  NotificationManager.swift
//  Maply
//
//  Created by Wilder Moreno on 28/04/26.
//

import Foundation
import UserNotifications

@MainActor
final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func getAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
    
    func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
    }
    
    func scheduleLocationSavedNotification(name: String, address: String) async {
        let status = await getAuthorizationStatus()
        guard status == .authorized || status == .provisional || status == .ephemeral else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Nueva dirección guardada"
        content.body = "\(name) · \(address)"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Error programando notificación: \(error.localizedDescription)")
        }
    }
}
