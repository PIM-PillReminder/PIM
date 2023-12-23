//
//  TimePickerView.swift
//  PIM
//
//  Created by 장수민 on 2023/09/27.
//

import SwiftUI

struct TimePickerView: View {
  // 설정 화면에 있는 피커랑 온보딩 피커를 통일하는 게 좋을 것 같아여...! 지금은 이렇게 해두고 나중에 하나의 뷰로 만들어볼게요!!!
  //    @State var selectedTime: Date
  @Binding var showSheet1: Bool
  let notificationManager = LocalNotificationManager()
  @State var selectedTime: Date = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? Date()
  @StateObject var settingViewModel: SettingViewModel
  
  var body: some View {
    ZStack {
      Color.gray01
        .ignoresSafeArea()
      VStack {
        HStack {
          Spacer()
          Button {
            showSheet1 = false
          } label: {
            Image(systemName: "xmark")
              .foregroundStyle(Color.black)
              .font(.title3)
          }
          .padding(.top)
        }
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
        .padding(.vertical)
        Spacer()
        Button(action: {
          // 1. 이전 알림 삭제
          UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
          
          // 2. 새로운 알림 추가
          notificationManager.addNotification(title: "PIM")
          UserDefaults.standard.set(selectedTime, forKey: "SelectedTime")
          
          // 3. 스케줄링
          notificationManager.schedule()
          settingViewModel.selectedTime = selectedTime
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
    .onAppear {
      selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? Date()
    }
  }
}
