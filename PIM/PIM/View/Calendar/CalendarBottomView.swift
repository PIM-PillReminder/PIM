//
//  CalendarBottomView.swift
//  PIM
//
//  Created by Madeline on 9/18/24.
//

import UIKit
import SnapKit

class CalendarBottomView: UIView {
    
    let dateLabel = UILabel()
    let todayLabel = UILabel()
    let bottomBackground = UIView()
    let pillLabel = UILabel()
    let pillTimeImage = UIImageView()
    let pillTakenTimeLabel = UILabel()
    let pillImageView = UIImageView()
    private var dimView: UIView?
    
    var selectedDate: Date?
    weak var delegate: CalendarDetailViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureConstraints()
        fetchPillTakenTime()
        showDetailVC()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureConstraints()
        fetchPillTakenTime()
    }
    
    private func configureView() {
        
        self.backgroundColor = UIColor(named: "gray02")
        
        self.addSubview(dateLabel)
        self.addSubview(todayLabel)
        self.addSubview(bottomBackground)
        self.addSubview(pillLabel)
        self.addSubview(pillTimeImage)
        self.addSubview(pillTakenTimeLabel)
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
        
        pillLabel.text = "복용 완료"
        pillLabel.font = .systemFont(ofSize: 16, weight: .medium)
        pillLabel.textColor = UIColor(named: "black")
        
        pillTimeImage.image = UIImage(named: "clock")
        
        if let selectedDate = selectedDate {
            // 날짜를 문자열로 변환
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateKey = dateFormatter.string(from: Calendar.current.startOfDay(for: selectedDate))
            
            // UserDefaults에서 해당 날짜의 시간을 불러옴
            if let pillTime = UserDefaults.standard.object(forKey: "pillTakenTime_\(dateKey)") as? Date {
                let timeFormatter = DateFormatter()
                timeFormatter.locale = Locale(identifier: "ko_KR")
                timeFormatter.dateFormat = "a h:mm"
                pillTakenTimeLabel.text = timeFormatter.string(from: pillTime)
                
            } else {
                pillTakenTimeLabel.text = "복용 기록 없음"
                
            }
        }
        
        pillTakenTimeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        pillTakenTimeLabel.textColor = UIColor(named: "gray07")
        
        pillImageView.image = UIImage(named: "calendar_eaten")
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
            make.top.equalTo(bottomBackground.snp.top).offset(12)
            make.leading.equalTo(bottomBackground.snp.leading).inset(18)
        }
        
        pillTimeImage.snp.makeConstraints { make in
            make.centerY.equalTo(pillTakenTimeLabel)
            make.leading.equalTo(bottomBackground.snp.leading).inset(18)
            make.size.equalTo(14)
        }
        
        pillTakenTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(pillLabel.snp.bottom).offset(8)
            make.leading.equalTo(pillTimeImage.snp.trailing).offset(6)
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
        if let parentVC = self.window?.rootViewController {
            parentVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
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

    private func selectedDateIsToday() -> Bool {
        guard let selectedDate = selectedDate else {
            return false // selectedDate가 없으면 false 반환
        }
        // 선택된 날짜가 오늘인지 확인
        return Calendar.current.isDateInToday(selectedDate)
    }
    
    func updateSelectedDate(newDate: Date) {
        updateDateUI() // 날짜 변경 시 UI 업데이트
        fetchPillTakenTime() // 날짜에 맞춰 약 복용 시간도 업데이트
    }

    private func updateDateUI() {
        let isToday = selectedDateIsToday()

        // 오늘일 경우 todayLabel을 보여주고 dateLabel을 왼쪽으로 이동
        if isToday {
            print("1today")
            todayLabel.isHidden = false
            dateLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.centerX.equalToSuperview().offset(-24) // 중앙에서 왼쪽으로 24 이동
            }
        } else {
            todayLabel.isHidden = true
            dateLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.centerX.equalToSuperview() // 중앙에 위치
            }
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateDateUI()
        fetchPillTakenTime()
    }

    func fetchPillTakenTime() {
        guard let selectedDate = selectedDate else { return }
        
        let status = UserDefaultsManager.shared.getPillStatus()
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        
        if let savedStatus = status[startOfDay] {
            if savedStatus,
               let savedTime = UserDefaults.standard.object(forKey: "pillTakenTime_\(startOfDay)") as? Date {
                let timeFormatter = DateFormatter()
                timeFormatter.locale = Locale(identifier: "ko_KR")
                timeFormatter.dateFormat = "a h:mm"
                pillTakenTimeLabel.text = timeFormatter.string(from: savedTime)
            } else {
                pillTakenTimeLabel.text = "복용 기록 없음"
            }
        } else {
            pillTakenTimeLabel.text = "복용 기록 없음"
        }
    }
}
