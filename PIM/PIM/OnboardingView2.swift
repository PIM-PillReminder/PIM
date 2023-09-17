//
//  OnboardingView2.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct OnboardingView2: View {
    @State var isPillExist : Bool = false
    @State var isYesButtonClicked : Bool = false
    @State var isNoButtonClicked : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.black)
                            .font(.system(size: 24))
                            .fontWeight(.regular)
                    }
                    .padding(.leading, 15)
                    Spacer()
                    Text("당신의 일상에, 핌")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .frame(alignment: .center)
                        .padding(.trailing, 25)
                    Spacer()
                }
                ProgressView(value: 20, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    .padding(.bottom, 40)
//                    .onAppear {
//                        withAnimation(.linear(duration: 2)) { // 애니메이션 설정
//                            progressValue = 80
//                        }
//                    }
                Text("현재 복용중인 약이 있나요?")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
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
                        Image(isYesButtonClicked ? "button_selected" : "button_unselected")
                        Text("네, 있어요")
                            .foregroundColor(isYesButtonClicked ? .black : .gray)
                            .fontWeight(.bold)
                    }
                }
                .padding(.bottom, 10)
                Button {
                    isPillExist = true
                    isNoButtonClicked.toggle()
                    isYesButtonClicked = false
                } label: {
                    ZStack {
                        Image(isNoButtonClicked ? "button_selected" : "button_unselected")
                        Text("아니오, 없어요")
                            .foregroundColor(isNoButtonClicked ? .black : .gray)
                            .fontWeight(.bold)
                    }
                }
                .padding(.bottom, 15)
                Spacer()
                NavigationLink(destination: OnboardingView3()) {
                    Text("선택했어요")
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
        .navigationBarBackButtonHidden(true)
    }
        
}

struct OnboardingView2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView2()
    }
}
