//
//  CustomStyle.swift
//  PIM
//
//  Created by 장수민 on 2023/09/23.
//

import SwiftUI

struct PIMGreenButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
          RoundedRectangle(cornerRadius: 40)
            .frame(width: wLength())
            .frame(height: hLength())
            .foregroundStyle(Color.primaryGreen)
            .overlay {
              Text(title)
                .font(.caption)
                .foregroundStyle(Color.pimWhite)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PIMStrokeButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
          RoundedRectangle(cornerRadius: 40)
            .stroke(Color.buttonStrokeGreen, lineWidth: 1)
            .frame(height: hLength())
            .frame(maxWidth: wLength())
            .overlay {
              Text(title)
                .font(.caption)
                .foregroundStyle(Color.buttonStrokeGreen)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public func hMargin() -> Double {
    let screenHeight = WKInterfaceDevice.current().screenBounds.size.height
    
    return screenHeight >= 240 ? 11 : 10
}
public func wLength() -> Double {
    let screenHeight = WKInterfaceDevice.current().screenBounds.size.height
    
  return screenHeight >= 240 ? 184 : 158
}
public func hLength() -> Double {
  let screenHeight = WKInterfaceDevice.current().screenBounds.size.height
  return screenHeight >= 240 ? 45 : 40
}
