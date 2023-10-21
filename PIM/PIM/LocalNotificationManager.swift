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
 
 아래 코드 먼저 선언해주고,(알림 매니저 인스턴스 생성)
 let notificationManager = LocalNotificationManager()
 
 알림 허용/비허용의 기준이 되는 컴포넌트에 대한 액션에
 허용: notificationManager.disableNotifications()
 -> SelectedTime 기반 알림 스케줄링
 비허용: notificationManager.enableNotifications()
 -> 현재시간부터 자정까지 알림 비활성화
 호출해주심 됩니당
 (새 알림 만드는게 아니라, 기존 알림 끄고 키는거!)
 
 */

class LocalNotificationManager {
    var notifications = [Notification]()
    //TODO: 설정 -> 알림 횟수 정한거 여기서 받아오기
    @Published var repeatingTimes: Int = 3
    
    var calendar: Calendar = {
        var cal = Calendar.current
        if let timeZone = TimeZone(identifier: "Asia/Seoul") {
            cal.timeZone = timeZone
        }
        return cal
    }()
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var timeUntilMidnight: TimeInterval {
        let midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date().addingTimeInterval(86400))
        let currentTime = Date()
        return midnight!.timeIntervalSince(currentTime)
    }
    
    // 약 먹었다고 체크하기를 클릭했을 때 호출되는 함수
    func userDidTakePill() {
        print("userDidTakePill")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilMidnight) {
            self.enableNotifications()
        }
    }
    
    // 알림 활성화
    func enableNotifications() {
        
        let currentDateStr = dateFormatter.string(from: Date())
        if let isPillEatenToday = UserDefaults.standard.object(forKey: currentDateStr) as? Bool, isPillEatenToday {
            // 약을 이미 복용했으면 함수를 종료
            return
        }
        // 알림 권한 요청
        requestPermission()
        // 알림 추가
        addNotification(title: "PIM")
        // 알림 스케줄 -> 기준 시간은 유저디폴트 "SelectedTime"
        schedule()
    }
    
    // 알림 권한 요청
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Permission granted!")
                }
            }
    }
    
    func addNotification(title: String) -> Void {
        let notification = Notification(id: UUID().uuidString, title: title)
        notifications.append(notification)
        
        //UNNotificationAction: notification -> 꾹 누르면 noti action으로 버튼 생성
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
                // "SelectedTime" 값을 가져옵니다.
                if let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {
                    self.scheduleNotifications(for: selectedTime)
                }
            default:
                break
            }
        }
    }
    
    func scheduleNotifications(for selectedTime: Date) -> Void {
        print("scheduleNotifications")
        for notification in notifications {
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
            dateComponents.second = 0
            
            // 정시 알림
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = UNNotificationSound.default
            content.subtitle = "약 먹을 시간이에요.💊"
            content.body = "먹었다고 체크하기"
            content.categoryIdentifier = "checkCategory"
            
            print("현재 시간: \(Date())") // 현재 시간 출력
            print("알림 예약 시간: \(dateComponents)") // 예약하려는 알림 시간 출력
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
            }
        }
        addRepeatingNotifications(times: repeatingTimes)
    }
    
    func addRepeatingNotifications(times: Int) {
        print("addRepeatingNotifications")
        guard let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date else { return }
        for i in 0..<times {
            let newNotification = Notification(id: UUID().uuidString, title: "\(i+1)시간이 지났어요.")
            var dateComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
            dateComponents.second = 0
            if let currentSelectedTime = calendar.date(from: dateComponents) {
                let oneHourLater = calendar.date(byAdding: .hour, value: i+1, to: currentSelectedTime)
                dateComponents = calendar.dateComponents([.hour, .minute], from: oneHourLater!)
            }
            
            let after1HourContent = UNMutableNotificationContent()
            after1HourContent.title = newNotification.title
            after1HourContent.sound = UNNotificationSound.default
            after1HourContent.subtitle = "괜찮아요. 지금 약을 먹으세요."
            after1HourContent.body = "먹었다고 체크하기"
            after1HourContent.categoryIdentifier = "checkCategory"
            
            let after1HourTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let after1HourRequest = UNNotificationRequest(identifier: newNotification.id, content: after1HourContent, trigger: after1HourTrigger)
            UNUserNotificationCenter.current().add(after1HourRequest) { error in
                guard error == nil else { return }
            }
        }
    }
    
    func getPendingNotificationTimes(completion: @escaping ([Date]) -> Void) {
        print("getPendingNotificationTimes")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let dates = requests.compactMap { request -> Date? in
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let date = trigger.nextTriggerDate() {
                    print("예정된 알림 시간: \(date)") // 예정된 알림을 출력합니다.
                    return date
                }
                return nil
            }
            completion(dates)
        }
    }

      
}
