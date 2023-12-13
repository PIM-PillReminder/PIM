//
//  LottieView.swift
//  PIM
//
//  Created by 신정연 on 2023/09/27.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    @Binding var playLottie: Bool
    
    var tapPlay: Bool
    var name : String
    var loopMode: LottieLoopMode
    var delay: Double
    
    init(jsonName: String = "", loopMode: LottieLoopMode = .playOnce, delay: Double = 0.0, playLottie: Binding<Bool>, tapPlay: Bool = false){
        self.name = jsonName
        self.loopMode = loopMode
        self.delay = delay
        _playLottie = playLottie
        self.tapPlay = tapPlay
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundBehavior = .pauseAndRestore
        
        if tapPlay {
            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
            animationView.addGestureRecognizer(tapGesture)
        }
        
        view.addSubview(animationView)
        // 레이아웃의 높이와 넓이의 제약
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let animationView = uiView.subviews.first(where: { $0 is LottieAnimationView }) as? LottieAnimationView
        
        if playLottie {
            animationView?.play()
        } else {
            animationView?.stop()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: LottieView
        
        init(_ parent: LottieView) {
            self.parent = parent
        }
        
        @objc func handleTap() {
            parent.playLottie = true
        }
    }
}
