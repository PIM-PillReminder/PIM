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
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.gray
                    .ignoresSafeArea()
                
                VStack {
                    GroupBox {
                        plainCell(icon: "pill", text: "복용중인 약")
                        Divider()
                        plainCell(icon: "clock", text: "오전 10:00")
                        
                    }
                    .groupBoxStyle(CustomListGroupBoxStyle())
                    .padding(.bottom)
                    
                    GroupBox {
                        plainCell(icon: "arrow.down.to.line", text: "데이터 백업")
                        
                        Divider()
                        
                        HStack{
                            Image(systemName: "lock")
                                .padding(.trailing, 8)
                            Text("앱 잠금")
                            
                            Spacer()
                            
                            
                            Toggle("", isOn: $isLocked)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.green))
                                            .disabled(isDeactivated)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "bell")
                                .padding(.trailing, 8)
                            Text("알림")
                            
                            Spacer()
                            
                            NavigationLink {
                                SettingNotiView()
                            } label: {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        
                        Divider()
                        
                        plainCell(icon: "message", text: "FAQ")
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
        
        NavigationLink(destination: Text("dummy")) {
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
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
