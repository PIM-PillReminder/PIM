//
//  PillStatus.swift
//  PIM
//
//  Created by 장수민 on 9/8/24.
//

import Foundation

class PillStatus {
    var isPillEaten: Bool
    var pillDate: String
    
    init(isPillEaten: Bool, pillDate: String) {
        self.isPillEaten = isPillEaten
        self.pillDate = pillDate
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "isPillEaten": isPillEaten,
            "pillDate": pillDate
        ]
    }
}


