//
//  OnboardingView4.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct OnboardingView3: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var date = Date()
    @State private var isNextButtonActive : Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
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
                ProgressView(value: 60, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    .padding(.bottom, 40)
                Text("현재 복용중인 패키지를\n시작한 알려주세요")
                    .frame(alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .lineSpacing(3)
                    .padding(.bottom, 5)
                Text("복용기간을 바탕으로 휴약기가 자동으로 계산돼요.\n휴약기에는 알림이 울리지 않아요.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.bottom, 40)
                Image("character_onboarding_big")
                    .resizable()
                    .frame(width: 150, height: 150)
                
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.wheel)
                .environment(\.locale, .init(identifier: "ko_KR"))
               
                Spacer()
                
                NavigationLink(destination: OnboardingView4(selectedTime: .constant(Date()))) {
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

struct OnboardingView3_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView3()
    }
}
