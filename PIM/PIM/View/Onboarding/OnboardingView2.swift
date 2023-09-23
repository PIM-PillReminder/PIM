//
//  OnboardingView3.swift
//  PIM
//
//  Created by 신정연 on 2023/09/16.
//

import SwiftUI


enum Pills: String, CaseIterable, Identifiable {
    case 쎄스콘정
    case 에이리스정
    case 미니보라30
    case 트리퀼라
    var id: String { self.rawValue }
}

struct OnboardingView2: View {
     
    @Environment(\.presentationMode) var presentationMode
    
    
    let pills = ["쎄스콘정", "에이리스정", "미니보라30", "트리퀼라"]

    @State private var selectedPill : String = ""
    @State private var isPickerVisible = false
    @State private var isNextButtonActive : Bool = false
    
    
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.black)
                        .font(.system(size: 24))
                        .fontWeight(.regular)
                }
                .padding(.leading, 15)
                Spacer()
                Text("당신의 일상에, 핌")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .frame(alignment: .center)
                    .padding(.trailing, 25)
                Spacer()
            }
            ProgressView(value: 40, total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                .padding(.bottom, 40)
            Text("어떤 약인가요?")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .padding(.bottom, 5)
            Text("약 종류를 기록하면\n내게 맞는 약을 찾기가 쉬워져요.")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 40)
                .lineSpacing(3)
            Image("character_onboarding_big")
                .resizable()
                .frame(width: 200, height: 200)
                .padding(.bottom, 50)
            
            //                Picker("약을 선택해주세요.", selection: $selected_pill){
            //                    ForEach(0..<pills.count){
            //                        Text(self.pills[$0])
            //                    }
            //                }
            //                List{
            //                    Picker("약을 선택해주세요.", selection: $selected_pill) {
            //                        Text("쎄스콘정").tag(Pills.쎄스콘정)
            //                        Text("미니보라30").tag(Pills.미니보라30)
            //                        Text("에이리스정").tag(Pills.에이리스정)
            //                        Text("트리퀼라").tag(Pills.트리퀼라)
            //                    }
            //                    .pickerStyle(.inline)
            //                }
            Button(action: {
                isPickerVisible.toggle()
            }) {
                HStack {
                    Text("약을 선택해주세요")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding()
//                            .background(Color.white)
                        .cornerRadius(20)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.black)
                        .padding(.trailing, 10)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 2)
                )
                
                    
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.bottom, 10)
            
            if isPickerVisible {
                Picker("약을 선택해주세요", selection: $selectedPill) {
                    ForEach(pills, id: \.self) { pill in
                        Text(pill)
                            .tag(pill)
                            .font(.system(size: 18))
                            .foregroundColor(selectedPill == pill ? .black : .gray)
                            .fontWeight(selectedPill == pill ? .bold : .medium)
                            .padding()
//                                .background(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 30)
//                                        .foregroundColor(selectedPill == pill ? .gray : .clear)
//                                )
                    }
                }
                
                .pickerStyle(.inline)
                .transition(.slide) // Picker를 부드럽게 보이도록 애니메이션 추가
            }
            Spacer()
            
            NavigationLink(destination: OnboardingView3()) {
                Text("선택했어요")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.top, 40)
            .padding(.bottom, 10)
            .background(Color.gray)
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

struct OnboardingView2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView2()
    }
}
