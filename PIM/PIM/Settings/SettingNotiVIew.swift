//
//  SettingNotiVIew.swift
//  PIM
//
//  Created by 장수민 on 2023/09/19.
//

import SwiftUI

struct SettingNotiVIew: View {
    
    @State var alertToggleSwitch: Bool = false
    @State var callToggleSwitch: Bool = false
    @Binding var selectedStrength: AlertStrength
    
    var body: some View {
            VStack {
                List {
                    Section {
                        HStack{
                            Text("알림 허용")
                            Spacer()
                            Toggle("", isOn: $alertToggleSwitch)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.pink))
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("알림 강도")
                                .padding(.bottom, 8)
                            
                            HStack (alignment: .top) {
                                CustomPickerMenu(selectedStrength: $selectedStrength)
                                Text("알림을 받을래요")
                                    .padding(.vertical)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Section {
                    ZStack{
                        HStack {
                            VStack(alignment: .leading) {
                                Text("전화 알림 허용")
                                    .padding(.bottom, 7)
                                
                                Text("설정 시간에서 12시간이 지나면 전화를 드려요")
                                    .foregroundColor(.gray)
                                    .font(.system(.caption))
                            }
                            Spacer()
                        }
                        Toggle("", isOn: $callToggleSwitch)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.pink))
                        }
                    }
                    .padding(.vertical, 5)

                }
                .listStyle(.insetGrouped)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("알림 설정")
    }
}

struct SettingNotiVIew_Previews: PreviewProvider {
    static var previews: some View {
        SettingNotiVIew(selectedStrength: .constant(AlertStrength.list[0]))
    }
}
