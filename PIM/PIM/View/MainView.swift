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
    
    @State private var isPillEaten: Bool = UserDefaults.standard.bool(forKey: "PillEaten")
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 24))
                        .foregroundColor(Color.black)
                        .padding(.leading, 20)
                }
                Spacer()
                Text(dateFormatter.string(from: Date()))
                    .font(.pretendard(.bold, size: 18))
                Spacer()
                // TODO: CalendarView로 연결
                NavigationLink(destination: MainView()) {
                    Image(systemName: "calendar")
                        .font(.system(size: 24))
                        .padding(.trailing, 20)
                        .foregroundColor(Color.white)
                }
            }
            .padding(.top, 10)
            Spacer()
            VStack{
                Image("pill")
                    .padding(.bottom, 10)
                Text(isPillEaten ? "약 먹기 완료! 내일 만나요!" : "오늘의 약을 아직 안 먹었어요")
                    .font(.pretendard(.bold, size: 18))
                    .multilineTextAlignment(.center)
            }
            Spacer()
            if(isPillEaten){
                Image("charactermain_yes_pill")
                    .resizable()
                    .frame(width: 340, height: 260)
                    .padding(.bottom, 50)
                    .shadow(color: Color(red: 0.5, green: 0.5, blue: 0.5)
                        .opacity(0.25),
                            radius: 20,
                            x: 0,
                            y: 6)
            }
            else{
                Image("charactermain_no_pill")
                    .resizable()
                    .frame(width: 300, height: 220)
                    .padding(.bottom, 50)
            }
            Spacer()
            
            if(!isPillEaten){
                Button("오늘의 약을 먹었어요") {
                    isPillEaten = true
                    UserDefaults.standard.set(isPillEaten, forKey: "PillEaten")
                    // 알림 비활성화
                    notificationManager.disableNotifications()
                    print("메인뷰: removeAllPendingNotificationRequests\n")
                }
                .buttonStyle(PIMGreenButton())
                .padding(.bottom, 10)
            } else {
                Button("앗! 잘못 눌렀어요") {
                    isPillEaten = false
                    UserDefaults.standard.set(isPillEaten, forKey: "PillEaten")
                    // 알림 활성화
                    notificationManager.enableNotifications()
                    print("메인뷰: enableNotifications\n")
                }
                .buttonStyle(PIMStrokeButton())
                .padding(.bottom, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
