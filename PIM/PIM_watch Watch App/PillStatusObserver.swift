//
//  PillStatusObserver.swift
//  PIM_watch Watch App
//
//  Created by Madeline on 10/22/24.
//

import Foundation

// 약 복용 상태를 관찰하는 클래스
class PillStatusObserver: ObservableObject {
    // 약 복용 상태를 공개적으로 발표
    @Published var isPillEaten: Bool = false {
        didSet {
            // 약 복용 상태가 변경될 때마다 UserDefaults에 저장
            savePillStatus()
        }
    }
    
    init() {
        // 초기화 시점에 UserDefaults에서 현재 상태를 로드
        isPillEaten = getCurrentPillStatus()
    }
    
    private func getCurrentPillStatus() -> Bool {
        // 현재 날짜에 대한 문자열 키를 생성
        let currentDateStr = getCurrentDateString()
        // UserDefaults에서 해당 키에 저장된 값을 반환
        return UserDefaults.standard.bool(forKey: currentDateStr)
    }
    
    private func savePillStatus() {
        // 현재 날짜에 대한 문자열 키를 생성
        let currentDateStr = getCurrentDateString()
        // UserDefaults에 약 복용 상태 저장
        UserDefaults.standard.set(isPillEaten, forKey: currentDateStr)
    }
    
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
