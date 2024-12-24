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
            make.size.equalTo(28)
        }
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
        
        // 배경을 위한 뷰를 생성합니다 (아직 없다면)
        if self.backgroundView == nil {
            let backgroundView = UIView()
            backgroundView.layer.cornerRadius = 21 // 원하는 모서리 반경으로 조정
            self.backgroundView = backgroundView
        }
        
        if isToday {
            if isSelected {
                self.backgroundView?.backgroundColor = UIColor(named: "gray11")
                // 라이트 모드와 다크 모드에 따른 텍스트 색상 설정
                if traitCollection.userInterfaceStyle == .dark {
                    titleLabel.textColor = .black
                } else {
                    titleLabel.textColor = .white
                }
            } else {
                self.backgroundView?.backgroundColor = UIColor(named: "gray03")
            }
        } else if isSelected {
            self.backgroundView?.backgroundColor = UIColor(named: "gray11")
            if traitCollection.userInterfaceStyle == .dark {
                titleLabel.textColor = .black
            } else {
                titleLabel.textColor = .white
            }
        } else {
            self.backgroundView?.backgroundColor = .clear
        }
        
        // 배경 뷰의 크기를 조정
        self.backgroundView?.frame = CGRect(x: bounds.width * 0.1,
                                            y: bounds.height * 0,
                                            width: bounds.width * 0.8,
                                            height: bounds.height * 1)
    }
    
    // 셀의 높이와 너비 중 작은 값을 리턴한다
    func minSize() -> CGFloat {
        let width = contentView.bounds.width - 10
        let height = contentView.bounds.height - 10
        
        return (width > height) ? height : width
    }
}
