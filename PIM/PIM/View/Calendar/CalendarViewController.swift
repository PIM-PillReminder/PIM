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
    var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(calendar)
        configureHierarchy()
        configureView()
        
    }

    func configureHierarchy() {
        calendar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(-24)
            make.height.equalTo(UIScreen.main.bounds.height * 0.65)
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
        
        calendar.scope = .month
        
        calendar.appearance.todaySelectionColor = .clear
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleWeekendColor = .black
        calendar.appearance.weekdayFont = .systemFont(ofSize: 14, weight: .light)
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.eventDefaultColor = UIColor(named: "primaryGreen")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        calendar.weekdayHeight = 60
       
        calendar.calendarHeaderView.isHidden = true
        calendar.placeholderType = .fillHeadTail
        calendar.scrollDirection = .vertical
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }

        cell.clipsToBounds = true
        cell.layer.cornerRadius = 21
        
        // TODO: 약 먹었는지 검사 후 green / red 분리
        let today = Date()
        if Calendar.current.isDate(date, equalTo: today, toGranularity: .day) &&
            Calendar.current.isDate(date, equalTo: today, toGranularity: .month) &&
            Calendar.current.isDate(date, equalTo: today, toGranularity: .year) {
            cell.backImageView.image = UIImage(named: "calendar_today")
            cell.backImageView.backgroundColor = .white
        } else if date < today {
            cell.backImageView.image = UIImage(named: "calendar_green")
        } else {
            cell.backImageView.image = UIImage(named: "calendar_red")
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        if selectedDate != nil {
            calendar.reloadData()
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if let selectedDate = selectedDate, Calendar.current.isDate(selectedDate, inSameDayAs: date) {
            return .black
        }
        return nil
    }

}

#Preview {
    CalendarViewController()
}
