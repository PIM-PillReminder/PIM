//
//  WatchSessionManager.swift
//  PIM_watch Watch App
//
//  Created by Madeline on 1/26/24.
//

import WatchConnectivity
import SwiftUI

class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchSessionManager()
    @Published var isPillEaten: Bool = false
    @Published var pillTakenTime: Date?
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // 활성화 완료 처리
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let pillEaten = message["PillEaten"] as? Bool {
                self.isPillEaten = pillEaten
                if let timeString = message["PillTakenTime"] as? String,
                   let pillTakenTime = ISO8601DateFormatter().date(from: timeString) {
                    self.pillTakenTime = pillTakenTime
                } else if !pillEaten {
                    self.pillTakenTime = nil
                }
                self.savePillStatus()
            }
        }
    }
    
    func sendPillStatusToiOS(_ status: Bool, time: Date?) {
        var message: [String: Any] = ["PillEaten": status]
        if let time = time {
            message["PillTakenTime"] = ISO8601DateFormatter().string(from: time)
        }
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    private func savePillStatus() {
        UserDefaults.standard.set(isPillEaten, forKey: "isPillEaten")
        if let time = pillTakenTime {
            UserDefaults.standard.set(time, forKey: "pillTakenTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "pillTakenTime")
        }
    }
    
    func loadPillStatus() {
        isPillEaten = UserDefaults.standard.bool(forKey: "isPillEaten")
        pillTakenTime = UserDefaults.standard.object(forKey: "pillTakenTime") as? Date
    }
}
