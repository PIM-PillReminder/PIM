//
//  OnboardingView5.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct OnboardingView4: View {
    
    @Environment(\.presentationMode) var presentationMode

    @Binding var selectedTime: Date
    @State private var isMainViewActive = false
    let notificationManager = LocalNotificationManager()
    
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
                ProgressView(value: 80, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .pimGreen))
                    .padding(.bottom, 40)
                Text("몇 시에 약을 먹나요?")
                    .font(.pretendard(.bold, size: 24))
                    .frame(alignment: .center)
                    .padding(.bottom, 5)
                Text("선택한 복용 시간을 바탕으로 알림이 울려요.")
                    .font(.pretendard(.regular, size: 18))
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
                Image("character_onboarding_big")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 50)
                
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.wheel)
                .environment(\.locale, .init(identifier: "ko_KR"))
                .onChange(of: selectedTime) { newValue in
                    print("Selected time changed to \(newValue)")
                }
                
                Spacer()
//                NavigationLink(destination: MainView()) {
//                    Text("선택했어요")
//                        .font(.system(size: 20))
//                        .fontWeight(.bold)
//                        .foregroundColor(Color.black)
//                }
//                .frame(width: UIScreen.main.bounds.width)
//                .padding(.top, 40)
//                .padding(.bottom, 10)
//                .background(Color.gray)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    print("Selected time: \(selectedTime)")
//                    let calendar = Calendar.current
//                    let hour = calendar.component(.hour, from: selectedTime)
//                    let minute = calendar.component(.minute, from: selectedTime)
//                    let selectedTimeString = "\(hour):\(minute)"
//                    notificationManager.addNotification(title: "약 먹을 시간: \(selectedTimeString)")
//                    UserDefaults.standard.set(selectedTime, forKey: "SelectedTime") // 사용자가 선택한 시간을 UserDefaults에 저장
//                    notificationManager.schedule()
//                    print("alert, at onboarding5: \(selectedTime)\n")
//                }
                
                NavigationLink(
                    destination: MainView().navigationBarHidden(true),
                    isActive: $isMainViewActive) {
                    EmptyView()
                }
                Button(action: {
                    print("Button tapped")
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: selectedTime)
                    let minute = calendar.component(.minute, from: selectedTime)
                    let selectedTimeString = "\(hour):\(minute)"
                    notificationManager.addNotification(title: "PIM")
                    UserDefaults.standard.set(selectedTime, forKey: "SelectedTime")
                    notificationManager.schedule()
                    print("alert, at onboarding5: \(selectedTime)\n")
                    isMainViewActive = true
                }) {
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

struct OnboardingView4_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView4(selectedTime: .constant(Date()))
    }
}
