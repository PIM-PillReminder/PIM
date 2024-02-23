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

        view.addSubview(calendar)
        configureHierarchy()
        configureView()
    }
    
    func configureHierarchy() {
        calendar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(UIScreen.main.bounds.height * 0.6)
        }
    }
    
    func configureView() {
        
        // MARK: Calendar View
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.setCurrentPage(Date(), animated: true)
        calendar.select(Date())
        
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
            
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.todaySelectionColor = .clear
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleWeekendColor = .black
        calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 14)
        calendar.appearance.eventDefaultColor = UIColor(named: "primaryGreen")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        calendar.weekdayHeight = 10
        calendar.calendarHeaderView.isHidden = true
        
        calendar.scrollDirection = .vertical
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }

        // TODO: 약 먹었는지 검사 후 green / red 분리
        let today = Date()
        if Calendar.current.isDate(date, equalTo: today, toGranularity: .day) &&
            Calendar.current.isDate(date, equalTo: today, toGranularity: .month) &&
            Calendar.current.isDate(date, equalTo: today, toGranularity: .year) {
            cell.backImageView.image = UIImage(named: "calendar_today")
            cell.backImageView.backgroundColor = .white
        } else {
            cell.backImageView.image = UIImage(named: "calendar_green")
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("🐶")
    }
}

#Preview {
    CalendarViewController()
}
