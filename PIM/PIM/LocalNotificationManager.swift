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
        let notification = Notification(id: UUID().uuidString, title: title)
        notifications.append(notification)
        
         //notification -> 꾹 누르면 noti action으로 버튼 생성
        
        let checkAction = UNNotificationAction(
        identifier: "checkAction",
        title: "💊약 먹었다고 체크하기",
        options: [.foreground])
        
        let category = UNNotificationCategory(
        identifier: "checkCategory",
        actions: [checkAction],
        intentIdentifiers: [],
        options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
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
            
            dateComponents.second = 0
            
            //정시 알림
            let content = UNMutableNotificationContent()
            content.title = notification.title
            //            content.sound = UNNotificationSound.default
            content.subtitle = "약 먹을 시간이에요.💊"
            content.body = "먹었다고 체크하기"
            content.categoryIdentifier = "checkCategory"
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id:\(notification.id)")
            }
            
            //5분 전 알림
            dateComponents.minute! -= 5;
            let before5MinutesContent = UNMutableNotificationContent()
            before5MinutesContent.title = "약을 먹을 시간이 얼마 남지 않았어요!"
            before5MinutesContent.sound = UNNotificationSound.default
            before5MinutesContent.subtitle = "약 먹을 시간이에요.💊"
            before5MinutesContent.body = "먹었다고 체크하기"
            before5MinutesContent.categoryIdentifier = "checkCategory"
            
            let before5MinutesTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let before5MinutesRequest = UNNotificationRequest(identifier: notification.id + "_5min", content: before5MinutesContent, trigger: before5MinutesTrigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling 5 minutes before notification with id:\(notification.id + "_5min")")
            }
            
            //1시간 후 알림
            dateComponents.minute! += 65;
            let after1HourContent = UNMutableNotificationContent()
            after1HourContent.title = "1시간이 지났어요."
            before5MinutesContent.sound = UNNotificationSound.default
            after1HourContent.subtitle = "괜찮아요. 지금 약을 먹으세요."
            after1HourContent.body = "먹었다고 체크하기"
            after1HourContent.categoryIdentifier = "checkCategory"
            
            let after1HourTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let after1HourRequest = UNNotificationRequest(identifier: notification.id
                                                           + "_1hour", content: after1HourContent, trigger: after1HourTrigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling 1 hour after notification with id:\(notification.id + "_5min")")
            }
        }
    }

}
