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
    
    // var pillStatusList: [PillStatus] = []
    
    let calendar = FSCalendar()
    let backButton = UIButton()
    let monthLabel = UILabel()
    let infoButton = UIButton()
    
    let bottomView = UIView()
    let bottomBackground = UIView()
    let dateLabel = UILabel()
    let todayLabel = UILabel()
    let pillLabel = UILabel()
    let pillTimeImage = UIImageView()
    let pillTakenTimeLabel = UILabel()
    let pillImageView = UIImageView()
    let timeLabel = UILabel()
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        // fetchPillStatusData()
    }
//    
//    func fetchPillStatusData() {
//        // FireStoreManager의 인스턴스를 통해 데이터를 가져온다고 가정
//        let firestoreManager = FireStoreManager()
//        firestoreManager.fetchData()
//
//        // Firestore에서 데이터를 불러와 pillStatusList에 할당
//        self.pillStatusList = firestoreManager.pillStatusList
//
//        // 배열 전체를 출력
//        print("Pill Status List 전체 출력:")
//        for pillStatus in pillStatusList {
//            print("날짜: \(pillStatus.pillDate), 약 먹었는지: \(pillStatus.isPillEaten)")
//        }
//        
//        self.calendar.reloadData() // 캘린더를 다시 로드하여 데이터를 반영
//    }
    
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
        view.addSubview(pillTimeImage)
        view.addSubview(pillTakenTimeLabel)
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
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(70)
        }
        
        pillLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).offset(12)
            make.leading.equalTo(bottomView.snp.leading).offset(18)
        }
        
        pillTimeImage.snp.makeConstraints { make in
            make.top.equalTo(pillLabel.snp.bottom).offset(3)
            make.leading.equalTo(bottomView.snp.leading).offset(18)
            make.size.equalTo(17)
        }
        
        pillTakenTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(pillLabel.snp.bottom).offset(6)
            make.leading.equalTo(pillTimeImage.snp.trailing).offset(6)
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
        
        bottomBackground.backgroundColor = UIColor(named: "gray02")
        
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
        dateLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dateLabel.textColor = .black
        
        pillLabel.text = "복용 완료"
        pillLabel.font = .systemFont(ofSize: 18, weight: .medium)
        pillLabel.textColor = .black
        
        pillTimeImage.image = UIImage(named: "clock")
        
        pillTakenTimeLabel.text = "오후 5:13"
        pillTakenTimeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        pillTakenTimeLabel.textColor = UIColor(named: "gray07")
        
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
        calendar.appearance.titleTodayColor = UIColor(named: "black")
        calendar.appearance.titleDefaultColor = UIColor(named: "black")
        calendar.appearance.titleWeekendColor = UIColor(named: "black")
        calendar.appearance.weekdayFont = .systemFont(ofSize: 14, weight: .light)
        calendar.appearance.weekdayTextColor = UIColor(named: "gray08")
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
        
        let today = Calendar.current.startOfDay(for: Date())
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        // UserDefaultsManager를 통해 pillEatenStatus 값 가져오기
        let pillStatus = UserDefaultsManager.shared.getPillStatus()
        
        if startOfDay > today {
            // 오늘 이후의 날짜는 이미지를 비워둠
            cell.backImageView.image = nil
        } else if let isPillEaten = pillStatus[startOfDay] {
            // 날짜에 따른 약 복용 여부를 설정
            if isPillEaten {
                cell.backImageView.image = UIImage(named: "calendar_green")
            } else {
                cell.backImageView.image = UIImage(named: "calendar_red")
            }
        } else {
            // 약 복용 여부를 체크하지 않은 경우
            cell.backImageView.image = UIImage(named: "calendar_today")
        }
        
        cell.backImageView.backgroundColor = .clear
        cell.isToday = Calendar.current.isDateInToday(date)
        
        return cell
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        dateLabel.text = dateFormatter.string(from: date)
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        // UserDefaultsManager에서 해당 날짜의 pill status를 가져와 pillLabel 업데이트
        let pillStatus = UserDefaultsManager.shared.getPillStatus()
        
        if let isPillEaten = pillStatus[startOfDay] {
            if isPillEaten {
                pillLabel.text = "피임약 복용 완료"
            } else {
                pillLabel.text = "안먹었어요"
                pillImageView.image = UIImage(named: "calendar_red")
            }
        } else {
            pillLabel.text = "안먹었어요"
        }

        if selectedDate != nil {
            calendar.reloadData()
        }
    }
}


//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY년 M월"
//        let title = dateFormatter.string(from: calendar.currentPage)
//        monthLabel.text = title
//    }
//}


#Preview {
    CalendarViewController()
}
