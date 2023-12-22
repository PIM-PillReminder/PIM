//
//  PIMApp.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI
import UserNotifications

@main
struct PIMApp: App {
    let persistenceController = PersistenceController.shared
    let notificationDelegate = NotificationDelegate()
    
    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }
  
  @AppStorage("isOnboarding") var isOnboarding = true
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
          if isOnboarding {
            OnboardingMainView()
          } else {
            MainView()
          }
        }
    }
    
    // UNUserNotificationCenterDelegate 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "checkAction" {
            let currentDateStr = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
            UserDefaults.standard.set(true, forKey: currentDateStr)
        }
        completionHandler()
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    let notificationManager = LocalNotificationManager()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "checkAction" {
            print("***")
            notificationManager.setUserHasTakenPill()
        }
        completionHandler()
    }
}
