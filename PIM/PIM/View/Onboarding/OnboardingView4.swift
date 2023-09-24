//
//  OnboardingView5.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI

struct OnboardingView4: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State var selectedTime: Date
    @State private var isMainViewActive = false
    let notificationManager = LocalNotificationManager()
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.black)
                            .font(.pretendard(.regular, size: 24))
                    }
                    .padding(.leading, 15)
                    Spacer()
                    Text("시작하기")
                        .font(.pretendard(.bold, size: 18))
                        .frame(alignment: .center)
                        .padding(.trailing, 30)
                    Spacer()
                }
                .padding(.top, 10)
                // TODO: 2차 업데이트 시 value: 80으로 변경
                ProgressView(value: 0, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .pimGreen))
                    .padding(.bottom, 30)
                Text("몇 시에 약을 먹나요?")
                    .font(.pretendard(.bold, size: 24))
                    .frame(alignment: .center)
                    .padding(.bottom, 5)
                Text("선택한 복용 시간을 바탕으로 알림이 울려요.")
                    .font(.pretendard(.regular, size: 18))
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
                Image("character_time")
                    .shadow(color: Color(red: 0, green: 0, blue: 0),
                            radius: 28,
                            x: 0,
                            y: 4)
                    .padding(.bottom, 10)
                
//                DatePicker(
//                    "",
//                    selection: $selectedTime,
//                    displayedComponents: [.hourAndMinute]
//                )
//                .datePickerStyle(.wheel)
//                .environment(\.locale, .init(identifier: "ko_KR"))
//                .onChange(of: selectedTime) { newValue in
//                    print("Selected time changed to \(newValue)")
//                }
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: [.hourAndMinute]
                )
                .labelsHidden()
                .datePickerStyle(.wheel)
                .environment(\.locale, .init(identifier: "ko_KR"))
//                .font(.pretendard(.bold, size: 18))
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .overlay(
                    Text("\(selectedTime, formatter: DateFormatter())")
                        .font(.pretendard(.bold, size: 18))
                        .foregroundColor(.red)
                )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(
//                            RadialGradient(
//                                gradient: Gradient(stops: [
//                                    Gradient.Stop(color: .gradientGreen, location: 0),
//                                    Gradient.Stop(color: .pimGreen, location: 1)
//                                ]),
//                                center: .leading,
//                                startRadius: 0,
//                                endRadius: 300
//                            ),
//                            lineWidth: 2
//                        )
//                )
//                CustomTimePicker(selectedTime: $selectedTime)
                
                
                Spacer()
                NavigationLink(destination: MainView()) {
                    Text("선택하기")
                        .font(.pretendard(.bold, size: 20))
                        .foregroundColor(Color.black)
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, 40)
                .padding(.bottom, 10)
                .background(Color.pimGreen)
                .contentShape(Rectangle())
                .onTapGesture {
                    print("Selected time: \(selectedTime)")
                    let calendar = Calendar.current
                    _ = calendar.component(.hour, from: selectedTime)
                    _ = calendar.component(.minute, from: selectedTime)
                    notificationManager.addNotification(title: "PIM")
                    UserDefaults.standard.set(selectedTime, forKey: "SelectedTime")
                    notificationManager.schedule()
                    print("alert, at onboarding5: \(selectedTime)\n")
                }
            }
                
        }
        .navigationBarBackButtonHidden(true)
    }
        
}

struct OnboardingView4_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView4(selectedTime: Date())
    }
}
