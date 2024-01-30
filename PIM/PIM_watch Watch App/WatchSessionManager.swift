//
//  WatchSessionManager.swift
//  PIM_watch Watch App
//
//  Created by Madeline on 1/26/24.
//

import WatchConnectivity
import SwiftUI

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // WCSessionDelegate 메서드 구현
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        
//    }
//    func sessionDidDeactivate(_ session: WCSession) {
//        session.activate()
//    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { 
        
    }
}
