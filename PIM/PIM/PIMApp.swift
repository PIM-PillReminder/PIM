//
//  PIMApp.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI
import UserNotifications
import WatchConnectivity
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 앱 첫 실행시 설치 날짜 저장
        if UserDefaults.standard.object(forKey: "app_install_date") == nil {
            UserDefaults.standard.set(Date(), forKey: "app_install_date")
            print("앱 첫 실행, 설치 날짜:", Date())
        }
        
        return true
    }
}

@main
struct PIMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    let notificationDelegate = NotificationDelegate()
    let pillStatusObserver = PillStatusObserver()
    let connectivityProvider = ConnectivityProvider()
    
    init() {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = notificationDelegate
        setupWatchConnectivity()
        Thread.sleep(forTimeInterval: 2)
    }
    
    @AppStorage("isOnboarding") var isOnboarding = true
    @StateObject var firestoreManager = FireStoreManager()
    
    var body: some Scene {
        WindowGroup {
            //            ContentView()
            //                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            Group {
                if isOnboarding {
                    OnboardingMainView()
                } else {
                    MainView()
                }
            }.environmentObject(firestoreManager)
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
    
    // MARK: WatchOS 연결
    private func setupWatchConnectivity() {
        connectivityProvider.pillStatusObserver = pillStatusObserver
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    let notificationManager = LocalNotificationManager()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "checkAction" {
            notificationManager.setUserHasTakenPill()
        }
        completionHandler()
    }
}

class ConnectivityProvider: NSObject, WCSessionDelegate {
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // watchOS에서 세션이 비활성화되었을 때의 처리
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // watchOS에서 세션이 다시 활성화될 때의 처리
        session.activate() // 필요한 경우 세션을 다시 활성화
    }
    
    var pillStatusObserver: PillStatusObserver?
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // 세션 활성화 완료 처리
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // 세션 활성화 완료 처리
    }
    
    // 메시지 수신 처리
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let status = message["PillEaten"] as? Bool {
            DispatchQueue.main.async {
                self.pillStatusObserver?.isPillEaten = status
                print("Received PillEaten status from watchOS: \(status)")
            }
            print("iOS App: Received PillEaten status (\(status)) from Watch App")
        }
    }
}
