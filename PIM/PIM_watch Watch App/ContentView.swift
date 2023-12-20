//
//  ContentView.swift
//  PIM_watch Watch App
//
//  Created by 신정연 on 12/13/23.
//

import Foundation
import SwiftUI
import WatchConnectivity

struct ShakeEffect: GeometryEffect {
    var angle: CGFloat = 5  // 회전 각도 (도 단위)
        var shakesPerUnit = 3   // 단위당 흔들림 횟수
        var animatableData: CGFloat

        func effectValue(size: CGSize) -> ProjectionTransform {
            let rotationAngle = (angle / 360 * .pi * 2) * sin(animatableData * .pi * CGFloat(shakesPerUnit))
            return ProjectionTransform(CGAffineTransform(rotationAngle: rotationAngle))
        }
}


struct ContentView: View {
    @ObservedObject var pillStatusObserver: PillStatusObserver
    @State private var isPillEaten: Bool = false
    @State private var shakeAttempts: Int = 0
    
    var body: some View {
        VStack {
            imageForPillStatus()
                .resizable()
                .scaledToFit()
                .padding(.bottom, 13)
                .modifier(ShakeEffect(animatableData: CGFloat(shakeAttempts))) // ShakeEffect 적용
                .animation(.easeInOut(duration: 1))
            
            
            Spacer()
            
            if !isPillEaten {
                PIMGreenButton(title: "오늘의 약을 먹었어요", action: {
                    updatePillStatus(true)
                    shakeImage()
                })
            } else {
                PIMStrokeButton(title: "약 복용을 취소할게요", action: {
                    updatePillStatus(false)
                    shakeImage()
                })
            }
        }
        .onAppear {
            isPillEaten = pillStatusObserver.isPillEaten
        }
    }
    
    private func shakeImage() {
        withAnimation(.default) {
            shakeAttempts += 1 // 흔들림 횟수 증가
        }
    }
    
    
    
    private func imageForPillStatus() -> Image {
        if isPillEaten {
            return Image("happyPimi")
        } else {
            return Image("sadPimi")
        }
    }
    
    private func updatePillStatus(_ status: Bool) {
        isPillEaten = status
        pillStatusObserver.isPillEaten = status
        sendPillStatusToiOS(status)
    }
    
    private func sendPillStatusToiOS(_ status: Bool) {
        // WatchConnectivity를 사용하여 iOS에 상태 업데이트 보내기
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["PillEaten": status], replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
            print("Watch App: Sent PillEaten status (\(status)) to iOS App")
        }
    }
}

// 약 복용 상태를 관찰하는 클래스
class PillStatusObserver: ObservableObject {
    // 약 복용 상태를 공개적으로 발표
    @Published var isPillEaten: Bool = false {
        didSet {
            // 약 복용 상태가 변경될 때마다 UserDefaults에 저장
            savePillStatus()
        }
    }
    
    init() {
        // 초기화 시점에 UserDefaults에서 현재 상태를 로드
        isPillEaten = getCurrentPillStatus()
    }
    
    private func getCurrentPillStatus() -> Bool {
        // 현재 날짜에 대한 문자열 키를 생성
        let currentDateStr = getCurrentDateString()
        // UserDefaults에서 해당 키에 저장된 값을 반환
        return UserDefaults.standard.bool(forKey: currentDateStr)
    }
    
    private func savePillStatus() {
        // 현재 날짜에 대한 문자열 키를 생성
        let currentDateStr = getCurrentDateString()
        // UserDefaults에 약 복용 상태 저장
        UserDefaults.standard.set(isPillEaten, forKey: currentDateStr)
    }
    
    private func getCurrentDateString() -> String {
        // DateFormatter를 사용하여 현재 날짜를 문자열로 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // 예: "2023-09-27"
        return formatter.string(from: Date())
    }
}
