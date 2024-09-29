//
//  CalendarTodayNotYetBottomView.swift
//  PIM
//
//  Created by Madeline on 9/18/24.
//

import UIKit

class CalendarTodayNotYetBottomView: UIView {
    
    let dateLabel = UILabel()
    let bottomBackground = UIView()
    let pillLabel = UILabel()
    let pillImageView = UIImageView()
    var selectedDate: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureConstraints()
        showDetailVC()
    }
    
    private func configureView() {
        
        self.backgroundColor = UIColor(named: "gray02")
        
        self.addSubview(dateLabel)
        self.addSubview(bottomBackground)
        self.addSubview(pillLabel)
        self.addSubview(pillImageView)
        
        bottomBackground.backgroundColor = .white
        bottomBackground.layer.cornerRadius = 16
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dateLabel.textColor = .black
        
        pillLabel.text = "아직 안 먹었어요"
        pillLabel.font = .systemFont(ofSize: 16, weight: .medium)
        pillLabel.textColor = .black
        
        pillImageView.image = UIImage(named: "calendar_today")
    }
    
    private func configureConstraints() {
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        bottomBackground.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(18)
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.height.equalTo(70)
        }
        
        pillLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.leading.equalTo(bottomBackground.snp.leading).inset(18)
        }
        
        pillImageView.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.trailing.equalTo(bottomBackground.snp.trailing).inset(18)
            make.size.equalTo(30)
        }
    }
    
    func showDetailVC() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomBackgroundTapped))
        bottomBackground.addGestureRecognizer(tapGesture)
        bottomBackground.isUserInteractionEnabled = true
    }
    
    @objc private func bottomBackgroundTapped() {
        guard let date = selectedDate else {
            print("No date selected")
            return
        }
        showDetailModal(for: date)
    }
    
    private func showDetailModal(for selectedDate: Date) {
        print("showDetailModal called for date: \(selectedDate)")
        let height = UIScreen.main.bounds.height * 0.6
        let detailVC = CalendarDetailViewController(modalHeight: height, selectedDate: selectedDate)
        if let parentVC = self.window?.rootViewController {
            detailVC.modalPresentationStyle = .pageSheet
            if let sheet = detailVC.sheetPresentationController {
                sheet.detents = [.custom { context in
                    return height
                }]
                sheet.selectedDetentIdentifier = .large
                sheet.prefersGrabberVisible = false
            }
            parentVC.present(detailVC, animated: true, completion: nil)
        }
    }
}
