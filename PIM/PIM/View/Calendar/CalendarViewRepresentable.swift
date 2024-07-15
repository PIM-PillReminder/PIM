//
//  CalendarViewRepresentable.swift
//  PIM
//
//  Created by Madeline on 2/23/24.
//

import SwiftUI
import UIKit

struct CalendarViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CalendarViewController {
        
        return CalendarViewController()
    }
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
        
    }
}
