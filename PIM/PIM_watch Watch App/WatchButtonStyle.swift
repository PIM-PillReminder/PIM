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
            Text(title)
                .foregroundColor(Color.pimWhite)
                .font(.system(size: 15, weight: .medium))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 40)
                                .fill(Color.primaryGreen))
        }
    }
}

struct PIMStrokeButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(Color.buttonStrokeGreen)
                .font(.system(size: 15, weight: .medium))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.buttonStrokeGreen, lineWidth: 1))
        }
    }
}

