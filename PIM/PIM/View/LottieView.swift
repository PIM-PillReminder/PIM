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
    
    // 간단하게 View로 JSON 파일 이름으로 애니메이션을 실행합니다.
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
        // AspectFit으로 적절한 크기의 에니매이션을 불러옵니다.
        animationView.contentMode = .scaleAspectFit
        // 애니메이션 Loop
        animationView.loopMode = loopMode
        if playAnimation{
            // 애니메이션 딜레이 후 재생
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animationView.play()
            }
            // 백그라운드에서 재생이 멈추는 오류를 잡습니다
            animationView.backgroundBehavior = .pauseAndRestore
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        //레이아웃의 높이와 넓이의 제약
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
