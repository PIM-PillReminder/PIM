//
//  CustomPickerMenu.swift
//  PIM
//
//  Created by 장수민 on 2023/09/19.
//

import SwiftUI

struct CustomPickerMenu: View {
    @State var isPresented: Bool = false
    @Binding var selectedStrength: AlertStrength
    
    var body: some View {
        VStack {
            HStack {
                Text(selectedStrength.title)
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                    HStack {
                        Image(systemName: isPresented ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .frame(height: 50)
            .background (
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.gray)
            )
            
            VStack {
                if isPresented {
                    CustomPickerMenuList(selectedStrength: $selectedStrength) { strength in
                        // 선택한 strength를 사용하여 업데이트 로직을 수행합니다.
                            self.selectedStrength = strength
                            self.isPresented = false // 선택 후에 메뉴를 닫을 수 있도록 isPresented도 업데이트합니다.
                                        }
                    }
                }
            }
        .frame(width: 154)
        }
    }

struct CustomPickerMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomPickerMenu(selectedStrength:.constant(AlertStrength(title: "매우 강하게")))
    }
}
