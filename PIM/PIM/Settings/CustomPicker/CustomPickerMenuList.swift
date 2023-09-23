//
//  DropDownPicker.swift
//  PIM
//
//  Created by 장수민 on 2023/09/19.
//

import SwiftUI

struct CustomPickerMenuList: View {
    let list = AlertStrength.list
    @Binding var selectedStrength: AlertStrength
    let sendAction: (_ strength: AlertStrength) -> Void
    
    
    var body: some View {
        LazyVStack {
            ForEach(list) { strength in
                Button {
                    sendAction(strength)
                } label: {
                    Text(strength.title)
                        .foregroundColor(.black)
                        .padding(.vertical, 7)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.vertical, 7)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.gray)
        }
    }
}

struct DropDownPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPickerMenuList(selectedStrength: .constant(AlertStrength.list[0]), sendAction: {_ in})
    }
}

struct AlertStrength: Identifiable {
    let id = UUID().uuidString
    let title: String
    
    static let list: [AlertStrength] = [
        AlertStrength(title: "매우 강하게"),
        AlertStrength(title: "강하게"),
        AlertStrength(title: "보통 정도로"),
        AlertStrength(title: "약하게")
    ]
}
