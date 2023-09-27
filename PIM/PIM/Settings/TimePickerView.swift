//
//  TimePickerView.swift
//  PIM
//
//  Created by 장수민 on 2023/09/27.
//

import SwiftUI

struct TimePickerView: View {
    // 설정 화면에 있는 피커랑 온보딩 피커를 통일하는 게 좋을 것 같아여...! 지금은 이렇게 해두고 나중에 하나의 뷰로 만들어볼게요!!!
    @State var selectedTime: Date
    @Binding var showSheet2: Bool
    let notificationManager = LocalNotificationManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray01
                    .ignoresSafeArea()
                VStack {
                    GroupBox {
                        DatePicker(
                            "",
                            selection: $selectedTime,
                            displayedComponents: [.hourAndMinute]
                        )
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                        .environment(\.locale, .init(identifier: "ko_KR"))
//                        .frame(width: UIScreen.main.bounds.width * 0.9)
                    }
                    .groupBoxStyle(CustomListGroupBoxStyle())
                    Spacer()
                        .frame(height: 39)
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
                    }) {
                        Text("설정 완료하기")
                    }
                    .buttonStyle(PIMGreenButton())
                }
                .padding(.horizontal, 18)
            }
        }
        .toolbar {
            Button {
                showSheet2 = false
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            }
        }
    }
}

//struct TimePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimePickerView(selectedTime: Date(), showSheet2: true)
//    }
//}
