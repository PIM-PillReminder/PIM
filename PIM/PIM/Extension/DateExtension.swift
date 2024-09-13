//
//  File.swift
//  PIM
//
//  Created by 장수민 on 9/9/24.
//

import Foundation

extension Date {
    // 날짜를 "yyyy-MM-dd" 형식으로 포맷하는 함수
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
