//
//  LottieTestView.swift
//  PIM
//
//  Created by 신정연 on 2023/09/27.
//

import SwiftUI

struct LottieTestView: View {
    var body: some View {
        VStack {
            LottieView(jsonName: "PimiShining", loopMode: .playOnce, playAnimation: true)
            LottieView(jsonName: "PimiNoPill", loopMode: .playOnce, playAnimation: true)
            LottieView(jsonName: "PimiTime", loopMode: .playOnce, playAnimation: true)
            LottieView(jsonName: "PimiYesPill", loopMode: .playOnce, playAnimation: true)
        }
    }
}

struct LottieTestView_Previews: PreviewProvider {
    static var previews: some View {
        LottieTestView()
    }
}
