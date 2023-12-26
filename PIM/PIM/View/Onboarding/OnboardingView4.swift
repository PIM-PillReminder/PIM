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
  @State private var playLottie: Bool = true
  let notificationManager = LocalNotificationManager()
  @AppStorage("isOnboarding") var isOnboarding: Bool?
  
  var body: some View {
    NavigationView{
      VStack {
        ZStack {
          HStack {
            Button(action: {
              presentationMode.wrappedValue.dismiss()
            }) {
              Image(systemName: "chevron.left")
                .foregroundColor(Color.pimBlack)
                .font(.pretendard(.regular, size: 24))
            }
            .padding(.leading, 15)
            Spacer()
          }
          Text("시작하기")
            .font(.pretendard(.bold, size: 18))
            .frame(alignment: .center)
        }
        .padding(.top, 10)
        
        // TODO: 2차 업데이트 시 value: 80으로 변경
        ProgressView(value: 0, total: 100)
          .progressViewStyle(LinearProgressViewStyle(tint: .primaryGreen))
          .padding(.bottom, 30)
        Text("몇 시에 약을 먹나요?")
          .font(.pretendard(.bold, size: 24))
          .frame(alignment: .center)
          .padding(.bottom, 9)
        Text("선택한 복용 시간을 바탕으로 알림이 울려요.")
          .font(.pretendard(.regular, size: 16))
          .foregroundColor(Color.subtitleGray)
          .padding(.bottom, 10)
        LottieView(jsonName: "clockPimi", loopMode: .repeat(10), playLottie: $playLottie)
        
        DatePicker(
          "",
          selection: $selectedTime,
          displayedComponents: [.hourAndMinute]
        )
        .labelsHidden()
        .datePickerStyle(.wheel)
        .environment(\.locale, .init(identifier: "ko_KR"))
        .frame(width: UIScreen.main.bounds.width * 0.9)
        
        Spacer()
        
        //                NavigationLink(
        //                    destination: MainView().navigationBarHidden(true),
        //                    isActive: $isMainViewActive) {
        //                        EmptyView()
        //                    }
        
        Button(action: {
          let calendar = Calendar.current
          _ = calendar.component(.hour, from: selectedTime)
          _ = calendar.component(.minute, from: selectedTime)
          UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
              notificationManager.requestPermission()
            }
          }
          isMainViewActive = true
          isOnboarding = false
        }) {
          Text("선택했어요")
            .font(.pretendard(.bold, size: 20))
            .foregroundColor(Color.white)
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 40)
        .padding(.bottom, 10)
        .background(Color.primaryGreen)
      }
      .background(Color.backgroundWhite)
    }
    .navigationBarBackButtonHidden(true)
    .onAppear {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        if settings.authorizationStatus != .authorized {
          notificationManager.requestPermission()
        }
      }
    }
    .onDisappear {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        UserDefaults.standard.set(settings.authorizationStatus == .authorized, forKey: "NotificationPermission")
        UserDefaults.standard.set(selectedTime, forKey: "SelectedTime")
      }
    }
  }
}

struct OnboardingView4_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView4(selectedTime: Date())
  }
}
