//
//  OnboardingView1.swift
//  PIM
//
//  Created by 신정연 on 2023/09/22.
//

import SwiftUI

struct OnboardingView1: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isPillExist : Bool = false
    @State private var isYesButtonClicked : Bool = false
    @State private var isNoButtonClicked : Bool = false
    @State private var isNextButtonActive : Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.black)
                        .font(.pretendard(.regular, size: 24))
                }
                .padding(.leading, 15)
                Spacer()
                Text("시작하기")
                    .font(.pretendard(.bold, size: 18))
                    .frame(alignment: .center)
                    .padding(.trailing, 30)
                Spacer()
            }
            .padding(.top, 10)
            ProgressView(value: 20, total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .pimGreen))
                .padding(.bottom, 40)
            Text("현재 복용중인 약이 있나요?")
                .font(.pretendard(.bold, size: 24))
                .padding(.bottom, 5)
            Spacer()
            Image("character_onboarding_big")
                .resizable()
                .frame(width: 200, height: 200)
                .padding(.bottom, 50)
            Button {
                isPillExist = true
                isYesButtonClicked.toggle()
                isNoButtonClicked = false
            } label: {
                ZStack {
                    if(isYesButtonClicked){
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
                          .background(.white)
                          .cornerRadius(16)
                          .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .inset(by: 1)
                                .stroke(
                                    RadialGradient(
                                        gradient: Gradient(stops: [
                                            Gradient.Stop(color: .gradientGreen, location: 0),
                                            Gradient.Stop(color: .pimGreen, location: 1)
                                        ]),
                                        center: .leading,
                                        startRadius: 0,
                                        endRadius: 300
                                    ),
                                    lineWidth: 2
                                )
                          )
                    }
                    else{
                        Rectangle()
                            .foregroundColor(.lightGray)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
                            .cornerRadius(16)
                    }
                    Text("네, 있어요")
                        .foregroundColor(isYesButtonClicked ? .black : .gray)
                        .font(.pretendard(.bold, size: 18))
                }
            }
            .padding(.bottom, 10)
            Button {
                isPillExist = true
                isNoButtonClicked.toggle()
                isYesButtonClicked = false
            } label: {
                ZStack {
                    if(isNoButtonClicked){
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
                          .background(.white)
                          .cornerRadius(16)
                          .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .inset(by: 1)
                                .stroke(
                                    RadialGradient(
                                        gradient: Gradient(stops: [
                                            Gradient.Stop(color: .gradientGreen, location: 0),
                                            Gradient.Stop(color: .pimGreen, location: 1)
                                        ]),
                                        center: .leading,
                                        startRadius: 0,
                                        endRadius: 300
                                    ),
                                    lineWidth: 2
                                )
                          )
                    }
                    else{
                        Rectangle()
                            .foregroundColor(.lightGray)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
                            .cornerRadius(16)
                    }
                    Text("아니오, 없어요")
                        .foregroundColor(isNoButtonClicked ? .black : .gray)
                        .font(.pretendard(.bold, size: 18))
                }
            }
            .padding(.bottom, 15)
            Spacer()

            NavigationLink(destination: OnboardingView2()) {
                Text("선택했어요")
                    .font(.pretendard(.bold, size: 20))
                    .foregroundColor(Color.black)
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.top, 40)
            .padding(.bottom, 10)
            .background(Color.pimGreen)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingView1_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView1()
    }
}
