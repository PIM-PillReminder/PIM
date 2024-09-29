//
//  UserDefaultsManager.swift
//  PIM
//
//  Created by Madeline on 9/18/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    private let pillEatenKey = "pillEatenStatus"
    
    // 약 복용 상태를 저장하는 함수
    func savePillStatus(date: Date, isPillEaten: Bool) {
        var pillStatus = getPillStatus()
        let dateKey = startOfDay(for: date)
        pillStatus[dateKey] = isPillEaten
        if let encodedData = try? JSONEncoder().encode(pillStatus) {
            UserDefaults.standard.set(encodedData, forKey: pillEatenKey)
        }
    }
    
    // 약 복용 시간을 저장하는 함수
    func savePillTakenTime(date: Date) {
        let dateKey = startOfDay(for: date)
        UserDefaults.standard.set(date, forKey: "pillTakenTime_\(dateKey)")
    }
    
    // 저장된 약 복용 상태를 불러오는 함수
    func getPillStatus() -> [Date: Bool] {
        if let savedData = UserDefaults.standard.data(forKey: pillEatenKey),
           let decodedStatus = try? JSONDecoder().decode([Date: Bool].self, from: savedData) {
            return decodedStatus
        }
        return [:]
    }
    
    // 저장된 약 복용 시간을 불러오는 함수
    func getPillTakenTime(for date: Date) -> Date? {
        let dateKey = startOfDay(for: date)
        return UserDefaults.standard.object(forKey: "pillTakenTime_\(dateKey)") as? Date
    }
    
    func removePillTakenTime(for date: Date) {
        let dateKey = startOfDay(for: date)
        UserDefaults.standard.removeObject(forKey: "pillTakenTime_\(dateKey)")
        savePillStatus(date: date, isPillEaten: false)
    }
    
    // 날짜의 시작 시간만 저장하도록 처리
    private func startOfDay(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
}
