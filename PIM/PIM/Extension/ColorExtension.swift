//
//  ColorExtension.swift
//  PIM
//
//  Created by 장수민 on 2023/09/20.
//

import Foundation
import SwiftUI

import SwiftUI

extension Color {
    static let pimGreen = Color(hex: "#6CC244")
    static let lightGray = Color(hex: "#F2F2F2")
    
    static let green01 = Color(hex: "#9BDDA4")
    static let green02 = Color(hex: "#60BF6C")
    static let green03 = Color(hex: "#119822")
    static let green04 = Color(hex: "#0A5B14")
    static let green05 = Color(hex: "#073D0E")
    
    static let yellow01 = Color(hex: "#FEC100")
    static let red01 = Color(hex: "#FE784E")
    
    static let gray01 = Color(hex: "#F2F2F2")
    static let gray02 = Color(hex: "#D9D9D9")
    static let gray03 = Color(hex: "#9D9D9D")
    
    
    // lightGreen은 투명도만 조절한 거라 따로 추가는 안 했습니다
    
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

struct Color_Previews: PreviewProvider {
    static var previews: some View {
        VStack {

            Rectangle()
                .foregroundColor(.green01)
                .overlay(Text("green01"))
            Rectangle()
                .foregroundColor(.green02)
                .overlay(Text("green02"))
            Rectangle()
                .foregroundColor(.green03)
                .overlay(Text("green03"))
            Rectangle()
                .foregroundColor(.green04)
                .overlay(Text("green04").foregroundColor(.white))
            Rectangle()
                .foregroundColor(.green05)
                .overlay(Text("green05").foregroundColor(.white))
            Rectangle()
                .foregroundColor(.gray01)
                .overlay(Text("gray01"))
            Rectangle()
                .foregroundColor(.gray02)
                .overlay(Text("gray02"))
            Rectangle()
                .foregroundColor(.gray03)
                .overlay(Text("gray03"))
            Rectangle()
                .foregroundColor(.yellow01)
                .overlay(Text("yellow01"))
            Rectangle()
                .foregroundColor(.red01)
                .overlay(Text("red01"))
        }
    }
}
