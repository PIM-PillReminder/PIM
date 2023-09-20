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
    static let paleRed = Color(hex: "ECAAAA")
    static let paleBlue = Color(hex: "C2D7EF")
    static let paleYellow = Color(hex: "F3DAA8")
    static let pastelLilac = Color(hex: "D4B1CA")
    static let lightGray = Color(hex: "D9D9D9")
    static let textBlack = Color(hex: "1D1D1D")
    
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
                .foregroundColor(.paleRed)
            Rectangle()
                .foregroundColor(.paleBlue)
            Rectangle()
                .foregroundColor(.paleYellow)
            Rectangle()
                .foregroundColor(.pastelLilac)
            Rectangle()
                .foregroundColor(.lightGray)
            Rectangle()
                .foregroundColor(.textBlack)
                
        }
    }
}
