//
//  MainViewModel.swift
//  PIM
//
//  Created by Madeline on 10/12/24.
//

import Foundation
import WatchConnectivity

class MainViewModel: ObservableObject {
    @Published var isPillEaten: Bool = false
    @Published var pillTakenTimeString: String = ""
    @Published var playLottie: Bool = true
    
    private let notificationManager = LocalNotificationManager()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    
    var currentDateString: String {
        dateFormatter.string(from: Date())
    }
    
    init() {
        updatePillStatus()
    }
    
    func updatePillStatus() {
        let today = Calendar.current.startOfDay(for: Date())
        isPillEaten = UserDefaultsManager.shared.getPillStatus()[today] ?? false
        updatePillTakenTimeString()
    }
    
    func togglePillStatus() {
        isPillEaten.toggle()
        let currentTime = isPillEaten ? Date() : nil
        updatePillStatus(isPillEaten, takenTime: currentTime)
        playLottie = true
        objectWillChange.send()
    }
    
    private func updatePillStatus(_ status: Bool, takenTime: Date?) {
        let today = Calendar.current.startOfDay(for: Date())
        if status {
            if let time = takenTime {
                UserDefaultsManager.shared.savePillTakenTime(date: time)
            }
            UserDefaultsManager.shared.savePillStatus(date: today, isPillEaten: true)
        } else {
            UserDefaultsManager.shared.removePillTakenTime(for: today)
            UserDefaultsManager.shared.savePillStatus(date: today, isPillEaten: false)
        }
        updatePillTakenTimeString()
        sendPillStatusToWatch(status)
    }
    
    private func updatePillTakenTimeString() {
        let today = Calendar.current.startOfDay(for: Date())
        if let pillTakenTime = UserDefaultsManager.shared.getPillTakenTime(for: today) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 a h시 m분"
            pillTakenTimeString = formatter.string(from: pillTakenTime) + "에 복용했어요"
        } else {
            pillTakenTimeString = ""
        }
    }
    
    func sendPillStatusToWatch(_ status: Bool) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["PillEaten": status], replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
            print("iOS App: Sent PillEaten status (\(status)) to Watch App")
        }
    }
    
    func fetchPillStatusFromWatch() {
        if WCSession.default.isReachable {
            print("Watch is reachable, requesting pill status.")
            WCSession.default.sendMessage(["RequestPillStatus": true], replyHandler: { response in
                DispatchQueue.main.async {
                    if let status = response["PillEaten"] as? Bool {
                        print("Received pill status from Watch: \(status)")
                        self.isPillEaten = status
                        self.updatePillStatus(status, takenTime: status ? Date() : nil)
                    } else {
                        print("Error: No pill status found in Watch response.")
                    }
                }
            }) { error in
                print("Error requesting pill status from Watch: \(error.localizedDescription)")
            }
        } else {
            print("Watch is not reachable.")
        }
    }
}
