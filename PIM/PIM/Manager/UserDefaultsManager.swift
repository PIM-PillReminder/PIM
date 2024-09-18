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
    
    func savePillStatus(date: Date, isPillEaten: Bool) {
        var pillStatus = getPillStatus() // 기존 데이터 불러오기
        let dateKey = startOfDay(for: date) // 날짜별로 구분하기 위해 시작 시간을 저장
        
        // 날짜에 해당하는 약 복용 여부 저장
        pillStatus[dateKey] = isPillEaten
        
        // Dictionary를 UserDefaults에 저장
        if let encodedData = try? JSONEncoder().encode(pillStatus) {
            UserDefaults.standard.set(encodedData, forKey: pillEatenKey)
        }
    }
    
    func getPillStatus() -> [Date: Bool] {
        // UserDefaults에서 데이터를 가져와서 디코딩
        if let savedData = UserDefaults.standard.data(forKey: pillEatenKey),
           let decodedStatus = try? JSONDecoder().decode([Date: Bool].self, from: savedData) {
            return decodedStatus
        }
        return [:] // 값이 없을 경우 빈 배열 반환
    }
    
    private func startOfDay(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
}
