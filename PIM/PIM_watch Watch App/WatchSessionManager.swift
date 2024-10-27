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
    
    // ApplicationContext 변경 감지
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Watch: Received new application context:", applicationContext)
        handleApplicationContext(applicationContext)
    }
    
    private func handleApplicationContext(_ context: [String: Any]) {
        DispatchQueue.main.async {
            if let pillEaten = context["PillEaten"] as? Bool {
                print("Watch: Updating pill status from context to:", pillEaten)
                self.isPillEaten = pillEaten
                if let timeString = context["PillTakenTime"] as? String,
                   let pillTakenTime = ISO8601DateFormatter().date(from: timeString) {
                    self.pillTakenTime = pillTakenTime
                    print("Watch: Updated pill taken time to:", pillTakenTime)
                }
                self.savePillStatus()
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch: Session activation completed with state:", activationState.rawValue)
        if activationState == .activated {
            DispatchQueue.main.async {
                // 활성화 직후 현재 ApplicationContext 확인
                let context = session.applicationContext
                print("Watch: Current application context:", context)
                if !context.isEmpty {
                    self.handleApplicationContext(context)
                }
            }
        }
    }
    
    // 초기 상태 요청 함수
    private func requestInitialStatus() {
        
        print("Watch: Requesting initial status from iOS")
        print("Watch: Session reachable? \(WCSession.default.isReachable)")
        
        WCSession.default.sendMessage(
            ["RequestCurrentStatus": true],
            replyHandler: { response in
                print("Watch: Received response from iOS:", response)
                DispatchQueue.main.async {
                    if let pillEaten = response["PillEaten"] as? Bool {
                        print("Watch: Updating status to pillEaten: \(pillEaten)")
                        self.isPillEaten = pillEaten
                        if let timeString = response["PillTakenTime"] as? String,
                           let pillTakenTime = ISO8601DateFormatter().date(from: timeString) {
                            self.pillTakenTime = pillTakenTime
                            print("Watch: Updated pill taken time to: \(pillTakenTime)")
                            
                        }
                        self.savePillStatus()
                    }
                }
            },
            errorHandler: { error in
                print("Error requesting status: \(error.localizedDescription)")
            }
        )
    }
    
    // 기본 iOS와의 통신 - 일반 메시지 수신
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
    
    // 응답이 필요한 메시지 수신
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["RequestCurrentStatus"] as? Bool == true {
            var response: [String: Any] = [
                "PillEaten": isPillEaten
            ]
            if let time = pillTakenTime {
                response["PillTakenTime"] = ISO8601DateFormatter().string(from: time)
            }
            DispatchQueue.main.async {
                replyHandler(response)
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
    
    func savePillStatus() {
        UserDefaults.standard.set(isPillEaten, forKey: "isPillEaten")
        if let time = pillTakenTime {
            UserDefaults.standard.set(time, forKey: "pillTakenTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "pillTakenTime")
        }
    }
    
    func loadPillStatus() {
        print("Watch: Loading pill status")
        // 먼저 ApplicationContext 확인
        let context = WCSession.default.applicationContext
        if !context.isEmpty {
            print("Watch: Found application context, updating status")
            handleApplicationContext(context)
        } else {
            // ApplicationContext가 없는 경우에만 로컬 데이터 사용
            print("Watch: No application context, using local data")
            isPillEaten = UserDefaults.standard.bool(forKey: "isPillEaten")
            pillTakenTime = UserDefaults.standard.object(forKey: "pillTakenTime") as? Date
        }
    }
}
