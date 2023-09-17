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
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: MainView()) {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color.black)
                        .padding(.leading, 20)
                }
                Spacer()
                Text(dateFormatter.string(from: Date()))
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                Spacer()
                NavigationLink(destination: MainView()) {
                    Image(systemName: "calendar")
                        .padding(.trailing, 20)
                        .foregroundColor(Color.black)
                }
            }
            Spacer()
            Image("character_onboarding_big")
                .resizable()
                .frame(width: 200, height: 200)
                .padding(.bottom, 50)
            Spacer()
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
                
            }) {
                ZStack {
                    Rectangle()
                        .fill(Color.gray)
                        .cornerRadius(16)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
                        .padding(.top, 40)
                        .padding(.bottom, 10)
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
