//
//  CustomStyle.swift
//  PIM
//
//  Created by 장수민 on 2023/09/23.
//

import SwiftUI

struct PIMGreenButton: ButtonStyle {
    let scaledAmount: CGFloat
       
       init(scaledAmount: CGFloat = 0.99) {
           self.scaledAmount = scaledAmount
       }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.pretendard(.bold, size: 18))
            .multilineTextAlignment(.center)
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .frame(height: 74)
            .background(
                RoundedRectangle(cornerRadius: 37.5)
                    .foregroundColor(.primaryGreen)
            )
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .brightness(configuration.isPressed ? 0.05 : 0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct PIMSmallGreenButton: ButtonStyle {
    let scaledAmount: CGFloat
       
       init(scaledAmount: CGFloat = 0.99) {
           self.scaledAmount = scaledAmount
       }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .foregroundColor(.white)
            .font(.pretendard(.bold, size: 18))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 49)
            .background(
                RoundedRectangle(cornerRadius: 37.5)
                    .foregroundColor(.primaryGreen)
            )
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .brightness(configuration.isPressed ? 0.05 : 0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct PIMStrokeButton: ButtonStyle {
    let scaledAmount: CGFloat
       
       init(scaledAmount: CGFloat = 0.99) {
           self.scaledAmount = scaledAmount
       }
    func makeBody (configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.buttonStrokeGreen)
            .font(.pretendard(.bold, size: 18))
            .multilineTextAlignment(.center)
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .frame(height: 74)
            .background(
                RoundedRectangle(cornerRadius: 37.5)
                    .stroke(Color.buttonStrokeGreen, lineWidth: 2)
                    .foregroundColor(.clear)
            )
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
      }
}

struct PIMSmallStrokeButton: ButtonStyle {
    let scaledAmount: CGFloat
       
       init(scaledAmount: CGFloat = 0.99) {
           self.scaledAmount = scaledAmount
       }
    func makeBody (configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .foregroundColor(.buttonStrokeGreen)
            .font(.pretendard(.bold, size: 18))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 49)
            .background(
                RoundedRectangle(cornerRadius: 37.5)
                    .stroke(Color.buttonStrokeGreen, lineWidth: 2)
                    .foregroundColor(.clear)
            )
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
      }
}

struct PIMCalendarButton: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .foregroundColor(.buttonStrokeGreen)
            configuration.label
                .foregroundColor(.buttonStrokeGreen)
                .font(.pretendard(.medium, size: 16))
        }
        .padding(8)
        .multilineTextAlignment(.center)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(configuration.isPressed ? Color.buttonStrokeGreen.opacity(0.1) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.buttonStrokeGreen, lineWidth: 1)
                )
        )
    }
}



struct OnboardingButton: ButtonStyle {
    let scaledAmount: CGFloat
       
       init(scaledAmount: CGFloat = 0.99) {
           self.scaledAmount = scaledAmount
       }
    func makeBody (configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical)
            .foregroundColor(.white)
            .font(.pretendard(.bold, size: 18))
            .multilineTextAlignment(.center)
            .frame(width: UIScreen.main.bounds.width)
            .frame(height: 100)
            .background(
                Rectangle()
                    .foregroundColor(.primaryGreen)
            )
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
      }
}
struct CustomStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VStack {
                Text("기본 버튼")
                    .font(.title)
                Button("오늘의 약을 복용했어요") {
                }.buttonStyle(PIMGreenButton())
                Button("약 복용을 취소할게요") {
                }.buttonStyle(PIMStrokeButton())
                
                Text("small 버튼")
                    .font(.title)
                HStack {
                    Button("닫기") {
                    }.buttonStyle(PIMSmallStrokeButton())
                        .padding(.trailing, 7)
                    Button("설정 완료하기") {
                    }.buttonStyle(PIMSmallGreenButton())
                        .padding(.leading, 7)
                }
            }
            .padding(.horizontal, 18)
            Button("시작하기") {
                
            }
            .buttonStyle(OnboardingButton())
            Button("92월 20일"){}.buttonStyle(PIMCalendarButton())
        }
    }
}

