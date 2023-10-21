//
//  LottieView.swift
//  PIM
//
//  Created by 신정연 on 2023/09/27.
//
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name : String
    var loopMode: LottieLoopMode
    var delay: Double
    var playAnimation : Bool
    
    init(jsonName: String = "", loopMode : LottieLoopMode = .playOnce, delay: Double = 0.0, playAnimation : Bool = true){
        self.name = jsonName
        self.loopMode = loopMode
        self.delay = delay
        self.playAnimation = playAnimation
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        if playAnimation{
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animationView.play()
            }
            animationView.backgroundBehavior = .pauseAndRestore
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        // 레이아웃의 높이와 넓이의 제약
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
