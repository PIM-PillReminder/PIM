//
//  SettingNotiVIew.swift
//  PIM
//
//  Created by 장수민 on 2023/09/19.
//

import SwiftUI

struct SettingNotiView: View {
    @State var isDeactivaated: Bool = true
    @State var callToggleSwitch: Bool = false
    
    @State var isNotiActivated: Bool = false
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            VStack {
                GroupBox {
                    HStack{
                        Text("알림 허용")
                        
                        Spacer()
                        
                        Toggle("", isOn: $isNotiActivated)
                                        .toggleStyle(SwitchToggleStyle(tint: Color.green))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .groupBoxStyle(CustomListGroupBoxStyle())
                .padding(.bottom)
                
                GroupBox {
                    HStack {
                        VStack(alignment: .leading ) {
                            Text("알림 강도")
                                .padding(.bottom)
                            
                            HStack {
                                Text("하루에")
                                
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(height: 50)
                                
                                Text("알림을 받을래요")
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .groupBoxStyle(CustomListGroupBoxStyle())
                .padding(.bottom)

                GroupBox {
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
                                            .toggleStyle(SwitchToggleStyle(tint: Color.green))
                                            .disabled(isDeactivaated)
                        }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .groupBoxStyle(CustomListGroupBoxStyle())
                .padding(.bottom)
                
                Spacer()

            }
            .padding(.vertical)
            .padding(.horizontal, 18)
            .navigationTitle("알림 설정")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct SettingNotiView_Previews: PreviewProvider {
    static var previews: some View {
        SettingNotiView()
    }
}
