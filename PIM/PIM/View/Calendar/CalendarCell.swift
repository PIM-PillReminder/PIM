//
//  CalendarCell.swift
//  PIM
//
//  Created by Madeline on 2/23/24.
//

import FSCalendar
import SnapKit
import UIKit

class CalendarCell: FSCalendarCell {
    
    // 뒤에 표시될 이미지
    var backImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var isToday: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 날짜 텍스트가 디폴트로 약간 위로 올라가 있어서, 아예 레이아웃을 잡아준다
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.centerX.equalTo(contentView)
        }
        
        contentView.insertSubview(backImageView, at: 0)
        backImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-6)
            make.centerX.equalTo(contentView)
            make.size.equalTo(30)
//            make.size.equalTo(minSize()/1.3)
        }
        backImageView.layer.cornerRadius = minSize()/3
        backImageView.backgroundColor = .clear
    }
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backImageView.image = nil
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        if isToday {
            if isSelected {
                self.backgroundColor = UIColor(named: "black")
                titleLabel.textColor = UIColor(named: "white")
            } else {
                self.backgroundColor = UIColor(named: "gray03")
                titleLabel.textColor = UIColor(named: "black")
            }
        } else if isSelected {
            self.backgroundColor = UIColor(named: "black")
            titleLabel.textColor = UIColor(named: "white")
        } else {
            self.backgroundColor = .clear
            //titleLabel.textColor = UIColor(named: "black")
        }
    }
    
    // 셀의 높이와 너비 중 작은 값을 리턴한다
    func minSize() -> CGFloat {
        let width = contentView.bounds.width - 10
        let height = contentView.bounds.height - 10
        
        return (width > height) ? height : width
    }
}
