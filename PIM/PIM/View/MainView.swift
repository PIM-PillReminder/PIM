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
    
    init() {
        let currentDateStr = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        isPillEaten = UserDefaults.standard.bool(forKey: currentDateStr)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    
                    NavigationLink(destination: CalendarViewRepresentable()
                        .navigationBarBackButtonHidden()
                    ) {
                        Image(systemName: "calendar")
                            .font(.system(size: 24))
                            .padding(.leading, 20)
                            .foregroundColor(Color.primaryGreen)
                            .opacity(100)
                    }
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: Date()))
                        .font(.pretendard(.bold, size: 18))
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 24))
                            .foregroundColor(Color.primaryGreen)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 50)
                
                VStack{
                    Image("pill")
                        .padding(.bottom, 30)
                    
                    Text(pillStatusObserver.isPillEaten ? "약 먹기 완료! 내일 만나요!" : "오늘 약을 먹었나요?")
                        .font(.pretendard(.bold, size: 18))
                        .multilineTextAlignment(.center)
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
                    Button("네! 먹었어요") {
                        pillStatusObserver.isPillEaten = true
                        updatePillStatus(true)
                    }
                    .buttonStyle(PIMGreenButton())
                    .padding(.bottom, 10)
                } else {
                    Button("앗! 잘못 눌렀어요") {
                        pillStatusObserver.isPillEaten = false
                        updatePillStatus(false)
                    }
                    .buttonStyle(PIMStrokeButton())
                    .padding(.bottom, 10)
                }
            }
            .onAppear {
                fetchPillStatusFromWatch()
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
/*
                firestoreManager.fetchData { exists in
                    if exists {
                        firestoreManager.updateIsPillEaten(isPillEaten: newValue)
                    } else {
                        Task {
                            await firestoreManager.createData(notificationTime: Date(), isPillEaten: newValue)
                        }
                    }
                }
*/
                // 현재 시간과 함께 새로운 PillStatus 객체를 생성
                let newPillStatus = PillStatus(isPillEaten: newValue, pillDate: Date().getFormattedDate())
                
                // FirestoreManager에 새 PillStatus 객체 저장
                firestoreManager.savePillStatus(pillStatus: newPillStatus)

            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            .background(Color.backgroundWhite)
        }
        .onAppear {
            // 현재 날짜를 문자열로 가져옴
            let currentDateStr = getCurrentDateString()
            
            // 현재 날짜에 대한 isPillEaten 값을 가져오기
            if let pillStatus = UserDefaults.standard.object(forKey: currentDateStr) as? Bool {
                pillStatusObserver.isPillEaten = pillStatus
            } else {
                // 값이 없다면 false로 설정
                pillStatusObserver.isPillEaten = false
            }
            
            // UserDefaults에서 현재 날짜에 해당하는 isPillEaten 값을 가져옴
            let eatenStatus = UserDefaults.standard.bool(forKey: currentDateStr)
            
            // 가져온 값으로 isPillEaten 상태를 업데이트
            pillStatusObserver.isPillEaten = eatenStatus
            
            // 워치로부터 약 복용 상태를 받아오는 함수 호출
            fetchPillStatusFromWatch()
            
            //firestore
//            firestoreManager.fetchData { exists in
//                if exists {
//                    // Firestore 데이터 처리 (필요 시)
//                }
//            }
        }
        
    }
    
    // 상태 업데이트 및 워치에 전송
    private func updatePillStatus(_ status: Bool) {
        pillStatusObserver.isPillEaten = status
        
    }
    
    // MARK: (GET) 워치로부터 데이터 받아오기
    private func fetchPillStatusFromWatch() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["RequestPillStatus": true], replyHandler: { response in
                DispatchQueue.main.async {
                    if let status = response["PillEaten"] as? Bool {
                        pillStatusObserver.isPillEaten = status
                    }
                }
            }) { error in
                print("Error requesting pill status: \(error.localizedDescription)")
            }
        }
    }
    
    private func getCurrentDateString() -> String {
        return DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
    }
}

// MARK: isPillEaten Status 관찰
class PillStatusObserver: ObservableObject {
    @Published var isPillEaten: Bool = false {
        didSet {
            let currentDateStr = getCurrentDateString()
            UserDefaults.standard.set(isPillEaten, forKey: currentDateStr)
            sendPillStatusToWatch(isPillEaten)
            print("isPillEaten updated to: \(isPillEaten)")
            print("저장된 값 (\(currentDateStr)): \(isPillEaten)")
        }
    }
    
    init() {
        self.isPillEaten = getCurrentPillStatus()
    }
    
    private func getCurrentPillStatus() -> Bool {
        let currentDateStr = getCurrentDateString()
        return UserDefaults.standard.bool(forKey: currentDateStr)
    }
    
    private func getCurrentDateString() -> String {
        return DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
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
