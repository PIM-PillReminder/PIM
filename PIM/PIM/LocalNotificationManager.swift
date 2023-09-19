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
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    //we have permission!
                }
            }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date()) // 기본 값 (현재 시간) 가져옴

            if let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {
                let calendar = Calendar.current
                let selectedHour = calendar.component(.hour, from: selectedTime)
                let selectedMinute = calendar.component(.minute, from: selectedTime)
                dateComponents.hour = selectedHour
                dateComponents.minute = selectedMinute
            }

            dateComponents.second = 0 // 초를 0으로 설정합니다.

            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = UNNotificationSound.default
            content.subtitle = "약 먹을 시간이에요.💊"
            content.body = "먹었다고 체크하기"

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id:\(notification.id)")
            }
        }
    }

}
