//
//  PillStatusObserver.swift
//  PIM
//
//  Created by Madeline on 10/12/24.
//

import Foundation
import WatchConnectivity

// MARK: isPillEaten Status 관찰
class PillStatusObserver: ObservableObject {
    @Published var isPillEaten: Bool = false {
        didSet {
            let currentDate = Calendar.current.startOfDay(for: Date())
            if UserDefaultsManager.shared.getPillStatus()[currentDate] != isPillEaten {
                print("Updating isPillEaten in didSet with value: \(isPillEaten)")
                
                if isPillEaten {
                    // 복용 여부가 true일 때만 복용 시간 확인
                    if let _ = UserDefaultsManager.shared.getPillTakenTime(for: currentDate) {
                        UserDefaultsManager.shared.savePillStatus(date: currentDate, isPillEaten: true)
                    } else {
                        // 복용 시간이 없으면 false로 변경
                        print("Pill taken time is nil, setting isPillEaten to false.")
                        isPillEaten = false
                        UserDefaultsManager.shared.savePillStatus(date: currentDate, isPillEaten: false)
                    }
                } else {
                    UserDefaultsManager.shared.savePillStatus(date: currentDate, isPillEaten: false)
                    UserDefaultsManager.shared.removePillTakenTime(for: currentDate)
                }
                
                sendPillStatusToWatch(isPillEaten)
                print("Final saved isPillEaten value: \(isPillEaten)")
            } else {
                print("isPillEaten did not change, skipping save.")
            }
        }
    }
    
    init() {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let savedStatus = UserDefaultsManager.shared.getPillStatus()[currentDate] ?? false
        // 초기화 시 중복 설정 방지
        if savedStatus != isPillEaten {
            print("Initializing PillStatusObserver: setting isPillEaten to \(savedStatus)")
            self.isPillEaten = savedStatus
        } else {
            print("Skipping initialization as the value matches UserDefaults.")
        }
    }
    
    private func getCurrentPillStatus() -> Bool {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let pillStatus = UserDefaultsManager.shared.getPillStatus()
        return pillStatus[currentDate] ?? false
    }
    
    // MARK: (POST) 워치로 데이터 보내기
    private func sendPillStatusToWatch(_ status: Bool) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["PillEaten": status], replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
            print("iOS App: Sent PillEaten status (\(status)) to Watch App")
        }
    }
}
