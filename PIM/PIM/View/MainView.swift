//
//  MainView.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct MainView: View {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    let notificationManager = LocalNotificationManager()
    
    @State private var isPillEaten: Bool = false
    @State private var playLottie: Bool = true
    @State private var tapPlay: Bool = true
    
    // 앱 시작 혹은 뷰가 로드될 때 현재 날짜의 약 복용 여부를 가져옴
    init() {
        let currentDateStr = dateFormatter.string(from: Date())
        
        if let savedStatus = UserDefaults.standard.object(forKey: currentDateStr) as? Bool {
            isPillEaten = savedStatus
        } else {
            isPillEaten = false
        }
    }

    
    var body: some View {
      NavigationStack {
        VStack {
              HStack {
                  NavigationLink(destination: SettingView().toolbarRole(.editor)) {
                      Image(systemName: "gearshape")
                          .font(.system(size: 24))
                          .foregroundColor(Color.green03)
                          .padding(.leading, 20)
                  }
                  Spacer()
  //                Text(dateFormatter.string(from: Date()))
  //                    .font(.pretendard(.bold, size: 18))
                  Spacer()
                  // TODO: CalendarView로 연결
                  NavigationLink(destination: MainView()) {
                      Image(systemName: "calendar")
                          .font(.system(size: 24))
                          .padding(.trailing, 20)
                          .foregroundColor(Color.green01)
                  }
                  .disabled(true)
              }
              .padding(.top, 10)
              .padding(.bottom, 50)
              VStack{
                  Image("pill")
                      .padding(.bottom, 30)
                  Text(isPillEaten ? "약 먹기 완료! 내일 만나요!" : "오늘의 약을 아직 안 먹었어요")
                      .font(.pretendard(.bold, size: 18))
                      .multilineTextAlignment(.center)
                      .animation(.easeInOut(duration: 0.1))
              }
              Spacer()
              if(isPillEaten) {
                  LottieView(jsonName: "happyPimiwoArms", loopMode: .playOnce, playLottie: $playLottie, tapPlay: true)
                      .padding(.bottom, 50)
                      .onTapGesture {
                          playLottie.toggle()
                      }
              }
              else {
                  LottieView(jsonName:"sadPimiwoArms", loopMode: .playOnce, playLottie: $playLottie, tapPlay: true)
                      .padding(.bottom, 50)
                      .onTapGesture {
                          playLottie.toggle()
                      }
              }
              Spacer()
              
              if(!isPillEaten){
                  Button("오늘의 약을 먹었어요") {
                      isPillEaten = true
                  }
                  .buttonStyle(PIMGreenButton())
                  .padding(.bottom, 10)
              } else {
                  Button("앗! 잘못 눌렀어요") {
                      isPillEaten = false
                  }
                  .buttonStyle(PIMStrokeButton())
                  .padding(.bottom, 10)
                  .animation(.easeInOut(duration: 0.2))
              }
          }
        .navigationBarBackButtonHidden(true)
      }
    }
    
    // 약 복용 여부를 UserDefaults에 저장하는 함수
//    func savePillStatus(_ status: Bool) {
//        let currentDateStr = dateFormatter.string(from: Date())
//        UserDefaults.standard.set(status, forKey: currentDateStr)
//        isPillEaten = status
//
//        // UserDefaults에서 오늘 날짜에 대한 값을 가져와서 출력합니다.
//        if let savedStatus = UserDefaults.standard.object(forKey: currentDateStr) as? Bool {
//            print("오늘의 약 복용 여부: \(savedStatus ? "약 먹음" : "약 안 먹음")")
//        } else {
//            print("오늘의 약 복용 여부 정보가 저장되지 않았습니다.")
//        }
//
//        if status {
//            // 약을 먹었다면, 모든 예정된 알림을 취소하고 다음날 알림을 설정합니다.
//            notificationManager.userDidTakePill()
//        } else {
//            // 약을 먹지 않았다면, 알림을 다시 활성화합니다.
//            notificationManager.enableNotifications()
//        }
//    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
