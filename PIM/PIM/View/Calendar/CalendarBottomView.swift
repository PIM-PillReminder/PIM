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
    let bottomBackground = UIView()
    let pillLabel = UILabel()
    let pillTimeImage = UIImageView()
    let pillTakenTimeLabel = UILabel()
    let pillImageView = UIImageView()
    
    var selectedDate: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureConstraints()
        fetchPillTakenTime()
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
        self.addSubview(bottomBackground)
        self.addSubview(pillLabel)
        self.addSubview(pillTimeImage)
        self.addSubview(pillTakenTimeLabel)
        self.addSubview(pillImageView)
        
        bottomBackground.backgroundColor = .white
        bottomBackground.layer.cornerRadius = 16
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dateLabel.textColor = .black
        
        pillLabel.text = "복용 완료"
        pillLabel.font = .systemFont(ofSize: 18, weight: .medium)
        pillLabel.textColor = .black
        
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
        
        pillImageView.image = UIImage(named: "calendar_green")
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
            make.top.equalTo(bottomBackground.snp.top).offset(12)
            make.leading.equalTo(bottomBackground.snp.leading).inset(18)
        }
        
        pillTimeImage.snp.makeConstraints { make in
            make.top.equalTo(pillLabel.snp.bottom).offset(6)
            make.leading.equalTo(bottomBackground.snp.leading).inset(18)
            make.size.equalTo(17)
        }
        
        pillTakenTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(pillLabel.snp.bottom).offset(6)
            make.leading.equalTo(pillTimeImage.snp.trailing).offset(6)
        }
        
        pillImageView.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.trailing.equalTo(bottomBackground.snp.trailing).inset(18)
            make.size.equalTo(30)
        }
    }
    
    func fetchPillTakenTime() {
        guard let selectedDate = selectedDate else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateKey = dateFormatter.string(from: Calendar.current.startOfDay(for: selectedDate))
        
        if let pillTime = UserDefaults.standard.object(forKey: "pillTakenTime_\(dateKey)") as? Date {
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale(identifier: "ko_KR")
            timeFormatter.dateFormat = "a h:mm"
            pillTakenTimeLabel.text = timeFormatter.string(from: pillTime)
        } else {
            pillTakenTimeLabel.text = "복용 기록 없음"
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        fetchPillTakenTime() // 화면이 나타날 때 다시 데이터를 불러옴
    }
}
