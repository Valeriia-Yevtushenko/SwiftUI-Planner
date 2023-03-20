//
//  NotificationService.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 13.09.2022.
//

import Foundation
import UserNotifications

class NotificationService: NSObject {
    private let center = UNUserNotificationCenter.current()
}

extension NotificationService {
    func registerNotifications() async throws {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
        center.delegate = self
    }
    
    func createNotification(title: String, body: String, date: Date) async throws -> String? {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        let timeInterval = date.timeIntervalSince(Date.now)
        
        guard timeInterval > 0 else {
            return nil
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
        return identifier
    }
    
    func removeNotification(_ id: String) {
        center.removeDeliveredNotifications(withIdentifiers: [id])
    }
    
    func notificationSettings() async -> NotificationSettingsStatus {
        let notificationSettings = await center.notificationSettings()
        
        switch notificationSettings.authorizationStatus {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        @unknown default:
            return .unknown
        }
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
