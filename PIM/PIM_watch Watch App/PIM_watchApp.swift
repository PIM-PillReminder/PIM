//
//  PIM_watchApp.swift
//  PIM_watch Watch App
//
//  Created by 신정연 on 12/13/23.
//

import SwiftUI

@main
struct PIM_watch_Watch_AppApp: App {
    
    var pillStatusObserver = PillStatusObserver()
    
    var body: some Scene {
        WindowGroup {
            ContentView(pillStatusObserver: pillStatusObserver)
        }
    }
}
