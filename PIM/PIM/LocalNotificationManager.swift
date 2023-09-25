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
        requestPermission() // 알림 권한 요청
        addNotification(title: "PIM")
        schedule() // 알림 스케줄
        print("매니저: enableNotifications - scheduleNotifications")
    }
    
    // 알림 비활성화
    func disableNotifications() {
        // 알림을 취소합니다.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("매니저: disableNotifications")
    }
    
    // 알림 허용 관련
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                }
            }
        print("매니저: requestPermission")
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
        print("매니저: addNotification")
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
        
//        if let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//
//            // TimeZone을 한국 시간으로 설정
//            dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
//
//            let formattedTime = dateFormatter.string(from: selectedTime)
//            print("SelectedTime Value (Korean Time): \(formattedTime)")
//        } else {
//            print("SelectedTime Value is nil or not a Date")
//        }

        for notification in notifications {
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
            
            if let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {
                let calendar = Calendar.current
                let selectedHour = calendar.component(.hour, from: selectedTime)
                let selectedMinute = calendar.component(.minute, from: selectedTime)
                dateComponents.hour = selectedHour
                dateComponents.minute = selectedMinute
            }
            dateComponents.second = 0
            
            

            print("매니저: scheduleNotifications")
            
            // 정시 알림
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = UNNotificationSound.default
            content.subtitle = "약 먹을 시간이에요.💊"
            content.body = "먹었다고 체크하기"
            content.categoryIdentifier = "checkCategory"
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id:\(notification.id)")
            }
            
            // 1시간 후 알림
            dateComponents.minute! += 60;
            let after1HourContent = UNMutableNotificationContent()
            after1HourContent.title = "1시간이 지났어요."
            after1HourContent.sound = UNNotificationSound.default
            after1HourContent.subtitle = "괜찮아요. 지금 약을 먹으세요."
            after1HourContent.body = "먹었다고 체크하기"
            after1HourContent.categoryIdentifier = "checkCategory"
            
            let after1HourTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let after1HourRequest = UNNotificationRequest(identifier: notification.id
                                                           + "_1hour", content: after1HourContent, trigger: after1HourTrigger)
            
            UNUserNotificationCenter.current().add(after1HourRequest) { error in
                guard error == nil else { return }
                print("Scheduling 1 hour after notification with id:\(notification.id + "_5min")")
            }
        }
    }

}
