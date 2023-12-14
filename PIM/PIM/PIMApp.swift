//
//  PIMApp.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

@main
struct PIMApp: App {
    let persistenceController = PersistenceController.shared
//    @State private var selectedStrength: AlertStrength = AlertStrength.list[0]
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
}
