//
//  PIM_watchApp.swift
//  PIM_watch Watch App
//
//  Created by 신정연 on 12/13/23.
//

import SwiftUI
import WatchConnectivity

@main
struct PIM_watch_Watch_App: App {
    var pillStatusObserver = PillStatusObserver()
    
    init() {
        _ = WatchSessionManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(pillStatusObserver: pillStatusObserver)
        }
    }
}
