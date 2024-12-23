//
//  MainViewModel.swift
//  PIM
//
//  Created by Madeline on 10/12/24.
//

import Foundation
import WatchConnectivity

class MainViewModel: NSObject, ObservableObject {
    @Published var isPillEaten: Bool = false
    @Published var pillTakenTime: Date?
    @Published var playLottie: Bool = true
    @Published var pillTakenTimeString: String = ""
    
    private let notificationManager = LocalNotificationManager()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    
    var currentDateString: String {
        dateFormatter.string(from: Date())
    }
    
    override init() {
        super.init()
        setupWCSession()
        loadPillStatus()
    }
    
    func loadPillStatus() {
        let today = Calendar.current.startOfDay(for: Date())
        isPillEaten = UserDefaultsManager.shared.getPillStatus()[today] ?? false
        pillTakenTime = UserDefaultsManager.shared.getPillTakenTime(for: today)
        updatePillTakenTimeString()
    }
    
    private func setupWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            // 이전 ApplicationContext 복구
            if let context = session.receivedApplicationContext as? [String: Any],
               let pillEaten = context["PillEaten"] as? Bool {
                self.isPillEaten = pillEaten
                if let timeString = context["PillTakenTime"] as? String,
                   let pillTakenTime = ISO8601DateFormatter().date(from: timeString) {
                    self.updatePillStatus(pillEaten, takenTime: pillTakenTime)
                }
            }
        }
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
    
    func updatePillStatus(_ status: Bool, takenTime: Date?) {
        isPillEaten = status
        pillTakenTime = takenTime
        
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
        sendPillStatusToWatch(status, time: takenTime)
        updateApplicationContext()  // ApplicationContext 업데이트 추가
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
    
    // sendPillStatusToWatch 함수 수정
    func sendPillStatusToWatch(_ status: Bool, time: Date?) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession is not activated")
            return
        }
        
        var message: [String: Any] = ["PillEaten": status]
        if let time = time {
            message["PillTakenTime"] = ISO8601DateFormatter().string(from: time)
        }
        
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: { response in
                print("Successfully sent message to watch: \(response)")
            }) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
        } else {
            // 워치에 즉시 전송할 수 없는 경우 ApplicationContext 업데이트
            updateApplicationContext()
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
                        if let timeString = response["PillTakenTime"] as? String,
                           let pillTakenTime = ISO8601DateFormatter().date(from: timeString) {
                            self.updatePillStatus(status, takenTime: pillTakenTime)
                        } else {
                            self.updatePillStatus(status, takenTime: status ? Date() : nil)
                        }
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
    
    // ApplicationContext 업데이트 함수
    private func updateApplicationContext() {
        var context: [String: Any] = ["PillEaten": isPillEaten]
        if let time = pillTakenTime {
            context["PillTakenTime"] = ISO8601DateFormatter().string(from: time)
        }
        
        do {
            try WCSession.default.updateApplicationContext(context)
            print("iOS: Updated application context - isPillEaten: \(isPillEaten)")
            if let time = pillTakenTime {
                print("iOS: Updated application context - pillTakenTime: \(time)")
            }
        } catch {
            print("iOS: Failed to update application context:", error)
        }
    }
}

extension MainViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        
        switch activationState {
        case .activated:
            print("WCSession is activated")
            // 세션 활성화 직후 워치와 초기 동기화
            fetchPillStatusFromWatch()
            // 현재 상태를 ApplicationContext에 업데이트
            updateApplicationContext()
        case .inactive:
            print("WCSession is inactive")
        case .notActivated:
            print("WCSession is not activated")
        @unknown default:
            print("WCSession is in unknown state")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
        // 현재 상태 저장
        let context = ["PillEaten": isPillEaten]
        do {
            try session.updateApplicationContext(context)
        } catch {
            print("Failed to update context on session inactive: \(error)")
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // 세션 비활성화 후 처리
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let pillEaten = message["PillEaten"] as? Bool {
                if let timeString = message["PillTakenTime"] as? String,
                   let pillTakenTime = ISO8601DateFormatter().date(from: timeString) {
                    self.updatePillStatus(pillEaten, takenTime: pillTakenTime)
                } else {
                    self.updatePillStatus(pillEaten, takenTime: pillEaten ? Date() : nil)
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("iOS: Received application context update:", applicationContext)
        DispatchQueue.main.async {
            if let pillEaten = applicationContext["PillEaten"] as? Bool {
                if let timeString = applicationContext["PillTakenTime"] as? String,
                   let pillTakenTime = ISO8601DateFormatter().date(from: timeString) {
                    self.updatePillStatus(pillEaten, takenTime: pillTakenTime)
                } else {
                    self.updatePillStatus(pillEaten, takenTime: pillEaten ? Date() : nil)
                }
            }
        }
    }
}
