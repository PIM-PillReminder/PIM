//
//  MainView.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @EnvironmentObject var firestoreManager: FireStoreManager
    @AppStorage("hasVisitedNotice") private var hasVisitedNotice = false
    
    var body: some View {
        NavigationStack {
            VStack {
                headerView
                
                Spacer()
                
                pillStatusView
                
                Spacer()
                
                lottieView
                
                Spacer()
                
                pillActionButton
            }
            .onAppear {
                viewModel.loadPillStatus()
            }
            .onChange(of: viewModel.isPillEaten) { newValue in
                viewModel.updatePillStatus(newValue, takenTime: newValue ? Date() : nil)
            }
            .background(Color.backgroundWhite)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var headerView: some View {
        
        ZStack {
            HStack {

                NavigationLink(destination: NoticeView(hasVisitedNotice: $hasVisitedNotice)) {
                    ZStack {
                        
                        LottieView(jsonName: "BellIcon",
                                   loopMode: .playOnce,
                                   playLottie: .constant(true))
                            .frame(width: 30, height: 30)
                            .padding(.leading, 18)
                        
                        // 뱃지 추가
                        if !hasVisitedNotice {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 7, height: 7)
                                .offset(x: 11, y: -11)
                        }
                    }
                    .padding(.leading, 18)
                }
                
                Spacer()
                
                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 24))
                        .foregroundColor(Color.primaryGreen)
                        .padding(.trailing, 18)
                }
            }
            
            NavigationLink(destination: CalendarViewRepresentable().navigationBarBackButtonHidden()) {
                Text(viewModel.currentDateString)
                    .foregroundColor(.pimBlack)
                    .font(.pretendard(.medium, size: 16))
                    .padding(.trailing, 6)
            }
            .buttonStyle(PIMCalendarButton())
        }
        .padding(.top, 15)
        .padding(.bottom, 95)
    }
    
    private var pillStatusView: some View {
        
        VStack(spacing: 0) {
            Text(viewModel.isPillEaten ? "약 먹기 완료! 내일 만나요!" : "오늘 약을 먹었나요?")
                .font(.pretendard(.bold, size: 18))
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            if viewModel.isPillEaten {
                Text(viewModel.pillTakenTimeString)
                    .font(.pretendard(.regular, size: 16))
                    .foregroundColor(Color("gray08"))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var lottieView: some View {
        
        LottieView(jsonName: viewModel.isPillEaten ? "happyPimi" : "sadPimi",
                   loopMode: .playOnce,
                   playLottie: $viewModel.playLottie,
                   tapPlay: true)
        .padding(.bottom, 50)
        .id(UUID())
    }
    
    private var pillActionButton: some View {
        
        Group {
            if viewModel.isPillEaten {
                Button("앗! 잘못 눌렀어요") {
                    viewModel.togglePillStatus()
                    viewModel.playLottie = true
                }
                .buttonStyle(PIMStrokeButton())
            } else {
                Button("오늘의 약을 먹었어요") {
                    viewModel.togglePillStatus()
                    viewModel.playLottie = true
                }
                .buttonStyle(PIMGreenButton())
            }
        }
        .padding(.bottom, 10)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
