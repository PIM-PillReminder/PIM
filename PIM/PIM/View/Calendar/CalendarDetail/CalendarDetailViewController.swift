//
//  CalendarDetailViewController.swift
//  PIM
//
//  Created by Madeline on 9/26/24.
//

import UIKit
import SnapKit

class CalendarDetailViewController: UIViewController {
    
    private let closeButton = UIButton()
    private let pillStatusImageView = UIImageView()
    private let dateLabel = UILabel()
    private let todayLabel = UILabel()
    private let pillStatusTitleLabel = UILabel()
    private let pillStatusLabel = UILabel()
    
    private var modalHeight: CGFloat
    
    init(modalHeight: CGFloat) {
        self.modalHeight = modalHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Close Button
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // Image View
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "your_image")
        view.addSubview(imageView)
        
        // Date Label
        dateLabel.text = "2024-09-26"
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(dateLabel)
        
        todayLabel.text = "오늘"
        todayLabel.font = UIFont.boldSystemFont(ofSize: 12)
        todayLabel.backgroundColor = .green
        todayLabel.layer.cornerRadius = 10
        todayLabel.clipsToBounds = true
        todayLabel.textAlignment = .center
        todayLabel.isHidden = true
        view.addSubview(todayLabel)
        
        pillStatusTitleLabel.text = "복용 여부"
        pillStatusTitleLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(pillStatusTitleLabel)
    
        pillStatusLabel.text = "아직 안 먹었어요"
        pillStatusLabel.font = UIFont.systemFont(ofSize: 16)
        pillStatusLabel.textColor = .systemBlue
        view.addSubview(pillStatusLabel)
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(44)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(64)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        // Date Label and Today Label Constraints (HStack 방식)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        todayLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.centerY.equalTo(dateLabel)
            make.width.equalTo(40)
            make.height.equalTo(24)
        }
        
        pillStatusTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
        }
        
        pillStatusLabel.snp.makeConstraints { make in
            make.leading.equalTo(pillStatusTitleLabel.snp.trailing).offset(8)
            make.centerY.equalTo(pillStatusTitleLabel)
        }
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preferredContentSize = CGSize(width: view.frame.width, height: modalHeight)
    }
    
}
