//
//  SettingNotiVIew.swift
//  PIM
//
//  Created by 장수민 on 2023/09/19.
//

import SwiftUI

struct SettingNotiView: View {
  @State var isDeactivated: Bool = true
  @State var callToggleSwitch: Bool = false
  @State var isNotAuthorized: Bool = false
  @Binding var showSheet2: Bool
  // 사용자의 알림 권한 여부 UserDefaults로 받아오기
  @State private var isAllowedNoti = UserDefaults.standard.bool(forKey: "NotificationPermission")
  @StateObject var settingViewModel: SettingViewModel

  let notificationManager = LocalNotificationManager()
  let screenWidth = UIScreen.main.bounds.width
  
  var body: some View {
    
    NavigationStack {
        VStack {
          ZStack(alignment: .center) {
            Text("알림 시간 설정하기")
              .font(.pretendard(.bold, size: 18))
            HStack {
              Spacer()
              Button {
                showSheet2 = false
              } label: {
                Image(systemName: "xmark")
                  .foregroundStyle(Color.pimBlack)
                  .font(.title3)
              }
              
            }
          }
          .padding(.top)
          GroupBox {
            HStack {
              Text("알림 허용")
                .font(.pretendard(.medium, size: 18))
              Spacer()
              Toggle("", isOn: $isAllowedNoti)
                .toggleStyle(SwitchToggleStyle(tint: Color.primaryGreen))
                .onChange(of: isAllowedNoti) { notiActivated in
                  if notiActivated {
                    // 알림 활성화
                    //MARK: 근데 이렇게 해도 권한 자체가 바뀌는 건 아닌데...
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        if settings.authorizationStatus != .authorized {
                          notificationManager.requestPermission()
                        } else {
                          notificationManager.enableNotifications()
                        }
                    }
                    UserDefaults.standard.set(isAllowedNoti, forKey: "NotificationPermission")
                    print("허용")
                  } else {
                    // 알림 비활성화
                    notificationManager.disableNotifications()
                    //MARK: 근데 이렇게 해도 권한 자체가 바뀌는 건 아닌데...
                    UserDefaults.standard.set(isAllowedNoti, forKey: "NotificationPermission")
                    print("거부")
                  }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
          }
          .groupBoxStyle(CustomListGroupBoxStyle())
          .padding(.top, 20)
          Spacer()
            .frame(height: 16)
          GroupBox {
            HStack {
              VStack(alignment: .leading ) {
                Text("알림 빈도")
                  .font(.pretendard(.medium, size: 18))
                  .font(.system(size: 18))
                  .padding(.bottom, 7)
                Spacer()
                  .frame(height: 7)
                Text("첫 알림 이후 한 시간 단위로\n몇 번 더 알림을 받을지 선택해주세요.")
                  .lineSpacing(4)
                  .foregroundColor(.gray)
                  .font(.pretendard(.regular,size: 14))
                  .multilineTextAlignment(.leading)
                
                Spacer()
                
                PIMCustomSlider()
                
              }
              .padding(.bottom)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
          }
          .frame(height: screenWidth * 0.53)
          .groupBoxStyle(CustomListGroupBoxStyle())
          Spacer()
          
          Button("설정 완료하기") {
            showSheet2 = false
          }.buttonStyle(PIMGreenButton())
          
          //                GroupBox {
          //                    ZStack{
          //                        HStack {
          //                            VStack(alignment: .leading) {
          //                                Text("전화 알림 허용")
          //                                    .padding(.bottom, 7)
          //
          //                                Text("설정 시간에서 12시간이 지나면 전화를 드려요")
          //                                    .foregroundColor(.gray)
          //                                    .font(.system(.caption))
          //                            }
          //                            Spacer()
          //                        }
          //                        Toggle("", isOn: $callToggleSwitch)
          //                                            .toggleStyle(SwitchToggleStyle(tint: Color.pimGreen))
          //                                            .disabled(isDeactivated)
          //                        }
          //                    .padding(.horizontal, 10)
          //                    .padding(.vertical, 5)
          //                }
          //                .groupBoxStyle(CustomListGroupBoxStyle())
          //                .padding(.bottom)
          Spacer()
        }
        .padding(.bottom, 23)
        .padding(.horizontal, 18)
        //                .onDisappear {
        //                    let repeatingTimes = notificationManager.repeatingTimes
        //                    print(repeatingTimes)
        //                }
    }
  }
}

struct SettingNotiView_Previews: PreviewProvider {
  @State static var showSheet2 = true
  
  static var previews: some View {
    SettingNotiView(showSheet2: $showSheet2, settingViewModel: SettingViewModel())
  }
}
