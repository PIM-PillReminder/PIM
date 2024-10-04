//
//  MainView.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI
import WatchConnectivity

struct MainView: View {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    
    let notificationManager = LocalNotificationManager()
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var pillStatusObserver = PillStatusObserver()
    
    @State private var isPillEaten: Bool = false
    @State private var playLottie: Bool = true
    @State private var tapPlay: Bool = true
    @EnvironmentObject var firestoreManager: FireStoreManager
    
    @State private var pillTakenTimeString: String = ""
    
    init() {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let pillStatus = UserDefaultsManager.shared.getPillStatus()[currentDate] ?? false
        if pillStatus, let _ = UserDefaultsManager.shared.getPillTakenTime(for: currentDate) {
            isPillEaten = true
        } else {
            isPillEaten = false
        }
    }

//    init() {
//        let currentDateStr = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
//        isPillEaten = UserDefaults.standard.bool(forKey: currentDateStr)
//    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: SettingView()) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 24))
                                .foregroundColor(Color.primaryGreen)
                                .padding(.trailing, 20)
                        }
                    }
                    
                    NavigationLink(destination: CalendarViewRepresentable()
                                    .navigationBarBackButtonHidden()) {
                            Text(dateFormatter.string(from: Date())) // Text를 사용하여 날짜 표시
                                .foregroundColor(.pimBlack)
                                .font(.pretendard(.medium, size: 16))
                                .padding(.trailing, 6)
                    }
                                    .buttonStyle(PIMCalendarButton())

                }
                .padding(.top, 15)
                .padding(.bottom, 95)
                
                VStack(spacing:0){
                    Text(pillStatusObserver.isPillEaten ? "약 먹기 완료! 내일 만나요!" : "오늘 약을 먹었나요?")
                        .font(.pretendard(.bold, size: 18))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                    
                    if pillStatusObserver.isPillEaten {
                        Text(pillTakenTimeString)
                            .font(.pretendard(.regular, size: 16))
                            .foregroundColor(Color("gray08"))
                            .multilineTextAlignment(.center)
                            
                    }
                }
                
                Spacer()
                
                if(pillStatusObserver.isPillEaten) {
                    LottieView(jsonName: "happyPimi", loopMode: .playOnce, playLottie: $playLottie, tapPlay: true)
                        .padding(.bottom, 50)
                        .onTapGesture {
                            playLottie.toggle()
                        }
                }
                else {
                    LottieView(jsonName:"sadPimi", loopMode: .playOnce, playLottie: $playLottie, tapPlay: true)
                        .padding(.bottom, 50)
                        .onTapGesture {
                            playLottie.toggle()
                        }
                }
                
                Spacer()
                
                if(!pillStatusObserver.isPillEaten){
                    Button("오늘의 약을 먹었어요") {
                        // pillStatusObserver.isPillEaten = true
                        let currentTime = Date()
                        updatePillStatus(true, takenTime: currentTime)
                    }
                    .buttonStyle(PIMGreenButton())
                    .padding(.bottom, 10)
                } else {
                    Button("앗! 잘못 눌렀어요") {
                        // pillStatusObserver.isPillEaten = false
                        updatePillStatus(false)
                    }
                    .buttonStyle(PIMStrokeButton())
                    .padding(.bottom, 10)
                }
            }
            .onAppear {
                fetchPillStatusFromWatch()
                updatePillTakenTimeString()
                playLottie.toggle()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    let currentDateStr = getCurrentDateString()
                    if UserDefaults.standard.bool(forKey: currentDateStr) {
                        pillStatusObserver.isPillEaten = true
                    }
                }
            }
            .onChange(of: pillStatusObserver.isPillEaten) { newValue in
                // 현재 시간과 함께 새로운 PillStatus 객체를 생성
//                let newPillStatus = PillStatus(isPillEaten: newValue, pillDate: Date())
                
                // FirestoreManager에 새 PillStatus 객체 저장
//                firestoreManager.savePillStatus(pillStatus: newPillStatus)
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            .background(Color.backgroundWhite)
        }
        .onAppear {
            let currentDate = Calendar.current.startOfDay(for: Date())
            if let pillStatus = UserDefaultsManager.shared.getPillStatus()[currentDate], pillStatus {
                // 복용 여부가 true인 경우에만 시간 확인
                if let pillTakenTime = UserDefaultsManager.shared.getPillTakenTime(for: currentDate) {
                    pillStatusObserver.isPillEaten = true
                    updatePillTakenTimeString() // 복용 시간 업데이트
                } else {
                    pillStatusObserver.isPillEaten = false // 복용 시간이 없으면 false로 설정
                }
            } else {
                pillStatusObserver.isPillEaten = false
            }
            fetchPillStatusFromWatch()
        }
    }
    
    // 상태 업데이트 및 워치에 전송
    private func updatePillStatus(_ status: Bool, takenTime: Date? = nil) {
        let today = Calendar.current.startOfDay(for: Date())
        if status {
            if let time = takenTime {
                UserDefaultsManager.shared.savePillTakenTime(date: time)
            }
            UserDefaultsManager.shared.savePillStatus(date: today, isPillEaten: true)
        } else {
            UserDefaultsManager.shared.removePillTakenTime(for: today)
            UserDefaultsManager.shared.savePillStatus(date: today, isPillEaten: false)
        }
        pillStatusObserver.isPillEaten = status
        updatePillTakenTimeString() // 상태 업데이트 후 복용 시간 다시 체크
    }
    
    // MARK: (GET) 워치로부터 데이터 받아오기
    private func fetchPillStatusFromWatch() {
        if WCSession.default.isReachable {
            print("Watch is reachable, requesting pill status.")
            WCSession.default.sendMessage(["RequestPillStatus": true], replyHandler: { response in
                DispatchQueue.main.async {
                    if let status = response["PillEaten"] as? Bool {
                        print("Received pill status from Watch: \(status)")
                        pillStatusObserver.isPillEaten = status
                    } else {
                        print("Error: No pill status found in Watch response.")
                    }
                }
            }) { error in
                print("Error requesting pill status from Watch: \(error.localizedDescription)")
            }
        } else {
            print("Watch is not reachable.")
        }
    }
    
    private func getCurrentDateString() -> String {
        return DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
    }
    
    private func updatePillTakenTimeString() {
        let today = Calendar.current.startOfDay(for: Date())
        if let pillTakenTime = UserDefaultsManager.shared.getPillTakenTime(for: today) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 a h시 m분"
            pillTakenTimeString = formatter.string(from: pillTakenTime) + "에 복용했어요"
        } else {
            pillTakenTimeString = "" // 복용 시간이 없으면 빈 문자열로 설정
        }
    }
}

