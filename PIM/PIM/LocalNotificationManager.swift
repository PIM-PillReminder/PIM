//
//  LocalNotificationManager.swift
//  PIM
//
//  Created by 신정연 on 2023/09/18.
//

import Foundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    // 알림 활성화
    func enableNotifications() {
        requestPermission()
        addNotification(title: "PIM")
        schedule()
    }
    
    public func disableNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // 알림 권한 요청
    public func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Permission granted!")
                }
            }
    }
    
    public func addNotification(title: String) {
        let notification = Notification(id: UUID().uuidString, title: title)
        notifications.append(notification)
    }
    
    public func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                if let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {
                    self.scheduleNotification(for: selectedTime)
                }
            default:
                break
            }
        }
    }
    
    private func scheduleNotification(for selectedTime: Date) {
        for notification in notifications {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = UNNotificationSound.default
            content.body = "먹었다고 체크하기"
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
            }
        }
    }
}
