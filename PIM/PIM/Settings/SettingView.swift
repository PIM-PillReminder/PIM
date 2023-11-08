//
//  SettingView.swift
//  PIM
//
//  Created by 장수민 on 2023/09/19.
//

import SwiftUI

struct SettingView: View {
  @State var isDeactivated = true
  @State var isLocked = false
  @State var showSheet = false
  @State var showSheet2 = false
  @State private var selectedTime: Date = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? Date()
  
  let notificationManager = LocalNotificationManager()
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "a hh:mm"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
  }()
  
  let defaultText = "설정한 시간이 없습니다."
  
  var body: some View {
    GeometryReader { geo in
      ZStack {
        
        Color.gray01
          .ignoresSafeArea()
        
        VStack {
          GroupBox {
            plainCell(icon: "pill", text: "복용중인 약")
              .foregroundColor(Color.gray03)
            Divider()
            HStack {
              Image(systemName: "clock")
                .padding(.trailing, 8)
              
              if Calendar.current.isDate(selectedTime, inSameDayAs: Date()) {
                Text("\(selectedTime, formatter: SettingView.dateFormatter)")
                      } else {
                          Text("알림을 선택하지 않으셨습니다.")
                      }
              
              Spacer()
              
              Button {
                showSheet = true
              } label: {
                Image(systemName: "chevron.right")
                  .foregroundColor(Color.gray02)
              }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .sheet(isPresented: $showSheet) {
              TimePickerView(showSheet1: $showSheet)
                .presentationDetents([.height(geo.size.width * 1.3 )])
                .presentationDragIndicator(.hidden)
            }
          }
          .groupBoxStyle(CustomListGroupBoxStyle())
          .padding(.bottom)
          
          GroupBox {
            HStack {
              Image(systemName: "bell")
                .padding(.trailing, 8)
              Text("알림")
              
              Spacer()
              
              Button {
                showSheet2 = true
              } label: {
                Image(systemName: "chevron.right")
                  .foregroundColor(Color.gray02)
              }
            }
            .onTapGesture {
              showSheet2 = true
            }
            .sheet(isPresented: $showSheet2) {
              SettingNotiView(showSheet2: $showSheet2)
                .presentationDetents([.height(geo.size.width * 1.3)])
                .presentationDragIndicator(.hidden)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            Divider()
            plainCell(icon: "message", text: "FAQ")
              .foregroundColor(Color.gray03)
            Divider()
            HStack{
              Image(systemName: "lock")
                .padding(.trailing, 8)
              Text("앱 잠금")
              Spacer()
              Toggle("", isOn: $isLocked)
                .toggleStyle(SwitchToggleStyle(tint: Color.pimGreen))
                .disabled(isDeactivated)
            }
            .foregroundColor(Color.gray03)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
            Divider()
            
            plainCell(icon: "arrow.down.to.line", text: "데이터 백업")
              .foregroundColor(Color.gray03)
          }
          .groupBoxStyle(CustomListGroupBoxStyle())
          
          Spacer()
        }
        .padding(.vertical)
        .padding(.horizontal, 18)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
      }
    }
    .onAppear {
      selectedTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? Date()
    }
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
      .padding(.trailing, 8)
    
    Text("\(text)")
    
    Spacer()
    
    NavigationLink(destination: Text("추후 업데이트 예정")) {
      Image(systemName: "chevron.right")
        .foregroundColor(.gray02)
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
    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
  }
}
