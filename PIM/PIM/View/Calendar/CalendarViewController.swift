//
//  CalendarViewController.swift
//  PIM
//
//  Created by Madeline on 2/23/24.
//

import FSCalendar
import SnapKit
import UIKit

class CalendarViewController: UIViewController {
    
     let calendar = FSCalendar()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureView()
    }
    
    func configureHierarchy() {
        calendar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(48)
            make.height.equalTo(UIScreen.main.bounds.height * 0.6)
        }
    }
    
    func configureView() {
        view.addSubview(calendar)
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleWeekendColor = .black
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.eventDefaultColor = UIColor(named: "primaryGreen")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.scrollDirection = .vertical
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
}
