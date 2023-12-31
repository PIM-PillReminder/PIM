//
//  SettingView.swift
//  PIM
//
//  Created by 장수민 on 2023/09/19.
//

import SwiftUI

struct SettingView: View {
  @Environment(\.scenePhase) var scenePhase
  @State var isDeactivated = true
  @State var isLocked = false
  @State var showSheet = false
  @State var showSheet2 = false
  @State private var isNotificationsEnabled: Bool = false
  @State private var selectedTime: Date? = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? nil
  @StateObject var settingViewModel = SettingViewModel()
  @Environment(\.presentationMode) var presentationMode
  
  let notificationManager = LocalNotificationManager()
  //TODO: 한국어 표기
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "a hh:mm"
    formatter.locale = Locale(identifier:"ko_KR")
    return formatter
  }()
  
  //TODO: 다음 스프린트 때 나머지 리스트 버튼 영역 수정하기!
  
  var body: some View {
    GeometryReader { geo in
        VStack {
          ZStack {
            HStack {
              Button(action: {
                presentationMode.wrappedValue.dismiss()
              }) {
                Image(systemName: "chevron.left")
                  .foregroundColor(Color.pimBlack)
                  .font(.title3)
              }
              Spacer()
            }
            Text("설정")
              .font(.pretendard(.bold, size: 18))
              .frame(alignment: .center)
          }
          .padding(.bottom, UIScreen.main.bounds.width * 0.08)

          GroupBox {
            plainCell(icon: "pill", text: "복용중인 약")
              .foregroundColor(Color.settingDisabledGray)
              .font(.pretendard(.medium, size: 18))
            Divider()
            Button {
              showSheet = true
            } label: {
              HStack {
                Image(systemName: "clock")
                  .font(.title3)
                  .padding(.trailing, 8)
                  .foregroundStyle(Color.pimBlack)
                
                if let selectedTime = settingViewModel.selectedTime {
                  Text("\(selectedTime, formatter: SettingView.dateFormatter)")
                    .font(.pretendard(.medium, size: 18))
                    .environment(\.locale, .init(identifier: "ko_KR"))
                    .foregroundStyle(Color.pimBlack)
                } else {
                  Text("알림 시간을 선택하지 않았습니다.")
                    .font(.pretendard(.medium, size: 18))
                    .foregroundStyle(Color.pimBlack)
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                  .foregroundColor(.boxChevronGray)
                  .font(.title3)
              }
              .padding(.vertical, 8)
              .padding(.horizontal, 10)
            }
            .sheet(isPresented: $showSheet) {
              TimePickerView(showSheet1: $showSheet, settingViewModel: settingViewModel )
                .presentationDetents([.height(geo.size.width)])
                .presentationDragIndicator(.hidden)
                .environment(\.scenePhase, scenePhase)
            }
          }
          .groupBoxStyle(CustomListGroupBoxStyle())
          .padding(.vertical)
          
          GroupBox {
            Button {
//              showSheet2 = true
              UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            } label: {
              HStack {
                Image(systemName: "bell")
                  .font(.title3)
                  .padding(.trailing, 8)
                  .foregroundStyle(Color.pimBlack)
                
                Text("알림")
                  .font(.pretendard(.medium, size: 18))
                  .foregroundStyle(Color.pimBlack)
                
                Spacer()
                
                Toggle("", isOn: .constant(isNotificationsEnabled))
                  .toggleStyle(SwitchToggleStyle(tint: Color.primaryGreen))
                //                Image(systemName: "chevron.right")
                //                  .foregroundColor(Color.gray02)
                  .allowsHitTesting(false)
              }
//              .sheet(isPresented: $showSheet2) {
//                SettingNotiView(showSheet2: $showSheet2, settingViewModel: settingViewModel)
//                  .presentationDetents([.height(geo.size.width * 1.3)])
//                  .presentationDragIndicator(.hidden)
//              }
              .padding(.vertical, 8)
              .padding(.horizontal, 10)
            }
            Divider()
            plainCell(icon: "message", text: "FAQ")
              .foregroundColor(Color.settingDisabledGray)
            Divider()
            HStack{
              Image(systemName: "lock")
                .padding(.trailing, 8)
                .font(.title3)
              Text("앱 잠금")
                .font(.pretendard(.medium, size: 18))
              Spacer()
              Toggle("", isOn: $isLocked)
                .toggleStyle(SwitchToggleStyle(tint: Color.primaryGreen))
                .disabled(isDeactivated)
            }
            .foregroundColor(Color.settingDisabledGray)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
            Divider()
            
            plainCell(icon: "arrow.down.to.line", text: "데이터 백업")
              
          }
          .groupBoxStyle(CustomListGroupBoxStyle())
          
          Spacer()
        }
        .padding(.top, 10)
        .padding(.bottom)
        .padding(.horizontal, 18)
//        .navigationTitle("설정")
//        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color.backgroundGray)
    }
    .onAppear {
      checkNotificationSettings()
      settingViewModel.selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? nil
    }
    .onChange(of: scenePhase) {
      if scenePhase == .inactive || scenePhase == .background {
        checkNotificationSettings()
        settingViewModel.selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? nil
      }
    }
  }
  
  private func checkNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
          DispatchQueue.main.async {
              isNotificationsEnabled = settings.authorizationStatus == .authorized
          }
      }
  }
  private func setSelectedTime() {
    settingViewModel.selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? nil
  }
}

struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
  }
}

@ViewBuilder
func plainCell(icon: String, text: String) -> some View {
  
  let isDeactivated: Bool = true
  
  HStack {
    Image(systemName: "\(icon)")
      .font(.title3)
      .padding(.trailing, 8)
    
    Text("\(text)")
      .font(.pretendard(.medium, size: 18))
      .foregroundColor(Color.settingDisabledGray)
    
    Spacer()
    
    NavigationLink(destination: Text("추후 업데이트 예정")) {
      Image(systemName: "chevron.right")
        .foregroundColor(.settingChevronDisabledGray)
    }
    .disabled(isDeactivated)
  }
  .padding(.horizontal, 10)
  .padding(.vertical, 8)
}

struct CustomListGroupBoxStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    VStack {
      configuration.label
      configuration.content
      
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(RoundedRectangle(cornerRadius: 16).fill(Color.boxWhite))
  }
}
