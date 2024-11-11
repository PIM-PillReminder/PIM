//
//  CalendarTodayNotYetBottomView.swift
//  PIM
//
//  Created by Madeline on 9/18/24.
//

import UIKit

class CalendarTodayNotYetBottomView: UIView {
    
    let dateLabel = UILabel()
    let todayLabel = UILabel()
    let bottomBackground = UIView()
    let pillLabel = UILabel()
    let pillImageView = UIImageView()
    
    var selectedDate: Date?
    weak var delegate: CalendarDetailViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureConstraints()
        showDetailVC()
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
        self.addSubview(todayLabel)
        self.addSubview(bottomBackground)
        self.addSubview(pillLabel)
        self.addSubview(pillImageView)
        
        bottomBackground.backgroundColor = UIColor(named: "ExcptWhite10")
        bottomBackground.layer.cornerRadius = 16
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dateLabel.textColor = UIColor(named: "black")
        
        todayLabel.text = "오늘"
        todayLabel.font = .boldSystemFont(ofSize: 12)
        todayLabel.textColor = UIColor(named: "white")
        todayLabel.backgroundColor = UIColor(named: "green02")
        todayLabel.layer.cornerRadius = 10
        todayLabel.clipsToBounds = true
        todayLabel.textAlignment = .center
        todayLabel.isHidden = false
        
        pillLabel.text = "아직 안 먹었어요"
        pillLabel.font = .systemFont(ofSize: 16, weight: .medium)
        pillLabel.textColor = UIColor(named: "black")
        
        pillImageView.image = UIImage(named: "calendar_today")
    }
    
    private func configureConstraints() {
        
        dateLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview().offset(-24) // 중앙에서 왼쪽으로 24 이동
        }
        
        todayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.height.equalTo(20)
            make.width.equalTo(40)
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
        let height = UIScreen.main.bounds.height
        let modalHeight = height < 700 ? height * 0.8 : height * 0.6
        let detailVC = CalendarDetailViewController(modalHeight: modalHeight, selectedDate: selectedDate)
        
        detailVC.delegate = delegate
        
        // dismissalCompletion 추가
        detailVC.dismissalCompletion = { [weak self] in
            if let parentVC = self?.window?.rootViewController as? CalendarViewController {
                parentVC.calendar.reloadData()
                parentVC.updateBottomView(for: selectedDate)
            }
        }
        
        if let parentVC = self.window?.rootViewController {
            detailVC.modalPresentationStyle = .pageSheet
            if let sheet = detailVC.sheetPresentationController {
                sheet.detents = [.custom { context in
                    return modalHeight
                }]
                sheet.selectedDetentIdentifier = .large
                sheet.prefersGrabberVisible = false
            }
            parentVC.present(detailVC, animated: true, completion: nil)
        }
    }
}
