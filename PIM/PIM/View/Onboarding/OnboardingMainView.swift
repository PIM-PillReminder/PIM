//
//  OnboardingView1.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct OnboardingMainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("반가워요!")
                    .font(.pretendard(.bold, size: 24))
                    .padding(.bottom, 10)
                Text("당신의 피임약 관리를\npim이 도와줄게요.")
                    .font(.pretendard(.regular, size: 16))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                Spacer()
                Image("character_shining")
                    .padding(.bottom, 50)
                    .shadow(color: Color(red: 0.5, green: 0.5, blue: 0.5)
                        .opacity(0.25),
                            radius: 20,
                            x: 0,
                            y: 6)
                
                Text("pim을 더 잘 이용하기 위해\n몇가지 질문에 답이 필요해요.")
                    .font(.pretendard(.regular, size: 16))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                Spacer()
                // TODO: 2차 스프린트 업데이트때 OnboardingView2로 수정
                NavigationLink(destination: OnboardingView4(selectedTime: Date())) {
                    Text("시작하기")
                        .font(.pretendard(.bold, size: 20))
                        .foregroundColor(Color.white)
                }
                .frame(width: UIScreen.main.bounds.width)
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
