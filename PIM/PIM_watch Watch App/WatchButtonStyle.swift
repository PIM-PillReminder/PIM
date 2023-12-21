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
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16)
                                .fill(Color.green03))
        }
    }
}

struct PIMStrokeButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(Color.green03)
                .font(.system(size: 15, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.green03, lineWidth: 1))
        }
    }
}

