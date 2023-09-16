//
//  OnboardingView1.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct OnboardingView1: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("반가워요!")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                Text("당신의 피임약 관리를 pim이 도와줄게요.\npim을 더 잘 이용하기 위해 몇가지 질문에 답이 필요해요.")
                    .frame(alignment: .center)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                Spacer()
                Image("character_onboarding_big")
                Spacer()
                NavigationLink(destination: OnboardingView2()) {
                    Text("시작하기")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, 40)
                .padding(.bottom, 10)
                .background(Color.gray)
            }
        }
    }
}

struct OnboardingView1_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView1()
    }
}
