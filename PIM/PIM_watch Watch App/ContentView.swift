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
    var angle: CGFloat = 10
    var shakesPerUnit = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let rotationAngle = (angle / 360 * .pi * 2) * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        let translation = CGAffineTransform(translationX: -size.width / 2, y: -size.height / 2)
        let rotation = CGAffineTransform(rotationAngle: rotationAngle)
        
        let inverseTranslation = CGAffineTransform(translationX: size.width / 2, y: size.height / 2)
        
        return ProjectionTransform(translation.concatenating(rotation).concatenating(inverseTranslation))
    }
    
}

struct ContentView: View {
    @ObservedObject var pillStatusObserver: PillStatusObserver
    @State private var isPillEaten: Bool = false
    @State private var shakeAttempts: Int = 0
    @State private var yOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            
            Text(!isPillEaten ? "오늘의 약을 아직 안 먹었어요" : "약 먹기 완료! 내일 만나요!")
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundStyle(Color.green04)
                .padding(.bottom, 10)
            
            Spacer()
            
            imageForPillStatus()
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.bottom, 13)
                .offset(y: yOffset)
                .modifier(ShakeEffect(animatableData: CGFloat(shakeAttempts)))
            
            Spacer()
            
            if !isPillEaten {
                PIMGreenButton(title: "오늘의 약을 먹었어요", action: {
                    updatePillStatus(true)
                    shakeImage()
                })
            } else {
                PIMStrokeButton(title: "앗! 잘못 눌렀어요", action: {
                    updatePillStatus(false)
                    moveImageDownAndUp()
                })
            }
        }
        .background(Color.white)
        .onAppear {
            isPillEaten = pillStatusObserver.isPillEaten
        }
    }
    
    // MARK: 약 먹었어요 애니메이션
    private func shakeImage() {
        withAnimation(.easeInOut(duration: 1.5)) {
            shakeAttempts += 1
        }
    }
    
    // MARK: 앗 잘못 눌렀어요 애니메이션
    private func moveImageDownAndUp() {
        withAnimation(.easeInOut(duration: 1.0)) {
            yOffset = 5  // 아래로 이동
        }
        withAnimation(.easeInOut(duration: 1.0).delay(1.0)) {
            yOffset = 0  // 다시 위로 이동
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
