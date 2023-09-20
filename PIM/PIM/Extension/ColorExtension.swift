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
                .foregroundColor(.pimGreen)
                .overlay(Text("pimGreen"))
            Rectangle()
                .foregroundColor(.lightGray)
                .overlay(Text("lightGray"))
        }
    }
}
