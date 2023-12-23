//
//  OnboardingView1.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct OnboardingMainView: View {
    @State private var playLottie: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Text("반가워요!")
                    .font(.pretendard(.bold, size: 24))
                    .padding(.top, 50)
                    .padding(.bottom, 13)
                
                Text("당신의 피임약 관리를\npim이 도와줄게요.")
                    .font(.pretendard(.regular, size: 16))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                
                LottieView(jsonName: "helloPimi", loopMode: .repeat(10), playLottie: $playLottie)
                    
                Text("pim을 더 잘 이용하기 위해\n몇 가지 질문에 답이 필요해요.")
                    .font(.pretendard(.regular, size: 16))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.bottom, 80)
                
                // TODO: 2차 스프린트 업데이트때 OnboardingView2로 수정
                NavigationLink(destination: OnboardingView4(selectedTime: Date())) {
                    Text("시작하기")
                        .font(.pretendard(.bold, size: 20))
                        .foregroundColor(Color.white)
                        .padding(40)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.03)
                .padding(.top, 40)
                .padding(.bottom, 10)
                .background(Color.green03)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingMainView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingMainView()
    }
}
