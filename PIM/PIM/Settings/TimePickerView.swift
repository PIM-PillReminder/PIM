//
//  TimePickerView.swift
//  PIM
//
//  Created by 장수민 on 2023/09/27.
//

import SwiftUI

struct TimePickerView: View {
    // 온보딩에서 설정한 시간을 어떻게 받아와야 할까요... 
    @State var selectedTime: Date
    @Binding var showSheet1: Bool
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
                        .padding(.vertical, 30)

                    }
                    .groupBoxStyle(CustomListGroupBoxStyle())
                    Spacer()
                        .frame(height: 36)
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
                        showSheet1 = false
                    }) {
                        Text("설정 완료하기")
                    }
                    .buttonStyle(PIMGreenButton())
                    Spacer()
                }
                .padding(.horizontal, 18)
                .toolbar {
                    Button {
                        showSheet1 = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}
