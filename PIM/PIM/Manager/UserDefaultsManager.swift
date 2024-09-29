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
    
    // 약 복용 상태와 복용 시간을 저장하는 함수
    func savePillStatus(date: Date, isPillEaten: Bool) {
        var pillStatus = getPillStatus() // 기존 데이터 불러오기
        let dateKey = startOfDay(for: date) // 날짜를 '시작 시간'으로 구분
        
        // 날짜에 해당하는 약 복용 여부 저장
        pillStatus[dateKey] = isPillEaten
        
        // 약을 먹었을 경우 복용 시간 저장
        if isPillEaten {
            UserDefaults.standard.set(Date(), forKey: "pillTakenTime_\(dateKey)") // 복용 시간 저장
        }
        
        // 상태를 UserDefaults에 저장
        if let encodedData = try? JSONEncoder().encode(pillStatus) {
            UserDefaults.standard.set(encodedData, forKey: pillEatenKey)
        }
    }
    
    // 저장된 약 복용 상태를 불러오는 함수
    func getPillStatus() -> [Date: Bool] {
        if let savedData = UserDefaults.standard.data(forKey: pillEatenKey),
           let decodedStatus = try? JSONDecoder().decode([Date: Bool].self, from: savedData) {
            return decodedStatus
        }
        return [:]
    }
    
    // 날짜의 시작 시간만 저장하도록 처리
    private func startOfDay(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
}
