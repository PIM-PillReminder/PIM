//
//  FontExtension.swift
//  PIM
//
//  Created by 장수민 on 2023/09/20.
//

import Foundation
import SwiftUI

/// 현재 추가되어있는 프리텐다드는 light!
/// 사용법은 밑에 있습니다...


extension Font {
    enum Pretendard {
        case light
        case bold
        case medium
        case regular
        
        var value: String {
            switch self {
            case .light:
                return "Pretendard-Light"
            case .medium:
                return "Pretendard-Medium"
            case .bold:
                return "Pretendard-Bold"
            case .regular:
                return "Pretendard-Regular"
            }
        }
    }
    static func pretendard(_ type:Pretendard, size: CGFloat = 17) -> Font{
        return .custom(type.value, size: size)
    }
    
    static func cafe24OhsquareAir(size: CGFloat = 17) -> Font {
            return Font.custom("Cafe24-Ohsquareair", size: size)
        }
}

struct Font_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            // 프리텐다드 사용법
            Text("이것은 Pretendard")
                .font(.pretendard(.light, size: 17))
            Text("Pretendard Medium")
                .font(.pretendard(.medium, size: 17))
            Text("Pretendard bold")
                .font(.pretendard(.bold, size: 17))
            
            
            // 카페24 사용법
            Text("이것은 cafe24 Ohsquare air \n근데 폰트 사이즈는 똑같은데 왜 크기가 다를까요?...")
                .font(.cafe24OhsquareAir(size: 17))
        }
    }
}

