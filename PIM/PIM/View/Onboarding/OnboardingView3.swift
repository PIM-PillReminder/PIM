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
                ProgressView(value: 60, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .pimGreen))
                    .padding(.bottom, 40)
                Text("현재 복용중인 패키지를\n시작한 알려주세요")
                    .font(.pretendard(.bold, size: 24))
                    .frame(alignment: .center)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.bottom, 5)
                Text("복용기간을 바탕으로 휴약기가 자동으로 계산돼요.\n휴약기에는 알림이 울리지 않아요.")
                    .font(.pretendard(.regular, size: 16))
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
                        .font(.pretendard(.bold, size: 20))
                        .foregroundColor(Color.black)
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, 40)
                .padding(.bottom, 10)
                .background(Color.pimGreen)
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