// MARK: isPillEaten Status 관찰
class PillStatusObserver: ObservableObject {
    @Published var isPillEaten: Bool = false {
        didSet {
            let currentDate = Calendar.current.startOfDay(for: Date())
            if UserDefaultsManager.shared.getPillStatus()[currentDate] != isPillEaten {
                print("Updating isPillEaten in didSet with value: \(isPillEaten)")
                
                if isPillEaten {
                    // 복용 여부가 true일 때만 복용 시간 확인
                    if let _ = UserDefaultsManager.shared.getPillTakenTime(for: currentDate) {
                        UserDefaultsManager.shared.savePillStatus(date: currentDate, isPillEaten: true)
                    } else {
                        // 복용 시간이 없으면 false로 변경
                        print("Pill taken time is nil, setting isPillEaten to false.")
                        isPillEaten = false
                        UserDefaultsManager.shared.savePillStatus(date: currentDate, isPillEaten: false)
                    }
                } else {
                    UserDefaultsManager.shared.savePillStatus(date: currentDate, isPillEaten: false)
                    UserDefaultsManager.shared.removePillTakenTime(for: currentDate)
                }
                
                sendPillStatusToWatch(isPillEaten)
                print("Final saved isPillEaten value: \(isPillEaten)")
            } else {
                print("isPillEaten did not change, skipping save.")
            }
        }
    }
    
    init() {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let savedStatus = UserDefaultsManager.shared.getPillStatus()[currentDate] ?? false
        // 초기화 시 중복 설정 방지
        if savedStatus != isPillEaten {
            print("Initializing PillStatusObserver: setting isPillEaten to \(savedStatus)")
            self.isPillEaten = savedStatus
        } else {
            print("Skipping initialization as the value matches UserDefaults.")
        }
    }
    
    private func getCurrentPillStatus() -> Bool {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let pillStatus = UserDefaultsManager.shared.getPillStatus()
        return pillStatus[currentDate] ?? false
    }
    
    // MARK: (POST) 워치로 데이터 보내기
    private func sendPillStatusToWatch(_ status: Bool) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["PillEaten": status], replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
            print("iOS App: Sent PillEaten status (\(status)) to Watch App")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
