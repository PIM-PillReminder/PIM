//
//  OnboardingView5.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct OnboardingView4: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var selectedTime: Date
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
                .padding(.top, 10)
                // TODO: 2차 업데이트 시 value: 80으로 변경
                ProgressView(value: 0, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .pimGreen))
                    .padding(.bottom, 30)
                Text("몇 시에 약을 먹나요?")
                    .font(.pretendard(.bold, size: 24))
                    .frame(alignment: .center)
                    .padding(.bottom, 5)
                Text("선택한 복용 시간을 바탕으로 알림이 울려요.")
                    .font(.pretendard(.regular, size: 18))
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
                Image("character_time")
                    .shadow(color: Color(red: 0, green: 0, blue: 0),
                            radius: 28,
                            x: 0,
                            y: 4)
                    .padding(.bottom, 10)
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: [.hourAndMinute]
                )
                .labelsHidden()
                .datePickerStyle(.wheel)
                .environment(\.locale, .init(identifier: "ko_KR"))
                .frame(width: UIScreen.main.bounds.width * 0.9)
//                .overlay(
//                    Text("\(selectedTime, formatter: DateFormatter())")
//                        .font(.pretendard(.bold, size: 18))
//                        .foregroundColor(.red)
//                )
                
                Spacer()
                
                NavigationLink(
                    destination: MainView().navigationBarHidden(true),
                    isActive: $isMainViewActive) {
                        EmptyView()
                    }
                
                Button(action: {
                    print("Selected time: \(selectedTime)")
                    let calendar = Calendar.current
                    _ = calendar.component(.hour, from: selectedTime)
                    _ = calendar.component(.minute, from: selectedTime)
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        if settings.authorizationStatus == .authorized {
                            notificationManager.addNotification(title: "PIM")
                            UserDefaults.standard.set(selectedTime, forKey: "SelectedTime")
                            notificationManager.schedule()
                            print("알림 예약 완료 : \(selectedTime)\n")
                        } else {
                            notificationManager.requestPermission()
                        }
                    }
                    isMainViewActive = true
                }) {
                    Text("선택했어요")
                        .font(.pretendard(.bold, size: 20))
                        .foregroundColor(Color.white)
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, 40)
                .padding(.bottom, 10)
                .background(Color.pimGreen)

//
//                NavigationLink(destination: MainView()) {
//                    Text("선택하기")
//                        .font(.pretendard(.bold, size: 20))
//                        .foregroundColor(Color.black)
//                }
//                .frame(width: UIScreen.main.bounds.width)
//                .padding(.top, 40)
//                .padding(.bottom, 10)
//                .background(Color.pimGreen)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    print("Selected time: \(selectedTime)")
//                    let calendar = Calendar.current
//                    _ = calendar.component(.hour, from: selectedTime)
//                    _ = calendar.component(.minute, from: selectedTime)
//                    // 요청한 알림 권한을 확인
//                    UNUserNotificationCenter.current().getNotificationSettings { settings in
//                        if settings.authorizationStatus == .authorized {
//                            notificationManager.addNotification(title: "PIM")
//                            UserDefaults.standard.set(selectedTime, forKey: "SelectedTime")
//                            notificationManager.schedule()
//                            print("알림 예약 완료 : \(selectedTime)\n")
//                        } else {
//                            // 알림 권한을 사용자에게 요청
//                            notificationManager.requestPermission()
//                        }
//                    }
//                }
//                    notificationManager.addNotification(title: "PIM")
//                    UserDefaults.standard.set(selectedTime, forKey: "SelectedTime")
//                    notificationManager.schedule()
//                    print("alert, at onboarding5: \(selectedTime)\n")
            }
                
        }
        .navigationBarBackButtonHidden(true)
    }
        
}

struct OnboardingView4_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView4(selectedTime: Date())
    }
}
