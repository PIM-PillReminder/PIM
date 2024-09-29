//
//  PillStatus.swift
//  PIM
//
//  Created by 장수민 on 9/8/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct PillStatus: CustomStringConvertible {
    var isPillEaten: Bool
    var pillDate: Date
    
    func toDictionary() -> [String: Any] {
        return [
            "isPillEaten": isPillEaten,
            "pillDate": Timestamp(date: pillDate)
        ]
    }
    
    // CustomStringConvertible 프로토콜을 구현하여 출력 형식 정의
    var description: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: pillDate)
        
        return "PillStatus(isPillEaten: \(isPillEaten), pillDate: \(dateString))"
    }
}
