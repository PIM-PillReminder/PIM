///Users/madeline/PIM/PIM/PIM/LottieFile
//  SettingView.swift
//  PIM
//
//  Created by 장수민 on 2023/09/19.
//

import SwiftUI
import MessageUI

struct SettingView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var isDeactivated = true
    @State var isLocked = false
    @State var showSheet = false
    @State var showSheet2 = false
    @State private var isNotificationsEnabled: Bool = false
    @State private var selectedTime: Date? = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? nil
    @StateObject var settingViewModel = SettingViewModel()
    @State var modalBackground: Bool = false
    @State private var showMailView = false
    @Environment(\.presentationMode) var presentationMode
    
    let notificationManager = LocalNotificationManager()
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a    hh:mm"
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter
    }()
    
    //TODO: 다음 스프린트 때 나머지 리스트 버튼 영역 수정하기!
    var body: some View {
        ZStack {
            GeometryReader { geo in
                
                VStack {
                    
                    Text("복약 정보")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color.gray08)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.leading, 6)
                    
                    GroupBox {
                        
                        HStack {
                            Image("pill")
                                .frame(width: 26, height: 26)
                            
                            Text("복용중인 약")
                                .font(.pretendard(.medium, size: 16))
                                .padding(.leading, 8)
                                .foregroundColor(Color.gray04)
                            
                            Spacer()
                            
                            NavigationLink(destination: Text("추후 업데이트 예정")) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.gray04)
                                    .font(.title3)
                            }
                            .disabled(isDeactivated)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        
                        Divider()
                        
                        Button {
                            showSheet = true
                            settingViewModel.modalBackground = true
                            modalBackground = true
                        } label: {
                            HStack {
                                Image("clock")
                                    .frame(width: 26, height: 26)
                                
                                if let selectedTime = settingViewModel.selectedTime {
                                    Text("\(selectedTime, formatter: SettingView.dateFormatter)")
                                        .font(.pretendard(.medium, size: 16))
                                        .environment(\.locale, .init(identifier: "ko_KR"))
                                        .foregroundStyle(Color.pimBlack)
                                        .padding(.leading, 8)
                                } else {
                                    Text("알림 시간을 선택하지 않았습니다.")
                                        .font(.pretendard(.medium, size: 16))
                                        .foregroundStyle(Color.pimBlack)
                                }
                                
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.pimBlack)
                                    .font(.title3)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        }
                        .sheet(isPresented: $showSheet) {
                            TimePickerView(showSheet1: $showSheet, modalBackground: $modalBackground, settingViewModel: settingViewModel)
                                .presentationDetents([.height(geo.size.width * 1.02)])
                                .presentationDragIndicator(.hidden)
                                .presentationCornerRadius(16)
                                .environment(\.scenePhase, scenePhase)
                                .onDisappear{
                                    settingViewModel.modalBackground = false
                                }
                                .onWillDisappear{
                                    settingViewModel.modalBackground = false
                                }
                        }
                        
                        Divider()
                        
                        HStack {
                            Image("lightbulb")
                                .frame(width: 26, height: 26)
                            
                            Text("피임약 바로 알기")
                                .font(.pretendard(.medium, size: 16))
                                .padding(.leading, 8)
                                .foregroundColor(Color.gray04)
                            
                            Spacer()
                            
                            NavigationLink(destination: Text("추후 업데이트 예정")) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.gray04)
                                    .font(.title3)
                            }
                            .disabled(isDeactivated)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    }
                    .groupBoxStyle(CustomListGroupBoxStyle())
                    .padding(.top, 4)
                    
                    Text("앱 관리")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color.gray08)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                        .padding(.leading, 6)
                    
                    GroupBox {
                        
                        Button {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                
                                HStack {
                                    Image("bell")
                                        .frame(width: 26, height: 26)
                                    
                                    Text("알림")
                                        .font(.pretendard(.medium, size: 16))
                                        .foregroundStyle(Color.pimBlack)
                                        .padding(.leading, 8)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: .constant(isNotificationsEnabled))
                                        .toggleStyle(SwitchToggleStyle(tint: Color.green03))
                                        .allowsHitTesting(false)
                                }
                                    Text("선택 시 기기의 앱설정으로 이동해요.")
                                        .font(.pretendard(.regular, size: 12))
                                        .lineSpacing(2)
                                        .foregroundStyle(Color.gray08)
                                        .multilineTextAlignment(.leading)
                                        .padding(.leading, 42)
                                        .padding(.bottom, 6)
                            }
                            .padding(.leading, 10)
                        }
                        
                        Divider()
                        
                        HStack {
                            Image("message")
                                .frame(width: 26, height: 26)
                            
                            Text("의견 보내기")
                                .font(.pretendard(.medium, size: 16))
                                .padding(.leading, 8)
                                .foregroundColor(Color.pimBlack)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.pimBlack)
                                .font(.title3)
                        }
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if MFMailComposeViewController.canSendMail() {
                                showMailView = true
                            } else {
                                let alert = UIAlertController(
                                    title: "메일 전송 실패",
                                    message: "메일을 보낼 수 있는 메일 계정이 등록되어 있지 않습니다. 설정에서 메일 계정을 추가해주세요.",
                                    preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(
                                    title: "설정으로 이동",
                                    style: .default,
                                    handler: { _ in
                                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                            UIApplication.shared.open(settingsURL)
                                        }
                                    }
                                ))
                                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                                
                                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                            }
                        }
                        .sheet(isPresented: $showMailView) {
                            MailContentView(
                                toRecipients: ["pim.connect2024@gmail.com"],
                                subject: "[Pim] 의견 보내기"
                            )
                        }
                        .padding(.leading, 10)
                        
                        Divider()
                        
                        HStack {
                            Image("lock")
                                .frame(width: 26, height: 26)
                            
                            Text("앱 잠금")
                                .font(.pretendard(.medium, size: 16))
                                .padding(.leading, 8)
                                .foregroundColor(Color.gray04)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isLocked)
                                .toggleStyle(SwitchToggleStyle(tint: Color.green03))
                                .disabled(isDeactivated)
                        }
                        .foregroundColor(Color.settingDisabledGray)
                        .padding(.leading, 10)
                        .padding(.vertical, 6)
                        
                        Divider()
                        
                        HStack {
                            Image("arrowDown")
                                .frame(width: 26, height: 26)
                            
                            Text("데이터 백업")
                                .font(.pretendard(.medium, size: 16))
                                .padding(.leading, 8)
                                .foregroundColor(Color.gray04)
                            
                            Spacer()
                            
                            NavigationLink(destination: Text("추후 업데이트 예정")) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.gray04)
                                    .font(.title3)
                            }
                            .disabled(isDeactivated)
                        }
                        .padding(.leading, 10)
                        .padding(.vertical, 6)
                    }
                    .groupBoxStyle(CustomListGroupBoxStyle())
                    
                    Spacer()
                }
                .padding(.horizontal, 18)
                .navigationBarBackButtonHidden(true)
                .background(Color.excpt212)
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.pimBlack)
                        .font(.title3)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("설정")
                    .font(.pretendard(.bold, size: 18))
            }
        }
        .overlay {
            Color.black.opacity(settingViewModel.modalBackground ? 0.7 : 0)
                .animation(.easeIn)
                .ignoresSafeArea()
        }
        .navigationBarTitleDisplayMode(.inline)
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

@ViewBuilder
func plainCell(icon: String, text: String) -> some View {
    
    let isDeactivated: Bool = true
    
    HStack {
        Image(systemName: "\(icon)")
            .font(.title3)
            .foregroundStyle(Color.settingDisabledGray)
        
        Text("\(text)")
            .font(.pretendard(.medium, size: 16))
            .padding(.leading, 10)
            .foregroundColor(Color.settingDisabledGray)
        
        Spacer()
        
        NavigationLink(destination: Text("추후 업데이트 예정")) {
            Image(systemName: "chevron.right")
                .foregroundColor(.settingChevronDisabledGray)
                .font(.title3)
        }
        .disabled(isDeactivated)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 5)
}

struct CustomListGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            configuration.content
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.excpt11))
    }
}
