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
        
        let width = UIScreen.main.bounds.width * 0.9
        let height = UIScreen.main.bounds.height * 0.15
        let xPosition = (UIScreen.main.bounds.width - width) / 3
        let yPosition = (UIScreen.main.bounds.height - height) / 5
        
        let popupView = UIView()
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 12
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        popupView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGesture)
        
        let imageView1 = UIImageView(image: UIImage(named: "calendar_today"))
        imageView1.backgroundColor = .clear
        imageView1.contentMode = .scaleAspectFit
        imageView1.clipsToBounds = true
        imageView1.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        let imageView2 = UIImageView(image: UIImage(named: "calendar_green"))
        imageView2.contentMode = .scaleAspectFit
        imageView2.clipsToBounds = true
        
        let imageView3 = UIImageView(image: UIImage(named: "calendar_red"))
        imageView3.contentMode = .scaleAspectFit
        imageView3.clipsToBounds = true
        
        let imageView4 = UIImageView(image: UIImage(named: "calendar_gray"))
        imageView4.contentMode = .scaleAspectFit
        imageView4.clipsToBounds = true
        
        // 이미지 뷰들을 위한 수평 스택 뷰 생성
        let imagesStackView = UIStackView(arrangedSubviews: [imageView1, imageView2, imageView3, imageView4])
        imagesStackView.axis = .horizontal
        imagesStackView.distribution = .fillEqually
        imagesStackView.spacing = 24
        imagesStackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        imagesStackView.isLayoutMarginsRelativeArrangement = true
        
        // 레이블들을 초기화하고 텍스트 설정
        let infoLabel1 = UILabel()
        infoLabel1.text = "복용 전"
        infoLabel1.textAlignment = .center
        infoLabel1.font = .systemFont(ofSize: 14, weight: .medium)
        let infoLabel2 = UILabel()
        infoLabel2.text = "복용 완료"
        infoLabel2.textAlignment = .center
        infoLabel2.font = .systemFont(ofSize: 14, weight: .medium)
        let infoLabel3 = UILabel()
        infoLabel3.text = "미복용"
        infoLabel3.textAlignment = .center
        infoLabel3.font = .systemFont(ofSize: 14, weight: .medium)
        let infoLabel4 = UILabel()
        infoLabel4.text = "휴약기"
        infoLabel4.textAlignment = .center
        infoLabel4.font = .systemFont(ofSize: 14, weight: .medium)
        

        // 레이블들을 위한 수평 스택 뷰 생성
        let labelsStackView = UIStackView(arrangedSubviews: [infoLabel1, infoLabel2, infoLabel3, infoLabel4])
        labelsStackView.axis = .horizontal
        labelsStackView.distribution = .fillEqually
        labelsStackView.spacing = 24
        
        // 이미지와 레이블 스택 뷰를 포함하는 수직 스택 뷰 생성
        let mainStackView = UIStackView(arrangedSubviews: [imagesStackView, labelsStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        
        popupView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(popupView).inset(16)
        }
    }
    
    @objc func dismissModal() {
        dismiss(animated: true) { [weak self] in
            self?.dismissalCompletion?()
        }
    }
}


#Preview {
    CalendarInfoViewController()
}
