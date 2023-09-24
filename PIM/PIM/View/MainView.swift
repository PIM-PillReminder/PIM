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
                isPillEaten.toggle()
                UserDefaults.standard.set(isPillEaten, forKey: "PillEaten")
            }) {
                ZStack {
                    if(!isPillEaten){
                        Rectangle()
                            .fill(Color.pimGreen)
                            .cornerRadius(16)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                            .padding(.top, 40)
                            .padding(.bottom, 10)
                    }
                    else{
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(16)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.pimGreen, lineWidth: 2)
                                )
                            .padding(.top, 40)
                            .padding(.bottom, 10)
                            
                    }
                    
                    Text(isPillEaten ? "약 복용을 취소할게요" : "오늘의 약을 복용 했어요")
                        .font(.pretendard(.medium, size: 18))
                        .foregroundColor(isPillEaten ? Color.pimGreen : Color.white)
                        .padding(.top, 30)
                }
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
