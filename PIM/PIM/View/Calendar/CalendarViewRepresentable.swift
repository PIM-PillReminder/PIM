//
//  CalendarViewRepresentable.swift
//  PIM
//
//  Created by Madeline on 2/23/24.
//

import SwiftUI
import UIKit

//struct CalendarViewRepresentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> CalendarViewController {
//        let viewController = CalendarViewController()
//        viewController.view.backgroundColor = UIColor(named: "BGWhite")
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
//        
//    }
//}

struct CalendarViewRepresentable: View {
    var body: some View {
        CalendarViewControllerWrapper()
            .edgesIgnoringSafeArea(.all)
    }
}

struct CalendarViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let calendarViewController = CalendarViewController()
        let hostingController = UIHostingController(rootView: Color(UIColor(named: "BGWhite") ?? .white))
        hostingController.view.backgroundColor = .clear
        
        calendarViewController.addChild(hostingController)
        calendarViewController.view.insertSubview(hostingController.view, at: 0)
        hostingController.view.frame = calendarViewController.view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: calendarViewController)
        
        return calendarViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
