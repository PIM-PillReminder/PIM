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
    let backButton = UIButton()
    let monthLabel = UILabel()
    let infoButton = UIButton()
    
    let bottomView = UIView()
    let bottomBackground = UIView()
    let dateLabel = UILabel()
    let todayLabel = UILabel()
    let pillLabel = UILabel()
    let pillImageView = UIImageView()
    let timeLabel = UILabel()
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        
    }
    
    func configureHierarchy() {
        view.addSubview(calendar)
        view.addSubview(backButton)
        view.addSubview(monthLabel)
        view.addSubview(infoButton)
        view.addSubview(bottomBackground)
        view.addSubview(bottomView)
        view.addSubview(dateLabel)
        view.addSubview(todayLabel)
        view.addSubview(pillLabel)
        view.addSubview(pillImageView)
        view.addSubview(timeLabel)
    }
    
    func configureConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.leading.equalTo(view).inset(16)
        }
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(view).inset(16)
            make.centerX.equalTo(view)
        }
        
        infoButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view).inset(16)
        }
        
        calendar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(UIScreen.main.bounds.height * 0.65)
        }
        
        bottomBackground.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.horizontalEdges.equalTo(view)
            make.bottom.equalTo(view).inset(-50)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(70)
        }
        
        pillLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).offset(20)
            make.leading.equalTo(bottomView.snp.leading).offset(16)
            make.centerY.equalTo(bottomView)
        }
        
        pillImageView.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).offset(20)
            make.trailing.equalTo(bottomView.snp.trailing).inset(16)
            make.centerY.equalTo(bottomView)
            make.size.equalTo(30)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func infoButtonTapped() {
        let infoViewController = CalendarInfoViewController()
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.modalTransitionStyle = .crossDissolve
        
        infoViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        present(infoViewController, animated: true)
        
        infoViewController.dismissalCompletion = { [weak self] in
            self?.view.backgroundColor = .white
        }
    }
    
    func configureView() {
        
        bottomBackground.backgroundColor = UIColor(named: "settingChevronDisabledGray")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 M월"
        let title = dateFormatter.string(from: Date())
        
        monthLabel.text = title
        monthLabel.textColor = .black
        monthLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        configureCalendar()
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 16
        
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.textColor = .black
        
        pillLabel.text = "n번째 미뉴렛정 복용 완료"
        pillLabel.font = .systemFont(ofSize: 16, weight: .medium)
        pillLabel.textColor = .black
        
        pillImageView.image = UIImage(named: "calendar_green")
    }
}

extension CalendarViewController {
    func configureCalendar() {
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
        calendar.allowsMultipleSelection = false
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
            cell.backImageView.backgroundColor = .clear
        } else if date < today {
            cell.backImageView.image = UIImage(named: "calendar_green")
        } else {
            cell.backImageView.image = UIImage(named: "calendar_red")
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        dateLabel.text = dateFormatter.string(from: date)
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
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 M월"
        let title = dateFormatter.string(from: calendar.currentPage)
        monthLabel.text = title
    }
}

#Preview {
    CalendarViewController()
}
