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

/*
 💊 LocalNotificationManager 가이드
 
 아래 코드 먼저 선언해주고,
 let notificationManager = LocalNotificationManager()
 
 알림 허용/비허용의 기준이 되는 컴포넌트에 대한 액션에
 허용: notificationManager.disableNotifications()
 비허용: notificationManager.enableNotifications()
 호출해주심 됩니당
 (새 알림 만드는게 아니라, 기존 알림 끄고 키는거!)
 
 */

class LocalNotificationManager {
    var notifications = [Notification]()
    @Published var repeatingTimes: Int = 0

    // 알림 활성화
    func enableNotifications() {
        // 알림 권한 요청
        requestPermission()
        // 알림 추가
        addNotification(title: "PIM")
        // 알림 스케줄 -> 기준 시간은 유저디폴트 "SelectedTime"
        schedule()
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
        
        // 설정 -> 반복 횟수만큼 알림 추가 설정
        if repeatingTimes > 0 {
            isRepeating()
        }
    }
    
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                let currentTime = Date()
                // "SelectedTime" 값을 가져옵니다.
                if let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {
                    // "SelectedTime" 값이 있을 때만 TimeZone을 설정합니다.
                    var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
                    var calendar = Calendar.current
                    // 한국 시간
                    if let timeZone = TimeZone(identifier: "Asia/Seoul") {
                        calendar.timeZone = timeZone
                    }
                    
                    let selectedHour = calendar.component(.hour, from: selectedTime)
                    let selectedMinute = calendar.component(.minute, from: selectedTime)
                    dateComponents.hour = selectedHour
                    dateComponents.minute = selectedMinute
                    dateComponents.second = 0
                    
                    // 유저디폴트에 있는 "SelectedTime" 값이 한국 시간 기준 12시(자정)를 넘어가면 초기화합니다.
                    let KMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentTime)!
                    if selectedTime >= KMidnight && currentTime < KMidnight {
                        UserDefaults.standard.removeObject(forKey: "SelectedTime")
                        UserDefaults.standard.synchronize()
                        print("SelectedTime has been reset.")
                    }
                    self.scheduleNotifications()
                }
            default:
                break
            }
        }
    }
    
    func isRepeating() {
        for _ in notifications {
            for _ in 0..<repeatingTimes {
                // 새로운 알림 생성
                let newNotification = Notification(id: UUID().uuidString, title: "\(repeatingTimes)시간이 지났어요.")
                // 기존 알림 대신에 새로운 알림을 notifications 배열에 추가
                notifications.append(newNotification)
                
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
                
                var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
                
                if let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {
                    let calendar = Calendar.current
                    let selectedHour = calendar.component(.hour, from: selectedTime)
                    let selectedMinute = calendar.component(.minute, from: selectedTime)
                    dateComponents.hour = selectedHour
                    dateComponents.minute = selectedMinute
                }
                dateComponents.second = 0
                dateComponents.minute! += 60;
                let after1HourContent = UNMutableNotificationContent()
                after1HourContent.title = "\(repeatingTimes)시간이 지났어요."
                after1HourContent.sound = UNNotificationSound.default
                after1HourContent.subtitle = "괜찮아요. 지금 약을 먹으세요."
                after1HourContent.body = "먹었다고 체크하기"
                after1HourContent.categoryIdentifier = "checkCategory"
                
                let after1HourTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let after1HourRequest = UNNotificationRequest(identifier: newNotification.id + "_1hour", content: after1HourContent, trigger: after1HourTrigger)
                UNUserNotificationCenter.current().add(after1HourRequest) { error in
                    guard error == nil else { return }
                    print("Scheduling \(self.repeatingTimes) hour after notification with id:\(newNotification.id + "_1hour")")
                }
            }
        }
    }

    func scheduleNotifications() -> Void {

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

        }
    }

}
