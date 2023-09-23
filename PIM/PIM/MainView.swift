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
    
    @State private var isPillEaten : Bool = false
    var body: some View {
        VStack {
            HStack {
                // TODO: SettingView로 연결
                NavigationLink(destination: MainView()) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 24))
                        .foregroundColor(Color.black)
                        .padding(.leading, 20)
                }
                Spacer()
                Text(dateFormatter.string(from: Date()))
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                Spacer()
                // TODO: CalendarView로 연결
                NavigationLink(destination: MainView()) {
                    Image(systemName: "calendar")
                        .font(.system(size: 24))
                        .padding(.trailing, 20)
                        .foregroundColor(Color.black)
                }
            }
            .padding(.top, 10)
            Spacer()
            VStack{
                Image("pill")
                    .padding(.bottom, 10)
                Text(isPillEaten ? "약을 먹었어요\n오늘도 힘차는 하루!" : "오늘의 약을 아직 안 먹었어요")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
            }
            Spacer()
            Image("character_onboarding_big")
                .resizable()
                .frame(width: 200, height: 200)
                .padding(.bottom, 50)
                .onTapGesture {
                    isPillEaten = true
                }
            Spacer()
            // TODO: isPillEaten -> 약을 먹었는지 확인하는 부분 연결
//            NavigationLink(destination: MainView()) {
//                ZStack {
//                    Rectangle()
//                        .fill(Color.gray)
//                        .cornerRadius(16)
//                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
//                        .padding(.top, 40)
//                        .padding(.bottom, 10)
//                }
//            }
            Button(action: {
                isPillEaten = true
            }) {
                ZStack {
                    Rectangle()
                        .fill(Color.gray)
                        .cornerRadius(16)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                    Text("오늘의 약을 복용 했어요")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(Color.black)
                        .padding(.top, 30)
                }
            }

        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
