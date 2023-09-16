//
//  OnboardingView5.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct OnboardingView5: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var time = Date()
    
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
                ProgressView(value: 80, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    .padding(.bottom, 40)
                Text("몇 시에 약을 먹나요?")
                    .frame(alignment: .center)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                Text("선택한 복용 시간을 바탕으로 알림이 울려요.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
                Image("character_onboarding_big")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 50)
                
                DatePicker(
                    "",
                    selection: $time,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.wheel)
                .environment(\.locale, .init(identifier: "ko_KR"))
                
                Spacer()
                NavigationLink(destination: MainView()) {
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

struct OnboardingView5_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView5()
    }
}
