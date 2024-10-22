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
    @ObservedObject var sessionManager = WatchSessionManager.shared
    @State private var shakeAttempts: Int = 0
    @State private var yOffset: CGFloat = 0
    
    // isPillEaten을 State 프로퍼티가 아닌 computed 프로퍼티로 변경
    private var isPillEaten: Bool {
        sessionManager.isPillEaten
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text(dateFormatter.string(from: Date()))
                    Spacer()
                }
                .padding(.top, hMargin())
                .padding(.horizontal)
                .ignoresSafeArea()
                
                Text(!isPillEaten ? "오늘 약을 먹었나요?" : "약 먹기 완료! 내일 만나요!")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.bottom)
                
                imageForPillStatus()
                    .resizable()
                    .frame(width: 87, height: 87)
                    .padding(.bottom, 13)
                    .offset(y: yOffset)
                    .modifier(ShakeEffect(animatableData: CGFloat(shakeAttempts)))
                
                if !isPillEaten {
                    PIMGreenButton(title: "네! 먹었어요", action: {
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
            .onAppear {
                print(WKInterfaceDevice.current().screenBounds.size.height)
                sessionManager.loadPillStatus()
            }
        }
    }
    
    private func shakeImage() {
        withAnimation(.easeInOut(duration: 1.5)) {
            shakeAttempts += 1
        }
    }
    
    private func moveImageDownAndUp() {
        withAnimation(.easeInOut(duration: 1.0)) {
            yOffset = 5
        }
        withAnimation(.easeInOut(duration: 1.0).delay(1.0)) {
            yOffset = 0
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
        let time = status ? Date() : nil
        sessionManager.sendPillStatusToiOS(status, time: time)
        sessionManager.isPillEaten = status
        sessionManager.pillTakenTime = time
    }
}

