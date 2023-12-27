//
//  ColorExtension.swift
//  PIM
//
//  Created by 장수민 on 2023/09/20.
//

import Foundation
import SwiftUI

extension Color {
    static var backgroundGray = Color("backgroundGray")
    static var backgroundWhite = Color("backgroundWhite")
    static var boxWhite = Color("boxWhite")
    static var buttonStrokeGreen = Color("buttonStrokeGreen")
    static var disabledGray = Color("disabledGray")
    static var primaryGreen = Color("primaryGreen")
    static var subtitleGray = Color("subtitleTextGray")
    static var modalGray = Color("modalGray")
    static var boxChevronGray = Color("boxChevronGray")
    static var pimBlack = Color("pimBlack")
    static var settingDisabledGray = Color("settingDisabledGray")
    static var pimWhite = Color("pimWhite")
    static var watchTextGreen = Color("watchTextGreen")
    
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
                .foregroundColor(.backgroundGray)
                .overlay(Text("backgroundGray"))
          Rectangle()
              .foregroundColor(.backgroundWhite)
              .overlay(Text("backgroundWhite"))
          Rectangle()
              .foregroundColor(.boxWhite)
              .overlay(Text("boxWhite"))
          Rectangle()
              .foregroundColor(.buttonStrokeGreen)
              .overlay(Text("buttonStrokeGreen"))
          Rectangle()
              .foregroundColor(.disabledGray)
              .overlay(Text("disabledGray"))
          Rectangle()
              .foregroundColor(.subtitleGray)
              .overlay(Text("subtitleGray"))
          Rectangle()
              .foregroundColor(.primaryGreen)
              .overlay(Text("primaryGreen"))
          Rectangle()
              .foregroundColor(.modalGray)
              .overlay(Text("modalGray"))
          Rectangle()
              .foregroundColor(.backgroundGray)
              .overlay(Text("backgroundGray"))
          Rectangle()
              .foregroundColor(.backgroundGray)
              .overlay(Text("backgroundGray"))
        }
    }
}
