//
//  CalendarInfoViewController.swift
//  PIM
//
//  Created by Madeline on 2/25/24.
//

import SnapKit
import UIKit

class CalendarInfoViewController: UIViewController {
    
    var dismissalCompletion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let screenHeight = UIScreen.main.bounds.height
        let isSmallDevice = screenHeight <= 700
        
        let xPosition = (UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.9) / 3
        let yPosition = view.safeAreaInsets.top + 60
        
        let popupView = UIView()
        popupView.backgroundColor = UIColor(named: "ExcptWhite12")
        popupView.layer.cornerRadius = 16
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(isSmallDevice ? 0.2 : 0.17)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(yPosition)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGesture)
        
        // 각 세트(이미지+라벨)를 위한 수직 스택뷰 생성
        func createSetStackView(image: UIImage?, text: String) -> UIStackView {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.snp.makeConstraints { make in
                make.size.equalTo(30)
            }
            
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14, weight: .medium)
            
            let stackView = UIStackView(arrangedSubviews: [imageView, label])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 12
            return stackView
        }
        
        let set1 = createSetStackView(image: UIImage(named: "calendar_today"), text: "복용 전")
        let set2 = createSetStackView(image: UIImage(named: "calendar_green"), text: "복용 완료")
        let set3 = createSetStackView(image: UIImage(named: "calendar_red"), text: "미복용")
        
        // 세트들을 담는 수평 스택뷰 생성
        let mainStackView = UIStackView(arrangedSubviews: [set1, set2, set3])
        mainStackView.axis = .horizontal
        mainStackView.distribution = .equalCentering
        mainStackView.alignment = .center
        mainStackView.layoutMargins = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        popupView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(popupView).inset(16)
        }
        
        // let imageView4 = UIImageView(image: UIImage(named: "calendar_gray"))
        // imageView4.contentMode = .scaleAspectFit
        // imageView4.clipsToBounds = true
        
        // let infoLabel4 = UILabel()
        // infoLabel4.text = "휴약기"
        // infoLabel4.textAlignment = .center
        // infoLabel4.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    @objc func dismissModal() {
        dismiss(animated: true) { [weak self] in
            self?.dismissalCompletion?()
        }
    }
}
