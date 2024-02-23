//
//  CalendarViewRepresentable.swift
//  PIM
//
//  Created by Madeline on 2/23/24.
//

import SwiftUI
import UIKit

// UIKit의 ViewController를 SwiftUI에서 사용하기 위한 래퍼 구조체
struct CalendarViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CalendarViewController {
        
        return CalendarViewController()
    }
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
        
    }
}
