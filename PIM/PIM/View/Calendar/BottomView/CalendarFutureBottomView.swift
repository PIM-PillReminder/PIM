//
//  CalendarFutureBottomView.swift
//  PIM
//
//  Created by Madeline on 9/30/24.
//

import UIKit
import SnapKit

class CalendarFutureBottomView: UIView {
    
    let dateLabel = UILabel()
    let bottomBackground = UIView()
    let pillLabel = UILabel()
    
    var selectedDate: Date?
    var message: String? {
        didSet {
            pillLabel.text = message
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureConstraints()
    }
    
    private func configureView() {
        self.backgroundColor = UIColor(named: "gray02")
        
        self.addSubview(dateLabel)
        self.addSubview(bottomBackground)
        self.addSubview(pillLabel)
        
        bottomBackground.backgroundColor = UIColor(named: "gray03")
        bottomBackground.layer.cornerRadius = 16
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        dateLabel.text = dateFormatter.string(from: selectedDate ?? Date())
        dateLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dateLabel.textColor = UIColor(named: "black")
        
        pillLabel.text = "복약 기록은 해당 날짜부터 표시돼요"
        pillLabel.font = .systemFont(ofSize: 16, weight: .medium)
        pillLabel.textColor = UIColor(named: "gray06")
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
            make.center.equalTo(bottomBackground)
        }
    }
    
    func updateSelectedDate(newDate: Date) {
        selectedDate = newDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        dateLabel.text = dateFormatter.string(from: newDate)
    }
}
