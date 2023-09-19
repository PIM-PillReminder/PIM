//
//  SettingView.swift
//  PIM
//
//  Created by 장수민 on 2023/09/19.
//

import SwiftUI

struct SettingView: View {
    
    @State var pillName: String = "미뉴렛정"
    @State private var isLinkActive = false // 비활성화 부분
    @State var toggleSwitch: Bool = false // 앱 잠금 임시 토글
    @Binding var selectedStrength: AlertStrength
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        plainCell(icon: "clock", text: "오전   10:00")
                        plainCell(icon: "pill", text: "미뉴렛정")
                    }
                    Section {
                        plainCell(icon: "arrow.down.to.line", text: "데이터 백업")
                        HStack{
                            Image(systemName: "lock")
                            Text("앱 잠금")
                            
                            Spacer()
                            
                            Toggle("", isOn: $toggleSwitch)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.pink))
                        }
                        .padding(.vertical, 5)
                        
                        HStack {
                            Image(systemName: "bell")
                            Text("알림")
                            
                            NavigationLink {
                                SettingNotiVIew(selectedStrength: $selectedStrength)
                            } label: {

                            }
                        }
                        .padding(.vertical, 8)
                        
                        plainCell(icon: "message", text: "FAQ")
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("설정")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(selectedStrength: .constant(AlertStrength.list[0]))
    }
}

// 이 코드는 어디에 따로 빼는게 좋을까요? 스타일 정의해두는 파일을 따로 만들까요?
@ViewBuilder
func plainCell(icon: String, text: String, destination: String = "추후 업데이트 예정 :)") -> some View {
    HStack {
        Image(systemName: "\(icon)")
        Text("\(text)")
        
        NavigationLink {
            Text("\(destination)")
        } label: {

        }
    }
    .padding(.vertical, 8)
}
