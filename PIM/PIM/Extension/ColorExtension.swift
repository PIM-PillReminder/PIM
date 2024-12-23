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
    static var subtitleGray = Color("subtitleTextGray")
    static var modalGray = Color("modalGray")
    static var boxChevronGray = Color("boxChevronGray")
    static var pimBlack = Color("pimBlack")
    static var settingDisabledGray = Color("settingDisabledGray")
    static var pimWhite = Color("pimWhite")
    static var watchTextGreen = Color("watchTextGreen")
    static var settingChevronDisabledGray = Color("settingChevronDisabledGray")
    static var redwarning = Color("RedWarning")
    
    static var gray01 = Color("gray01")
    static var gray02 = Color("gray02")
    static var gray03 = Color("gray03")
    static var gray04 = Color("gray04")
    static var gray05 = Color("gray05")
    static var gray06 = Color("gray06")
    static var gray07 = Color("gray07")
    static var gray08 = Color("gray08")
    static var gray09 = Color("gray09")
    static var gray10 = Color("gray10")
    static var gray11 = Color("gray11")
    static var gray12 = Color("gray12")
    
    static var green01 = Color("green01")
    static var green02 = Color("green02")
    static var green03 = Color("green03")
    static var green04 = Color("green04")
    static var green05 = Color("green05")
    
    static var excpt212 = Color("Excpt2-12")
    static var excpt11 = Color("ExcptWhite11")
    static var excpt12 = Color("ExcptWhite12")
    
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
