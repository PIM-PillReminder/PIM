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

    var Kmidnight: Date? {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date().addingTimeInterval(86400))
    }

    // 알림 활성화
    func enableNotifications() {
        // 알림 권한 요청
        requestPermission()
        // 중복 알림 제거
        if let nextMidnight = Kmidnight {
            removePendingNotificationRequests(date: nextMidnight)
        }
        // 알림 추가
        addNotification(title: "PIM")
        // 알림 스케줄 -> 기준 시간은 유저디폴트 "SelectedTime"
        schedule()
    }

    func disableNotifications() {
        // 알림을 취소합니다. - 자정 12시까지
        // 현재부터 자정까지 모든 알림을 비활성화합니다.
        if let nextMidnight = Kmidnight {
            removeNotificationsTill(date: nextMidnight)
        }
    }

    func removeNotificationsTill(date: Date) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("알림 요청 개수: \(requests.count)")

            // 이미 전송된 알림 제거
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            print("매니저: 알림 제거 했짜나removeAllDeliveredNotifications")
            self.removePendingNotificationRequests(date: date)
        }
    }
    // 중복된 알림 삭제
    func removePendingNotificationRequests(date: Date) {
        print("removeNotificationsTill 함수가 호출되었습니다.")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiersToRemove = requests.filter {
                if let triggerDate = ($0.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() {
                    return triggerDate <= date
                }
                return false
            }.map { $0.identifier }

            // 이미 전송된 알림 제거
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()

            // 특정 아이디의 알림 요청 제거
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        }
    }


    // 알림 허용 관련
    func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            if granted {
                print("매니저: requestPermission - Permission granted!")
            }
        }
        print("매니저: requestPermission")
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
        print("매니저: addNotification")

        //TODO:설정 -> 반복 횟수만큼 알림 추가 설정
//        if repeatingTimes > 0 {
//            addRepeatingNotifications(times: repeatingTimes)
//        }
    }

    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                // "SelectedTime" 값을 가져옵니다.
                if let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {

                    var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
                    let calendar = Calendar.current

                    let selectedHour = calendar.component(.hour, from: selectedTime)
                    let selectedMinute = calendar.component(.minute, from: selectedTime)
                    dateComponents.hour = selectedHour
                    dateComponents.minute = selectedMinute
                    dateComponents.second = 0

                    self.scheduleNotifications(for: selectedTime)
                }
            default:
                break
            }
        }
    }

    func scheduleNotifications(for selectedTime: Date) -> Void {

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

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id:\(notification.id)")
            }
        }
    }

//    func addRepeatingNotifications(times: Int) {
//        for _ in 0..<times {
//            // 새로운 알림 생성
//            let newNotification = Notification(id: UUID().uuidString, title: "\(repeatingTimes)시간이 지났어요.")
//            // 기존 알림 대신에 새로운 알림을 notifications 배열에 추가
//            notifications.append(newNotification)
//
//            //notification -> 꾹 누르면 noti action으로 버튼 생성
//            let checkAction = UNNotificationAction(
//                identifier: "checkAction",
//                title: "💊약 먹었다고 체크하기",
//                options: [.foreground])
//
//            let category = UNNotificationCategory(
//                identifier: "checkCategory",
//                actions: [checkAction],
//                intentIdentifiers: [],
//                options: [])
//
//            UNUserNotificationCenter.current().setNotificationCategories([category])
//            print("매니저: addNotification")
//
//            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
//
//            if let selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {
//                let calendar = Calendar.current
//                let selectedHour = calendar.component(.hour, from: selectedTime)
//                let selectedMinute = calendar.component(.minute, from: selectedTime)
//                dateComponents.hour = selectedHour
//                dateComponents.minute = selectedMinute
//            }
//            dateComponents.second = 0
//            if let currentSelectedTime = calendar.date(from: dateComponents) {
//                let oneHourLater = calendar.date(byAdding: .hour, value: 1, to: currentSelectedTime)
//                dateComponents = calendar.dateComponents([.hour, .minute], from: oneHourLater!)
//            }
//
//            let after1HourContent = UNMutableNotificationContent()
//            after1HourContent.title = "\(repeatingTimes)시간이 지났어요."
//            after1HourContent.sound = UNNotificationSound.default
//            after1HourContent.subtitle = "괜찮아요. 지금 약을 먹으세요."
//            after1HourContent.body = "먹었다고 체크하기"
//            after1HourContent.categoryIdentifier = "checkCategory"
//
//            let after1HourTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//            let after1HourRequest = UNNotificationRequest(identifier: newNotification.id + "_1hour", content: after1HourContent, trigger: after1HourTrigger)
//            UNUserNotificationCenter.current().add(after1HourRequest) { error in
//                guard error == nil else { return }
//                print("Scheduling \(self.repeatingTimes) hour after notification with id:\(newNotification.id + "_1hour")")
//            }
//        }
//    }

}

extension LocalNotificationManager {
    // 약을 먹었다는 버튼을 눌렀을 때 호출되는 함수
    func didTakeMedicine() {

//        let nextTriggerTime = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
//        self.scheduleNotifications(for: nextTriggerTime)

        // 오늘의 남아있는 알림들을 가져온다.
//        let remainingNotifications = getRemainingNotificationsForToday()

        // 오늘의 남아있는 알림들을 취소한다.
//        cancelRemainingNotifications(for: remainingNotifications)

        // 오늘의 남아있는 알림들을 다음날 동일한 시간에 스케줄링한다.
//        scheduleNotificationsForTomorrow(notifications: remainingNotifications)
    }

    func getRemainingNotificationsForToday() -> [Notification] {
        var remainingNotifications: [Notification] = []

        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                if let id = UUID(uuidString: request.identifier) {
                    remainingNotifications.append(Notification(id: request.identifier, title: "PIM"))
                }
            }
        }

        return remainingNotifications
    }

    func cancelRemainingNotifications(for notifications: [Notification]) {
        let identifiers = notifications.map { $0.id }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func scheduleNotificationsForTomorrow(notifications: [Notification]) {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        for notification in notifications {
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: tomorrow)
            dateComponents.second = 0

            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = UNNotificationSound.default
            content.subtitle = "약 먹을 시간이에요.💊"
            content.body = "먹었다고 체크하기"
            content.categoryIdentifier = "checkCategory"

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            // 알림이 한 번만 발송되도록 'repeats'를 false로 변경했습니다.
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification for 5 minutes later with id:\(notification.id)")
            }
        }
    }

}
