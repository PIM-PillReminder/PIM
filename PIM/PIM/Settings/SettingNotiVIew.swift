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
    @State var isNotiActivated: Bool = false
    @Binding var showSheet2: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.lightGray
                    .ignoresSafeArea()
                VStack {
                    GroupBox {
                        HStack{
                            Text("알림 허용")
                                .font(.pretendard(.bold))
                            
                            Spacer()
                            
                            Toggle("", isOn: $isNotiActivated)
                                            .toggleStyle(SwitchToggleStyle(tint: Color.green03))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    }
                    .groupBoxStyle(CustomListGroupBoxStyle())
                    Spacer()
                        .frame(height: 16)
                    GroupBox {
                        HStack {
                            VStack(alignment: .leading ) {
                                HStack {
                                    Text("알림 빈도")
                                        .font(.pretendard(.bold))
                                }
                                Spacer()
                                    .frame(height: 7)
                                
                                Text("약 먹기를 완료할 때까지\n하루에 몇 번 알림을 받을지 선택해주세요.")
                                    .foregroundColor(.gray)
                                    .font(.pretendard(.medium,size: 14))
                                    
                                Spacer()
                                    .frame(height: 20)
                                
                                PIMCustomSlider()
                                
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    }
                    .groupBoxStyle(CustomListGroupBoxStyle())
                    
                    Spacer()
                        .frame(height: 36)
                    
                   
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
    //            .navigationTitle("알림 설정")
    //            .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button {
                        showSheet2 = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                
            }
        }
    }
}

//struct SettingNotiView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingNotiView(showSheet2: )
//    }
//}
