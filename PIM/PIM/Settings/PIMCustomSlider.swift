//
//  PIMCustomSlider.swift
//  PIM
//
//  Created by 장수민 on 2023/09/23.
//

import SwiftUI

struct PIMCustomSlider: View {
    // 알람 기능이랑 같이 해서 아래 숫자랑 같이 바꿀 수 있는 쪽으로 가는게...
    @State var value: Double = 0.0
    
    var body: some View {
        VStack {
            NotiSlider(value: $value)
                .frame(height: 22)
            
            HStack {
                Text("1번")
                Spacer()
                Text("3번")
                Spacer()
                Text("5번")
                
            }
            .font(.pretendard(.medium, size: 18))
        }
    }
}

struct PIMCustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        PIMCustomSlider()
    }
}

struct NotiSlider: View {
    @Binding var value: Double
    @State var lastCoordinateValue: CGFloat = 0.0
    
    // 스냅 지점을 변경
    let snapPoints: [Double] = [0.0, 0.5, 1.0]
    
    // 1, 3, 5 숫자를 관리하는 변수 -> 알람 횟수
    @State private var displayedNumber: Int = 1
    
    var body: some View {
        GeometryReader { gr in
            let thumbSize = gr.size.height
            let radius = gr.size.height * 0.5
            let minValue = gr.size.width * 0
            let maxValue = gr.size.width - thumbSize
            
            // 스냅된 값을 계산
            let snappedValue = snapToNearestPoint(self.value, in: snapPoints)
            
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: radius)
                        .foregroundColor(.lightGray)
                    HStack {
                        // 스냅된 값을 기반으로 표시 값을 설정
                        RoundedRectangle(cornerRadius: radius)
                            .foregroundColor(.green03)
                            .frame(width: (self.value * maxValue) + (thumbSize / 2))
                        
                        Spacer()
                    }
                }
                .frame(height: gr.size.height * 0.5)
                
                HStack {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.white)
                            .frame(width: thumbSize, height: thumbSize)
                            // 원의 위치를 스냅된 값에 따라 조정
                            .offset(x: snappedValue * (maxValue - minValue))
                            .shadow(radius: 4)
                        
                        Circle()
                            .foregroundColor(Color.green03)
                            .frame(width: thumbSize * 0.5, height: thumbSize * 0.5)
                            // 원의 위치를 스냅된 값에 따라 조정
                            .offset(x: snappedValue * (maxValue - minValue))
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { v in
                                if (abs(v.translation.width) < 0.1) {
                                    self.lastCoordinateValue = snappedValue
                                }
                                if v.translation.width > 0 {
                                    let newValue = min(maxValue, self.lastCoordinateValue + v.translation.width * (1.0 / (maxValue - minValue)))
                                    self.value = snapToNearestPoint(newValue, in: snapPoints) // 스냅 지점을 고려하여 값 설정
                                } else {
                                    let newValue = max(minValue, self.lastCoordinateValue + v.translation.width * (1.0 / (maxValue - minValue)))
                                    self.value = snapToNearestPoint(newValue, in: snapPoints) // 스냅 지점을 고려하여 값 설정
                                }
//                                self.displayedNumber = self.value == 1.0 ? 5 : Int(self.value * 5) + 1
                                // 0, 2, 4번으로 변환
                                self.displayedNumber = self.value == 0.0 ? 0 : Int(self.value * 2) * 2
                            }
                    )
                    Spacer()
                }
            }
        }
    }
    // 가장 가까운 고정 지점에 스냅하는 함수
    private func snapToNearestPoint(_ value: Double, in snapPoints: [Double]) -> Double {
        var closestPoint = snapPoints[0]
        var minDistance = abs(value - snapPoints[0])
        
        for point in snapPoints {
            let distance = abs(value - point)
            if distance < minDistance {
                minDistance = distance
                closestPoint = point
            }
        }
        
        return closestPoint
    }
}
